import 'dart:mirrors';

const Component = "Component";

const Autowired = "Autowired";

class Snooker {
  static Map<Object, Object> registrations = Map();

  static Map getDeclarations() {
    final mirrors = currentMirrorSystem();

    final f = mirrors.isolate.rootLibrary.declarations;

    return f;
  }

  static void getAllComponents() {
    getDeclarations().forEach((k, v) {
      if (v.metadata.length == 0) {
        return;
      }

      if (v.metadata.first.reflectee == "Component") {
        registrations[v] = v;
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

        lib.setField(k, v.type.newInstance(Symbol(''), []).reflectee);
      }
    });
  }

  static run() {
    getAllComponents();

    processAutowired();
  }
}
