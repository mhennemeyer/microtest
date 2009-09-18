require File.dirname(__FILE__) + "/../lib/microtest.rb"
require "~/Projekte/matchy/lib/matchy.rb"



context "An Object obj with obj#greeting #=> 'Hello' "  do
  
  class Obj
    def greeting
      "Hello"
    end
    
    def set_instance_variable
      @var = 1
    end
  end

  obj = Obj.new
  
  testing "as the current self object", :self => obj do
    greeting.should == "Hello"
    set_instance_variable
    @var.should == 1
    self.should == obj
  end
end
