import 'package:dart_reflection_test/snooker.dart';

@Component
class MyAutowiredClass {
  String someFunc() {
    return "This is a test.";
  }
}

@Autowired
MyAutowiredClass mac;

void main() {
  Snooker.init();

  print(mac.someFunc());
}
