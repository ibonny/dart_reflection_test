import 'package:dart_reflection_test/snooker.dart';

// This will be a singleton class that's instantiated.
// Right now, the loading of only one file per class is supported.
@PropertySource("lib/examples/testout.ini")
class ConfigClass {
  @Value("first.value")
  String firstValue;

  @Value("second.value")
  String secondValue;

  // This value will be auto-translated from String to double. String to int also works.
  @Value("third.value")
  double thirdValue;
}

// Instantiation works via getObject() or @Autowired.
@Autowired
ConfigClass mcc;

void main() {
  Snooker.init();

  print('======= via @Autowired =======');

  print(mcc.firstValue);

  print(mcc.secondValue);

  print(mcc.thirdValue);

  final mcc2 = Snooker.getObject("ConfigClass");

  print('======= via getObject() =======');

  print(mcc2.firstValue);

  print(mcc2.secondValue);

  print(mcc2.thirdValue);

  print(mcc2.someOtherValue);
}
