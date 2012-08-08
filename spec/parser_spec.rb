require "spec_helper"

require "ib/parser"

describe IB::Parser do
  it "finds outlets and actions" do
    info = IB::Parser.new.find("spec/fixtures/custom_view.rb")
    info[:class].should == [["CustomView", "UIView"]]
    info[:outlets].should == [["greenLabel", "UIGreenLabel"], ["redLabel", "UILabel"], ["untyped_label", "id"], ["yellowLabel", "id"]]
    info[:actions].should == [["someAction"], ["anotherAction"], ["actionWithComment"], ["actionWithBrackets"]]
  end

  it "detects simple classes" do
    IB::Parser.new.find("spec/fixtures/simple_class.rb").should == false
  end

  it "finds all infos" do
    puts IB::Parser.new.find_all("spec/fixtures").inspect
  end
end