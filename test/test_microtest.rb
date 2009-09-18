require File.dirname(__FILE__) + "/../lib/microtest.rb"

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


# Transactional behavior: Methods
def m
  "m"
end

testing "sees method" do
  assert m == "m"
end

testing "introduce method" do
  def m2
    "m2"
  end
end

# method defined in test block is not present in context:
raise if defined?(m2)

testing "methods introduced in other test block are not present" do
  assert !defined?(m2)
end

# Transactional behavior: Instance Variables
@var1 = 1
testing "sees instance variables" do
  assert @var1 == 1
end

testing "introduce instance variable" do
  @var2 = 2
end

# instance variable defined in test block is not present in context:
raise if defined?(@var2)

testing "instance variables introduced in other test block are not present" do
  assert !defined?(@var2)
end

testing "change instance variable" do
  @var1 += 1
end
# value of nstance variable remains the same in context
raise if @var1 != 1

testing "value of nstance variable remains the same in other testing block" do
  assert @var1 == 1
end

# Transactional behavior: Constants
M = 1
testing "sees constants" do
  assert M == 1
end

testing "introduce constants" do
  M2 = 2
end

# constant defined in test block is not present in context:
raise "M2 should not be present here!" if defined?(M2)

testing "constants introduced in other test block are not present" do
  assert !defined?(M2)
end

# Transactional behavior: Locals

testing "Introduce local" do
  local = 1
end
# local defined in test block should not be accessible in context
raise if defined?(local)

# locals should not persist between testblocks
testing "Introduce local" do
  assert !defined?(local)
end

# Transactional behavior: Object attributes
@obj = Class.new do |klass|
  attr_accessor :var
  def initialize
    @var = 1
  end
end.new

testing "Changing objects attribute" do
  assert @obj.var == 1
  @obj.var = 2
end

# Objects attribute should not be changed in context
raise if @obj.var != 1

testing "Objects attribute should not be changed subsequent test block" do
  assert @obj.var == 1
end

# Nesting: Just all the tests from above in the context of a 
# testing block
testing "with nesting" do
  
  testing "Assert True" do
    assert true
  end
  
  
  # Transactional behavior: Methods
  def m
    "m"
  end
  
  testing "sees method" do
    assert m == "m"
  end
  
  testing "introduce method" do
    def m2
      "m2"
    end
  end
  
  # method defined in test block is not present in context:
  raise if defined?(m2)
  
  testing "methods introduced in other test block are not present" do
    assert !defined?(m2)
  end
  
  # Transactional behavior: Instance Variables
  @var1 = 1
  testing "sees instance variables" do
    assert @var1 == 1
  end
  
  testing "introduce instance variable" do
    @var2 = 2
  end
  
  # instance variable defined in test block is not present in context:
  raise if defined?(@var2)
  
  testing "instance variables introduced in other test block are not present" do
    assert !defined?(@var2)
  end
  
  testing "change instance variable" do
    @var1 += 1
  end
  # value of nstance variable remains the same in context
  raise if @var1 != 1
  
  testing "value of nstance variable remains the same in other testing block" do
    assert @var1 == 1
  end
  
  # Transactional behavior: Constants
  # this constant may not be the same as in the
  # outermost level. If we would remove the constants
  # that are coming from the outermost level, we
  # would remove all constants.
  MN = 1
  testing "sees constants" do
    assert MN == 1
  end
  
  testing "introduce constants" do
    M2 = 2
  end
  
  assert !defined?(M2)

  # constant defined in test block is not present in context:
  #assert !defined?(M2)
  
  testing "constants introduced in other test block are not present" do
    #assert !defined?(M2)
  end

  # Transactional behavior: Locals
  
  testing "Introduce local" do
    local = 1
  end
  # local defined in test block should not be accessible in context
  raise if defined?(local)
  
  # locals should not persist between testblocks
  testing "Introduce local" do
    assert !defined?(local)
  end
  
  # Transactional behavior: Object attributes
  @obj = Class.new do |klass|
    attr_accessor :var
    def initialize
      @var = 1
    end
  end.new
  
  testing "Changing objects attribute" do
    assert @obj.var == 1
    @obj.var = 2
  end
  
  # Objects attribute should not be changed in context
  raise if @obj.var != 1
  
  testing "Objects attribute should not be changed in subsequent test block" do
    assert @obj.var == 1
  end
  
end




