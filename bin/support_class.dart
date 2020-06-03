import '../lib/snooker.dart';

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

@PropertySource("testout.ini")
class MyConfigClass {
  @Value("first.value")
  String first;

  @Value("third.value")
  double third;
}
