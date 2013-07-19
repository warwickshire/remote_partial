require 'test_helper'

module RemotePartial
  class YamlStoreTest < ActiveSupport::TestCase

    def teardown
      File.delete(YamlStore.file) if File.exists?(YamlStore.file)
    end

    def test_root
      assert_equal(test_db_path, YamlStore.root)
    end
    
    def test_file
      expected = File.expand_path('remote_partial/yaml_stores.yml', test_db_path)
      assert_equal(expected, YamlStore.file)
    end

    def test_dir
      expected = File.expand_path('remote_partial', test_db_path)
      assert_equal(expected, YamlStore.dir)
    end

    def test_write
      assert !File.exists?(YamlStore.file), "File should not exist: #{YamlStore.file}"
      @test = {'this' => {'foo' => 'bar'}}
      YamlStore.write(@test)
      assert File.exists?(YamlStore.file), "File should be found: #{YamlStore.file}"
    end

    def test_read
      test_write
      assert_equal @test, YamlStore.read
    end

    def test_read_when_no_file_exists
      assert_equal({}, YamlStore.read)
    end

    def test_merge!
      test_write
      new_content = {'some' => {'thing' => 'else'}}
      YamlStore.merge!({'some' => {'thing' => 'else'}})
      assert_equal @test.merge(new_content), YamlStore.read
    end

    def test_new
      name = 'Bob'
      yaml_store = YamlStore.new(name: name)
      assert_equal name, yaml_store.name
    end

    def test_save
      hash = {name: 'Foo', colour:'Red'}
      yaml_store = YamlStore.new(hash)
      yaml_store.save
      expected = {hash[:name] => {'colour' => hash[:colour]}.merge(yaml_store.time_stamps)}
      assert_equal expected, YamlStore.read
    end

    def test_save_without_a_name
      hash = {foo: 'bar'}
      yaml_store = YamlStore.new(hash)
      assert_raise RuntimeError do
        yaml_store.save
      end
    end

    def test_create
      hash = {name: 'Foo', colour:'Red'}
      yaml_store = YamlStore.create(hash)
      expected = {hash[:name] => {'colour' => hash[:colour]}.merge(yaml_store.time_stamps)}
      assert_equal expected, YamlStore.read
    end

    def test_find
      @name = 'Foo'
      @content = 'Bar'
      YamlStore.create(name: @name, content: @content)
      yaml_store = YamlStore.find(@name)
      assert_equal @name, yaml_store.name
      assert_equal @content, yaml_store.content
    end

    def test_find_when_none_exist
      assert_nil YamlStore.find(:foo), "Should return nil if no match found"
    end

    def test_find_with_symbol
      test_find
      yaml_store = YamlStore.find(@name.to_sym)
      assert_equal @name, yaml_store.name
      assert_equal @content, yaml_store.content
    end

    def test_all
      yaml_store = YamlStore.create(name: 'Foo', colour:'Red')
      yaml_store_2 = YamlStore.create(name: 'Bar', colour:'Red')
      assert_equal([yaml_store, yaml_store_2], YamlStore.all)
    end

    def test_all_with_no_items
      assert_equal([], YamlStore.all)
    end

    def test_count
      assert_equal 0, YamlStore.count
      test_create
      assert_equal 1, YamlStore.count
    end

    def test_created_at
      yaml_store = YamlStore.create(name: 'foo')
      assert  yaml_store.created_at.kind_of?(Time), 'create_at should be a Time'
      assert 1.minute.ago < yaml_store.created_at, 'created_at should be within the last minute'
    end

    def test_created_at_not_updated_if_exists
      time = 1.day.ago
      yaml_store = YamlStore.create(name: 'foo', created_at: time)
      assert_equal(time, yaml_store.created_at)
    end

    def test_updated_at
      yaml_store = YamlStore.create(name: 'foo')
      assert  yaml_store.updated_at.kind_of?(Time), 'updated_at should be a Time'
      assert 1.minute.ago < yaml_store.updated_at, 'updated_at should be within the last minute'
    end

    def test_updated_at_if_updated_if_exists
      time = 1.day.ago
      yaml_store = YamlStore.create(name: 'foo', updated_at: time)
      assert 1.minute.ago < yaml_store.updated_at, 'updated_at should be within the last minute'
    end

    def test_string_keys
      sample = {:this => 'that', 'foo' => 'bar'}
      expected = {'this' => 'that', 'foo' => 'bar'}
      assert_equal(expected, YamlStore.string_keys(sample))
    end

    def test_db_path
      File.expand_path('../../dummy/test/db', File.dirname(__FILE__))
    end
  end
end
