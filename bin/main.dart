import 'dart:mirrors';

const tag = "tag";

class Foo {
  const Foo(int val);
}

@tag
String newValue() {
  return "Yo.";
}

@Foo(10)
String testout(int val) {
  return (val * 10).toString();
}

@Foo(20)
class MyNewClass {}

void main(List<String> args) {
  print(testout(10));

  var mirrors = currentMirrorSystem();

  print(mirrors.isolate.rootLibrary.declarations);

  var f = mirrors.isolate.rootLibrary.declarations[Symbol("newValue")];

  print(f.metadata.first.reflectee);

  mirrors.isolate.rootLibrary.declarations.forEach((k, v) {
    if (v.metadata.length > 0) {
      print("$k, $v, ${v.metadata.first.reflectee}");
    } else {
      print("$k, $v");
    }
  });
}
