import '../lib/snooker.dart';

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
    return MyTestClass();
  }
}

@Autowired
BaseClass v;

@Autowired
SupportClass sc;

void main() {
  Snooker.run();

  print(v.testout());

  print(sc.testout());
}
