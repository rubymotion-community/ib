require "spec_helper"

require "ib/parser"

describe IB::Parser do
  it "finds outlets and actions" do
    info = IB::Parser.new(:ios).find("spec/fixtures/common/custom_view.rb").first
    info[:class].should == [["CustomView", "UIView"]]
    info[:outlets].should == [
      ["greenLabel",    "UIGreenLabel"],
      ["redLabel",      "UILabel"],
      ["untyped_label", "id"],
      ["yellowLabel",   "id"]
    ]
    info[:outlet_collections].should == [
      ["greenLabelCollection",     "UIGreenLabel"],
      ["redLabelCollection",       "UILabel"],
      ["untyped_label_collection", "id"],
      ["yellowLabelCollection",    "id"]
    ]
    info[:actions].should == [
      ["someAction",              "sender", nil],
      ["segueAction",             "sender", "UIStoryboardSegue"],
      ["anotherAction",           "button", nil],
      ["actionWithComment",       "sender", nil],
      ["actionWithBrackets",      "sender", nil],
      ["actionWithoutArgs",       nil,      nil],
      ["actionWithDefaultedArgs", "sender", nil]
    ]
  end

  it "can parse complex superclasses" do
    info = IB::Parser.new(:ios).find("spec/fixtures/common/complex_superclass.rb")
    info.first[:class].should == [["HasComplexSuperClass", "Complex::SuperClass"]]
    info.last[:class].should == [["HasLessComplexSuperClass", "PM::Screen"]]
  end

  it "can output simple classes" do
    IB::Parser.new(:ios).find("spec/fixtures/common/simple_class.rb").length.should == 1
  end

  it "finds all infos" do
    infos = IB::Parser.new(:ios).find_all("spec/fixtures/dependency_test")
    infos.values.each do |vals|
      vals.each do |v|
        expect(v).to be_kind_of(IB::OCInterface)
      end
    end
  end

end
