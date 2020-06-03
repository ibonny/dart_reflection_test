import 'package:dart_reflection_test/snooker.dart';

// Change this value to decide whether or not to use the first or second class.
var useFirstClass = true;

abstract class MyBaseClass {
  String someFunc();
}

class FirstClass extends MyBaseClass {
  @override
  String someFunc() => "My First Class.";
}

class SecondClass extends MyBaseClass {
  @override
  String someFunc() => "My Second Class.";
}

@Configuration
class ConfigClass {
  @Bean
  MyBaseClass getMyClass() {
    if (useFirstClass) {
      return FirstClass();
    }

    return SecondClass();
  }
}

// This only allows access to the class behind the @Bean once (I.E. if you change
// the underlying variable, the reference doesn't change)
@Autowired
MyBaseClass mbc;

void main() {
  Snooker.init();

  // Dynamically produce a class based on config values:
  print(mbc.someFunc());

  // Also use getObject() to retrieve the class, which allows for more dynamic access:
  useFirstClass = false;

  final mbc2 = Snooker.getObject("MyBaseClass");

  print(mbc2.someFunc());
}
