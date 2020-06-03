import 'dart:io';
import 'dart:mirrors';

import 'package:ini/ini.dart';

const Component = "Component";

const Autowired = "Autowired";

const Configuration = "Configuration";

const Bean = "Bean";

class Value {
  final String name;

  const Value(this.name);
}

class PropertySource {
  final String filename;

  const PropertySource(this.filename);
}

class Named {
  final String name;

  const Named([this.name]);
}

Map holding = {};

class Snooker {
  static Map<Object, Object> registrations = Map();

  static Map<Object, Object> owningClass = Map();

  static List<Config> configs;

  static Map getDeclarations() {
    final mirrors = currentMirrorSystem();

    var finalMap = {};

    // Get all the declarations from the rootLibrary (usually main library) and add them to the map.
    mirrors.isolate.rootLibrary.declarations.forEach((key, value) {
      finalMap[key] = value;
    });

    // Get all the declarations from the libraries in the root library and add them to the map.
    mirrors.isolate.rootLibrary.libraryDependencies.forEach((element) {
      element.targetLibrary.declarations.forEach((key, value) {
        finalMap[key] = value;
      });
    });

    return finalMap;
  }

  static String getName(item) {
    if (item.metadata.length == 0) {
      return null;
    }

    for (var m in item.metadata) {
      if (m.reflectee is Named) {
        return m.reflectee.name;
      }
    }

    return null;
  }

  static void getAllComponents() {
    getDeclarations().forEach((k, v) {
      if (v.metadata.length == 0) {
        return;
      }

      if (v.metadata.first.reflectee == "Component") {
        final name = getName(v);

        if (name != null) {
          registrations[name] = v;
        } else {
          registrations[v] = v;
        }
      }
    });
  }

  static void processAutowired() {
    final mirrors = currentMirrorSystem();

    var lib;

    mirrors.libraries.forEach((k, v) {
      if (k.toString().contains("main.dart")) {
        lib = v;
      }
    });

    getDeclarations().forEach((k, v) {
      if (v.metadata.length == 0) {
        return;
      }

      if (v.metadata.first.reflectee == "Autowired") {
        if (!registrations.containsKey(v.type)) {
          return;
        }

        if (registrations[v.type] is MethodMirror) {
          MethodMirror m = registrations[v.type];

          final cm = owningClass[v.type];

          final mm = reflect(cm);

          // Invoke the function to create the class.
          lib.setField(k, mm.invoke(m.simpleName, []).reflectee);

          return;
        }

        lib.setField(k, v.type.newInstance(Symbol(''), []).reflectee);
      }
    });
  }

  static dynamic getObject(String name) {
    if (holding.containsKey(Symbol(name))) {
      return holding[Symbol(name)];
    }

    if (registrations.containsKey(name)) {
      return (registrations[name] as ClassMirror)
          .newInstance(Symbol(''), []).reflectee;
    }

    var foundObj = null;

    registrations.forEach((k, v) {
      if (k.toString() == "ClassMirror on '$name'") {
        foundObj = k;
      }
    });

    if (foundObj != null) {
      return foundObj.newInstance(Symbol(''), []).reflectee;
    }

    return null;
  }

  static bool isBean(item) {
    if (item.metadata.length == 0) {
      return false;
    }

    for (var i in item.metadata) {
      if (i.reflectee == "Bean") {
        return true;
      }
    }

    return false;
  }

  static bool isValue(item) {
    if (item.metadata.length == 0) {
      return false;
    }

    for (var i in item.metadata) {
      if (i.reflectee is Value) {
        return true;
      }
    }

    return false;
  }

  static getAllConfigurations() {
    getDeclarations().forEach((k, v) {
      if (v.metadata.length == 0) {
        return;
      }

      for (var attr in v.metadata) {
        if (attr.reflectee != "Configuration") {
          continue;
        }

        v.declarations.forEach((k2, v2) {
          if (v2.metadata.length == 0) {
            return;
          }

          if (!isBean(v2)) {
            return;
          }

          registrations[v2.returnType] = v2;

          owningClass[v2.returnType] = v.newInstance(Symbol(''), []).reflectee;
        });
      }
    });
  }

  static void loadConfigFiles() {
    // Loop through all definitions in the main and imported libraries.
    getDeclarations().forEach((key, value) {
      // If the symbol has no metadata, skip to the next.
      if (value.metadata.length == 0) {
        return;
      }

      // Skip through all the attributes in the metadata...
      for (var attr in value.metadata) {
        // ... and skip it if it's not a PropertySource.
        if (!(attr.reflectee is PropertySource)) {
          continue;
        }

        // If it is...
        PropertySource ps = attr.reflectee;

        // ... grab the lines referenced in the filename,
        final lines = File(ps.filename).readAsLinesSync();

        // ... and interpret them as a config file.
        final config = Config.fromStrings(lines);

        // Then, go through all the fields in the PropertySource'd class.
        value.declarations.forEach((k2, v2) {
          // Skip if there is no metadata attached.
          if (v2.metadata.length == 0) {
            return;
          }

          // Skip if the metadata is not a @Value annotation.
          if (!isValue(v2)) {
            return;
          }

          // Get the name attached to the @Value annotation.
          String valueKey = v2.metadata.first.reflectee.name;

          // If the key mentioned in the @Value annotation doesn't exist, skip.
          // (Optionally throw an exception here.)
          if (!config.defaults().containsKey(valueKey)) {
            return;
          }

          // Instantiate the object that is @PropertySource'd in a holding area if
          // it doesn't already exist.
          if (!holding.containsKey(key)) {
            holding[key] = value.newInstance(Symbol(''), []).reflectee;
          }

          // Get a reference to it.
          final ref = reflect(holding[key]);

          // And set the variable in question to the @Value's value.
          // Cast it to an int if an int.
          if (v2.type.reflectedType.toString() == "int") {
            ref.setField(k2, int.parse(config.defaults()[valueKey]));
          }
          if (v2.type.reflectedType.toString() == "double") {
            ref.setField(k2, double.parse(config.defaults()[valueKey]));
          } else {
            ref.setField(k2, config.defaults()[valueKey]);
          }
        });
      }
    });
  }

  static run() {
    getAllComponents();

    getAllConfigurations();

    loadConfigFiles();

    print("Registrations: $registrations");

    processAutowired();
  }
}
