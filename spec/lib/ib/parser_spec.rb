require "spec_helper"

require "ib/parser"

describe IB::Parser do
  it "finds outlets and actions" do
    info = IB::Parser.new.find("spec/fixtures/custom_view.rb").first
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

  it "detects simple classes" do
    IB::Parser.new.find("spec/fixtures/simple_class.rb").length.should == 0
  end

  it "finds all infos" do
    puts IB::Parser.new.find_all("spec/fixtures").inspect
  end
end
