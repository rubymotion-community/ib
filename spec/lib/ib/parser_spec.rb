require "spec_helper"

require "ib/parser"

describe IB::Parser do
  it "finds outlets and actions" do
    info = IB::Parser.new.find("spec/fixtures/common/custom_view.rb").first
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

  it "can output simple classes" do
    IB::Parser.new.find("spec/fixtures/common/simple_class.rb").length.should == 1
  end

  it "finds all infos" do
    infos = IB::Parser.new.find_all("spec/fixtures/dependency_test")
    expect(infos.size).to eq 3
  end

  it "finds all sorted infos" do
    infos = IB::Parser.new.find_all("spec/fixtures/dependency_test")
    expect(infos.size).to eq 3
  end
end
