= microtest

* http://github.com/mhennemeyer/microtest/

== DESCRIPTION:

MicroTest is a minimal testing framework.
It works transactional without setup and teardown.
It goes great together with matchy.
It lets you explicitly set the current self object 
for a testing block.

MicroTest is partially inspired by this Blog Post:
http://pragdave.blogs.pragprog.com/pragdave/2008/03/playing-with-a.html

== FEATURES:

MicroTest works with testing blocks. 

Each testing block sets up a context in which assertions 
can be made. The context will be cleaned up after the testing block ends.
And the context will be passed into nested testing blocks.


You can explicitly set the current self object for a testing block.


=== Transactional:  
Methods, instancevariables and constants are all taken from outer to inner blocks -
but all that is done to them in the inner block will not persist after the inner block ends.

It works with matchy, so you can use familiar obj.should matcher syntax.


== SYNOPSIS:

	1. plain microtest without matchy
	
	require "rubygems"
	require "microtest"
	
  testing "a variable with a value of 1" do
    @var = 1
    testing "is 1" do
      assert @var == 1
    end
    testing "one added and it is 2" do
      @var += 1
      assert @var == 2
    end
    # @var has not been changed!
    assert @var == 1
  end


  2. with matchy

  
  require "rubygems"
	require "microtest"
	require "matchy"

  testing "with nesting" do
	  testing "Some bogus expectations" do
	    nil.should be_nil
	    1.should be(1)
	    1.should_not <= 0
	    var = 5
	    lambda {var += 1}.should change {var}.from(5).to(6)
	  end


	  # Transactional behavior: Methods
	  def m;"m";end

	  testing "sees method" do
	    m.should == "m"
	  end

	  testing "introduce method in testing block" do
	    def m2;"m2";end
	  end

	  # method defined in test block is not present in context:
	  raise if defined?(m2)

	  testing "methods introduced in other test block are not present" do
	    defined?(m2).should be_nil
	  end

	  # Transactional behavior: Instance Variables
	  @var1 = 1
	  testing "sees instance variables" do
	    @var1.should eql(1)
	  end

	  testing "introduce instance variable" do
	    @var2 = 2
	  end

	  # instance variable defined in test block is not present in context:
	  raise if defined?(@var2)

	  testing "instance variables introduced in other test block are not present" do
	    defined?(@var2).should be_nil
	  end
	
		testing "change instance variable" do
		  @var1 += 1
		end
		# value of nstance variable remains the same in context
		raise if @var1 != 1

		testing "value of nstance variable remains the same in other testing block" do
		  @var1.should eql(1)
		end

	  # Transactional behavior: Constants
	  M = 1
	  testing "sees constants" do
	    M.should == 1
	  end

	  testing "introduce constants" do
	    M2 = 2
	  end

	  # constant defined in test block is not present in context:
	  raise if defined?(M2)

	  testing "constants introduced in other test block are not present" do
	    defined?(M2).should be_nil
	  end

	  # Transactional behavior: Locals

	  testing "Introduce local" do
	    local = 1
	  end
	  # local defined in test block should not be accessible in context
	  raise if defined?(local)


	  # Transactional behavior: Object attributes
	  @obj = Class.new do |klass|
	    attr_accessor :var
	    def initialize
	      @var = 1
	    end
	  end.new

	  testing "Changing objects attribute" do
	    @obj.var.should == 1
	    @obj.var = 2
	  end

	  # Objects attribute should not be changed in context
	  raise if @obj.var != 1

	  testing "Objects attribute should not be changed subsequent test block" do
	    @obj.var.should == 1
	  end

	end

== REQUIREMENTS:

Has no requirements, but you should use it with matchy:
sudo gem install matchy

== INSTALL:

sudo gem install microtest

== LICENSE:

(The MIT License)

Copyright (c) 2009 Matthias Hennemeyer

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
