module MicroTest
  VERSION = '1.0.0'
  module Assertions
    def flunk(msg=nil)
      file, line = caller(2)[0].split(/:/, 2)
      raise AssertionFailed.new(msg || (line + ":" + File.readlines(file)[line.to_i-1]))
    end
    def assert(bool=false)
      Gatherer.instance.add_assertion
      file, line = caller(1)[0].split(/:/, 2)
      raise AssertionFailed.new(line + ":" + File.readlines(file)[line.to_i-1]) unless !!bool
      true
    end
  end
  class TestingContext < Object;end
  class AssertionFailed < StandardError;end
  class Gatherer
    require 'singleton'
    include Singleton
    props = %w(failure error test assertion)
    attr_accessor(*props.map {|prop| (prop + ("s")).to_sym})
    props.each do |prop|
      define_method("add_" + prop) {eval ("@#{prop}s += 1")}
    end
    def initialize
      @failures = @errors = @assertions = @tests = 0
      @time_before = Time.now
      at_exit do 
        $stderr.puts """
        Finished in #{Time.now - @time_before} seconds
        #{@tests} tests, #{@assertions} assertions, #{@failures} failures, #{@errors} errors
        """
      end
    end
  end

  def self.test(context, name, options={}, &block)
    Gatherer.instance.add_test
    failure = false
    orig_block = block

    ivs = context.instance_variables.inject({}) do |ivs, iv|
      val = context.instance_variable_get(iv)
      begin
        ivs[iv] = val.dup
      rescue TypeError
        ivs[iv] = val
        $stderr.puts "Warning: Stored reference! #{iv} : #{val.class} doesn't like #dup" unless (val.class == NilClass) || (val.class == Fixnum)
      end
      ivs
    end
    
    block = lambda do
      extend Assertions

      ivs.each do |iv, value|
        instance_variable_set(iv, value)
      end
      $current_test_case = self

      instance_eval(&orig_block)
    end
    
    ccts = context.class.constants
    cccts = context.class.class.constants
    scts = (class<<context;self;end).constants

    begin
      if s = options[:self]
        s.instance_eval(&block)
      else
        TestingContext.new.instance_eval(&block)
      end
    rescue Exception => e
      failure = true
      e.class == AssertionFailed ? Gatherer.instance.add_failure : Gatherer.instance.add_error
      $stderr << """
      ----------------------
        Test: #{name} FAILED:
        >>  #{e.message}
      ----------------------
      """
    end
    
    (context.class.constants - ccts).each do |c|
      context.class.const_defined?(c) && context.class.send(:remove_const, c)
      Class.const_defined?(c) && Class.send(:remove_const, c)
      Object.const_defined?(c) && Object.send(:remove_const, c)
    end
    (context.class.class.constants - cccts).each do |c|
      context.class.class.const_defined?(c) && context.class.class.send(:remove_const, c)
      Class.const_defined?(c) && Class.send(:remove_const, c)
      Object.const_defined?(c) && Object.send(:remove_const, c)
    end
    ((class<<context;self;end).constants - scts).each do |c|
      (class<<context;self;end).send(:remove_const, c) 
    end
    
    $stderr << "." unless failure
  end
  
  def self.config(&block)
    config = Config.new
  end
end

module Kernel
  def testing(name, options={},  &block)
    MicroTest.test(self, name,options, &block)
  end
  alias context testing
end