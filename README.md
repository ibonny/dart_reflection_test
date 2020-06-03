# Snooker

This library is my first attempt at a Dependency Injection framework like Spring Boot.
It doesn't yet handle many things, but starts out with these features:

* Component, Named and Autowired annotations
* Configuration and Bean annotattions
* PropertySource and Value annotations

It doesn't handle **all** cases of annotations, either. Right now, the library only saerches
two layers deep (the main program and it's direct dependencies) for annotations, and only
handles some properties within the context of other annotations such as:

* ``@Value`` annotations must be within the context of a ``@PropertySource`` annotated class
* ``@Bean`` annotations must be within the context of a ``@Configuration`` annotated class.
* ``@Component`` and ``@Named`` definitions must occur before any ``@Autowired`` annotations.

Examples for all of these will be in the examples directory of the repo.

The ``@PropertySource`` and ``@Value`` annotations work by loading a config file via ``@PropertySource``
loading an ``.ini`` based file and then making the values available via ``@Value``. An example is:

```
@PropertySource("my_config_file.ini")
class ConfigClass {
    @Value("my.value.property")
    String valueProperty;
}
```

Then, the ConfigClass needs to be instantiated via the ``getObject()`` static function call like so:

```
Snooker.run()

final myConfigClass = Snooker.getObject("ConfigClass");

print(myConfigClass.valueProperty);
```

Another restriction that holds right now is that ``@Autowired`` tags don't work in ``@Component`` classes.
This will be implemented soon to assist with dependency injection of services, but right now, only library
``@Autowired`` injection is supported.

For ``@Value`` annotations, String, int and double types are supported, and auto-converted from String variables
within the config file.
