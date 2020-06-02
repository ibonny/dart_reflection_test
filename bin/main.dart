import '../lib/snooker.dart';

// @Component
// @Named("testout")
class MyTestClass {
  MyTestClass() {}
}

@Configuration
class MyConfig {
  @Bean
  MyTestClass getMyClass() {
    return MyTestClass();
  }
}

@Autowired
MyTestClass v;

void main() {
  Snooker.run();

  print(v);
}
