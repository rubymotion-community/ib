require "spec_helper"

require "ib/generator"

describe IB::Generator do
  it "generates stubs" do
    files = IB::Parser.new.find_all("spec/fixtures")
    stubs = IB::Generator.new.generate_objc(files)
    stubs.should == <<-OBJC
@interface CustomView : UIView

@property IBOutlet UIGreenLabel * greenLabel;
@property IBOutlet UILabel * redLabel;
@property IBOutlet id untyped_label;
@property IBOutlet id yellowLabel;

-(IBAction) someAction:(id) sender;
-(IBAction) anotherAction:(id) sender;
-(IBAction) actionWithComment:(id) sender;
-(IBAction) actionWithBrackets:(id) sender;

@end


@interface EmptyView : UIView





@end
OBJC
  end
end