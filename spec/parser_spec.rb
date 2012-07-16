require "spec_helper"

require "ib/parser"

describe IB::Parser do
  it "finds outlets and actions" do
    info = IB::Parser.new.find("spec/fixtures/custom_view.rb")
    info[:class].should == [["CustomView", "UIView"]]
    info[:outlets].should == [["greenLabel"], ["redLabel"]]
    info[:actions].should == [["someAction"]]
  end

  it "detects simple classes" do
    IB::Parser.new.find("spec/fixtures/simple_class.rb").should == false
  end

  it "finds all infos" do
    IB::Parser.new.find_all("spec/fixtures").should == {"spec/fixtures/custom_view.rb"=>{:class=>[["CustomView", "UIView"]], :outlets=>[["greenLabel"], ["redLabel"]], :actions=>[["someAction"]], :path=>"spec/fixtures/custom_view.rb"}, "spec/fixtures/empty_view.rb"=>{:class=>[["EmptyView", "UIView"]], :outlets=>[], :actions=>[], :path=>"spec/fixtures/empty_view.rb"}}
  end
end