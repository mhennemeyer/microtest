require File.dirname(__FILE__) + "/../lib/microtest.rb"
require "/Users/macbook/Projekte/matchy/lib/matchy.rb"

require File.dirname(__FILE__) + "/../lib/microtest.rb"

testing "Some bogus expectations" do
  nil.should be_nil
  1.should be(1)
  1.should_not <= 0
  var = 5
  lambda {var += 1}.should change {var}.from(5).to(6)
end


# Transactional behavior: Methods
def m
  "m"
end

testing "sees method" do
  m.should == "m"
end

testing "introduce method" do
  def m2
    "m2"
  end
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

# Nesting: Just all the tests from above in the context of a 
# testing block
testing "with nesting" do
  testing "Some bogus expectations" do
    nil.should be_nil
    1.should be(1)
    1.should_not <= 0
    var = 5
    lambda {var += 1}.should change {var}.from(5).to(6)
  end


  # Transactional behavior: Methods
  def m
    "m"
  end

  testing "sees method" do
    m.should == "m"
  end

  testing "introduce method" do
    def m2
      "m2"
    end
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




