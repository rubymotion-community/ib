require "spec_helper"

require "ib/project"

describe IB::Project do
  it "generates xcode project" do   
    IB::Project.new.write("spec/fixtures") 
  end
end