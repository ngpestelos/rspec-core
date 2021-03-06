Feature: User-defined metadata

  You can attach user-defined metadata to any example group or example.
  Pass a hash as the last argument (before the block) to `describe`,
  `context` or `it`.  RSpec supports many configuration options that apply
  only to certain examples or groups based on the metadata.

  Metadata defined on an example group is available (and can be overridden)
  by any sub-group or from any example in that group or a sub-group.

  In addition, you can specify metdata using just symbols.
  Each symbol passed as an argument to `describe`, `context` or `it` will
  be a key in the metadata hash, with a corresponding value of `true`.

  Scenario: define group metadata using a hash
    Given a file named "define_group_metadata_with_hash_spec.rb" with:
      """ruby
      describe "a group with user-defined metadata", :foo => 17 do
        it 'has access to the metadata in the example' do |example|
          example.metadata[:foo].should eq(17)
        end

        it 'does not have access to metadata defined on sub-groups' do |example|
          example.metadata.should_not include(:bar)
        end

        describe 'a sub-group with user-defined metadata', :bar => 12 do
          it 'has access to the sub-group metadata' do |example|
            example.metadata[:foo].should eq(17)
          end

          it 'also has access to metadata defined on parent groups' do |example|
            example.metadata[:bar].should eq(12)
          end
        end
      end
      """
    When I run `rspec define_group_metadata_with_hash_spec.rb`
    Then the examples should all pass

  Scenario: define example metadata using a hash
    Given a file named "define_example_metadata_with_hash_spec.rb" with:
      """ruby
      describe "a group with no user-defined metadata" do
        it 'has an example with metadata', :foo => 17 do |example|
          example.metadata[:foo].should eq(17)
          example.metadata.should_not include(:bar)
        end

        it 'has another example with metadata', :bar => 12, :bazz => 33 do |example|
          example.metadata[:bar].should eq(12)
          example.metadata[:bazz].should eq(33)
          example.metadata.should_not include(:foo)
        end
      end
      """
    When I run `rspec define_example_metadata_with_hash_spec.rb`
    Then the examples should all pass

  Scenario: override user-defined metadata
    Given a file named "override_metadata_spec.rb" with:
      """ruby
      describe "a group with user-defined metadata", :foo => 'bar' do
        it 'can be overridden by an example', :foo => 'bazz' do |example|
          example.metadata[:foo].should == 'bazz'
        end

        describe "a sub-group with an override", :foo => 'goo' do
          it 'can be overridden by a sub-group' do |example|
            example.metadata[:foo].should == 'goo'
          end
        end
      end
      """
    When I run `rspec override_metadata_spec.rb`
    Then the examples should all pass

  Scenario: less verbose metadata
    Given a file named "less_verbose_metadata_spec.rb" with:
      """ruby
      describe "a group with simple metadata", :fast, :simple, :bug => 73 do
        it 'has `:fast => true` metadata' do |example|
          example.metadata[:fast].should == true
        end

        it 'has `:simple => true` metadata' do |example|
          example.metadata[:simple].should == true
        end

        it 'can still use a hash for metadata' do |example|
          example.metadata[:bug].should eq(73)
        end

        it 'can define simple metadata on an example', :special do |example|
          example.metadata[:special].should == true
        end
      end
      """
    When I run `rspec less_verbose_metadata_spec.rb`
    Then the examples should all pass
