require "spec_helper"

require "ib/generator"

describe IB::Generator do
  it "generates stubs" do
    files = IB::Parser.new.find_all("spec/fixtures")
    stubs = IB::Generator.new.generate_objc(files)
    stubs.should == <<-OBJC
@interface CustomView : UIView

@property (weak) IBOutlet id greenLabel;
@property (weak) IBOutlet id redLabel;

-(IBAction) someAction:(id) sender;

@end


@interface EmptyView : UIView





@end
OBJC
  end
end