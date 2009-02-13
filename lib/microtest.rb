module MicroTest
  VERSION = '1.0.0'
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

  def self.test(context, name, &block)
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

      ivs.each do |iv, value|
        instance_variable_set(iv, value)
      end
      $current_test_case = self

      instance_eval(&orig_block)
    end
    
    ccts = context.class.constants
    scts = (class<<context;self;end).constants

    begin
      TestingContext.new.instance_eval(&block)
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
    $stderr << "." unless failure
  end
end

module Kernel
  def testing(name, &block)
    MicroTest.test(self, name, &block)
  end
end