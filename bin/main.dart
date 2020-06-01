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

void main(List<String> args) {
  print(testout(10));

  var mirrors = currentMirrorSystem();

  var f = mirrors.isolate.rootLibrary.declarations[Symbol("newValue")];

  print(f.metadata.first.reflectee);
}
