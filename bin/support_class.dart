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
