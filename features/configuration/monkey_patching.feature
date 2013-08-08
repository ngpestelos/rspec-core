Feature: Monkey patching

  Use the monkey patching to tell RSpec to allow or disallow the top level dsl.

  Scenario: by default RSpec allows the top level monkey patching
    Given a file named "spec/example_spec.rb" with:
      """ruby
      describe "specs here" do
        it "passes" do
        end
      end
      """
   When I run `rspec`
   Then the output should contain "1 example, 0 failures"

  Scenario: when monkey patch is disabled top level dsl no longer works
    Given a file named "config.rb" with:
      """ruby
        RSpec.configure { |c| c.enable_monkey_patching = false }
      """
    Given a file named "spec/example_spec.rb" with:
      """ruby
      describe "specs here" do
        it "passes" do
        end
      end
      """
   When I run `rspec -r ./config.rb`
   Then the output should contain "undefined method `describe'"

  Scenario: regardless of setting
    Given a file named "config.rb" with:
      """ruby
        RSpec.configure { |c| c.enable_monkey_patching = false }
      """
    Given a file named "spec/example_spec.rb" with:
      """ruby
      RSpec.describe "specs here" do
        it "passes" do
        end
      end
      """
   When I run `rspec -r ./config.rb`
   Then the output should contain "1 example, 0 failures"
