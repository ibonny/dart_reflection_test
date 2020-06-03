import 'package:dart_reflection_test/snooker.dart';

import 'support_class.dart';

abstract class BaseClass {
  String testout();
}

// @Component
// @Named("testout")
class MyTestClass implements BaseClass {
  MyTestClass() {}

  @override
  String testout() {
    return "First String";
  }
}

class SecondTestClass implements BaseClass {
  MyTestClass() {}

  @override
  String testout() {
    return "Second String";
  }
}

@Configuration
class MyConfig {
  @Bean
  BaseClass getMyClass() {
    return SecondTestClass();
  }
}

@Component
class TestService {
  String stuffString() {
    return "Yeah, it works.";
  }
}

// @Component
// class TestingClass {
//   // This doesn't work yet.
//   @Autowired
//   TestService ts;

//   String testout() {
//     return ts.stuffString();
//   }
// }

@Autowired
BaseClass v;

@Autowired
SupportClass sc;

void main() {
  Snooker.run();

  print(v.testout());

  print(sc.testout());

  final mcc = Snooker.getObject("MyConfigClass");

  print(mcc.first);

  print(mcc.third);
}
