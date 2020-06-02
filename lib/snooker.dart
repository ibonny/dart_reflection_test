import 'dart:mirrors';

const Component = "Component";

const Autowired = "Autowired";

const Configuration = "Configuration";

const Bean = "Bean";

class Named {
  final String name;

  const Named([this.name]);
}

class Snooker {
  static Map<Object, Object> registrations = Map();

  static Map getDeclarations() {
    final mirrors = currentMirrorSystem();

    final f = mirrors.isolate.rootLibrary.declarations;

    return f;
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

    print("Registrations: $registrations");
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
          print("This is a method mirror.");

          MethodMirror m = registrations[v.type];

          lib.setField(k, m());
        }

        lib.setField(k, v.type.newInstance(Symbol(''), []).reflectee);
      }
    });
  }

  static dynamic getObject(String name) {
    if (!registrations.containsKey(name)) return null;

    return (registrations[name] as ClassMirror).newInstance(Symbol(''), []).reflectee;
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

  static getAllConfigurations() {
    getDeclarations().forEach((k, v) {
      if (v.metadata.length == 0) {
        return;
      }

      for (var attr in v.metadata) {
        if (attr.reflectee != "Configuration") {
          continue;
        }

        print(v.declarations);

        v.declarations.forEach((k2, v2) {
          if (v2.metadata.length == 0) {
            return;
          }

          if (!isBean(v2)) {
            return;
          }

          registrations[v2.returnType] = v2;
        });
      }
    });
  }

  static run() {
    getAllComponents();

    getAllConfigurations();

    print(registrations);

    processAutowired();
  }
}
