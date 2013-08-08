extend RSpec::Core::DSL
extend RSpec::Core::SharedExampleGroup::TopLevelDSL
Module.send :include, RSpec::Core::DSL
Module.send :include, RSpec::Core::SharedExampleGroup::TopLevelDSL
