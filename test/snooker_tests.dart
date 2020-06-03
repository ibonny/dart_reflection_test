import 'package:dart_reflection_test/snooker.dart';
import 'package:test/test.dart';

@Component
class BaseService {
  String testFunction() {
    return "This is a test function.";
  }
}

@Autowired
BaseService base;

@Named("myNamedClass")
@Component
class NamedClass {
  String testFunction() {
    return "This is a named class.";
  }
}

class ChildClass {
  String testout() {
    return "ChildClassOne";
  }
}

@Configuration
class ConfigClass {
  @Bean
  ChildClass getChildClass() {
    return ChildClass();
  }
}

@Autowired
ChildClass bc;

const List<String> lines = ["key1 = value1", "key2 = value2"];

@PropertySource("", lines)
class LoadedConfigClass {
  @Value("key1")
  String key1;

  @Value("key2")
  String key2;
}

void main(List<String> args) {
  Snooker.init();

  test('Autowires should get values from Component classes.', () {
    expect(base, isNot(null));

    expect(base.testFunction(), 'This is a test function.');
  });

  test(
      'Named component classes should be accessible from getObject with the name.',
      () {
    final named = Snooker.getObject("myNamedClass");

    expect(named, isNot(null));

    expect(named.testFunction(), 'This is a named class.');
  });

  test('Beans get instantiated properly.', () {
    final isChildOne = bc is ChildClass;

    expect(isChildOne, true);

    expect(bc.testout(), "ChildClassOne");
  });

  test("Config values get loaded properly.", () {
    final lcc = Snooker.getObject("LoadedConfigClass");

    expect(lcc.key1, "value1");
    expect(lcc.key2, "value2");
  });
}
