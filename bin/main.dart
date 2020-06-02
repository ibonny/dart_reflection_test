import '../lib/snooker.dart';

@Named("testout")
@Component
class MyTestClass {
  MyTestClass() {}
}

@Autowired
MyTestClass v;

void main() {
  Snooker.run();

  print(v);
}
