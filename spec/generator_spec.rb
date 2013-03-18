require "spec_helper"

require "ib/generator"

describe IB::Generator do
  it "generates stubs" do
    files = IB::Parser.new.find_all("spec/fixtures")
    stubs = IB::Generator.new.generate_objc(files)
    stubs.should == <<-OBJC
@interface AppDelegate

@property IBOutlet UIWindow * window;
@property IBOutlet UINavigationController * navigationController;





@end


@interface CustomView: UIView

@property IBOutlet UIGreenLabel * greenLabel;
@property IBOutlet UILabel * redLabel;
@property IBOutlet id untyped_label;
@property IBOutlet id yellowLabel;

@property IBOutletCollection(UIGreenLabel) NSArray * greenLabelCollection;
@property IBOutletCollection(UILabel) NSArray * redLabelCollection;
@property IBOutletCollection(id) NSArray * untyped_label_collection;
@property IBOutletCollection(id) NSArray * yellowLabelCollection;

-(IBAction) someAction:(id) sender;
-(IBAction) segueAction:(UIStoryboardSegue*) sender;
-(IBAction) anotherAction:(id) button;
-(IBAction) actionWithComment:(id) sender;
-(IBAction) actionWithBrackets:(id) sender;
-(IBAction) actionWithoutArgs;
-(IBAction) actionWithDefaultedArgs:(id) sender;

@end


@interface EmptyView: UIView







@end


@interface AnotherView: EmptyView







@end


OBJC
  end
end
