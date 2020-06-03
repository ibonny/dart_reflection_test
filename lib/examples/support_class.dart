import 'package:dart_reflection_test/snooker.dart';

class SupportClass {
  String testout() => "This is a test string.";
}

@Configuration
class SupportConfig {
  @Bean
  SupportClass getSupportClass() {
    return SupportClass();
  }
}

@PropertySource("lib/examples/testout.ini")
class MyConfigClass {
  @Value("first.value")
  String first;

  @Value("third.value")
  double third;
}
