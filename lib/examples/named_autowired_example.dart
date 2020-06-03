import 'package:dart_reflection_test/snooker.dart';

@Component
@Named("MyAutowiredName")
class MyAutowiredClass {
  String someFunc() {
    return "Some Autowired Func.";
  }
}

void main() {
  Snooker.init();

  // This works with both the named name:
  final first = Snooker.getObject("MyAutowiredName");

  print(first.someFunc());

  // ... or the class name:
  final second = Snooker.getObject("MyAutowiredClass");

  print(second.someFunc());
}
