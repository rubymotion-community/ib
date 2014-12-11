# IB

RubyMotion Interface Builder support (yes, with outlets)

[![Build Status](https://travis-ci.org/rubymotion/ib.png?branch=master)](https://travis-ci.org/rubymotion/ib)

[**Change Log**](https://github.com/rubymotion/ib/wiki/Change-Log)

## Installation

Add this line to your application's Gemfile:

    gem 'ib'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ib

In your Rake file:

```ruby

$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

# if you use bundler
require 'bundler'
Bundler.require

# if you are not using bundler
require 'rubygems'
require 'ib'

IB::RakeTask.new do |project|
  # ...
end

Motion::Project::App.setup do |app|
  # ...
end

```

## Upgrading to 0.7.0

Previous versons of `ib` automatically registered the `rake ib:open` command,
but offered no way to customize the `IB::Project` that was created.  As of
0.7.0, you will need to create a `IB::RakeTask` instance in your Rakefile, then
you can use `rake ib` as before.

## Usage

### Manual Way

extend your class with IB module

```ruby
class HelloController < UIViewController
  extend IB

  # define ib outlet
  outlet :title, UILabel # @property IBOutlet UILabel * title;
  outlet :untyped_label  # @property IBOutlet id untyped_label;

  # define ib outlet collection
  outlet_collection :labels, UILabel # @property IBOutletCollection(UILabel) NSArray * labels;

  # define ib action
  def someAction sender
  end
end
```

**NOTE:** If you include methods and attributes from module, you can use `ib_outlet` and `ib_action` to make them visible in Interface Builder

```ruby
module TouchLogger
  outlet :my_button, UIButton

  def controlTouched sender
    puts "touched"
  end
end

class LogController < UIViewController
  extend IB

  include TouchLogger

  ib_outlet :my_button
  ib_action :controlTouched

end
```

### Generators Way
Generate controller with folllowing command:

```
ib c Hello UIViewController \
  --outlets scroller:UIScrollView btn_hello: \
  --actions say_hello \
  --accessors data_source
```

The generated file:

#### /app/controllers/hello_controller.rb
```ruby
class HelloController < UIViewController
  extend IB

  attr_accessor :data_source

  ## ib outlets
  outlet :scroller, UIScrollView
  outlet :btn_hello

  def say_hello(sender)
    # TODO Implement action here
  end

end
```

### Support for IBDesignable classes, and IBInspectable properties
###### Thanks to Robert Malko (aka malkomalko) for adding this feature!

To use this feature, you will need to create a simple framework using
Objective-C.  Let's call our framework "DesignableKit".  We'll define just one
public class, `DesignableView`, which will expose a `cornerRadius` property that
we want to be able to edit in Xcode, and have the results shown at design-time.

At a minimum, we need three files:

- Framework header, which defines version constants and includes the public headers.  We'll call this `DesignableKit.h`
- At least one public header, e.g. `DesignableView.h`
- At least one implementation, e.g. `DesignableView.m`

    mkdir -p frameworks/DesignableKit
    touch frameworks/DesignableKit/DesignableKit.h
    touch frameworks/DesignableKit/DesignableView.h
    touch frameworks/DesignableKit/DesignableView.m

Add this framework to your project from the Rakefile, and add a new custom
option, introduced by **ib**:

    app.vendor_project('frameworks/DesignableKit', :static, ib: true)

That `ib: true` option will be detected by **ib**, and that framework will be
included in the .xcodeproj that is created.  So now let's write our custom view
code.

Unfortunately, we'll have to rely on objective-c for now.  RubyMotion cannot yet
compile Swift files (RM 2.32 at the time of this writing), and we have not yet
added the ability to use a RubyMotion framework, *but this should be possible*!

###### DesignableKit.h
```objc
#import <UIKit/UIKit.h>

FOUNDATION_EXPORT double DesignableKitVersionNumber;
FOUNDATION_EXPORT const unsigned char DesignableKitVersionString[];

// import all the public headers of your framework
#import <DesignableKit/DesignableView.h>
```
###### DesignableView.h
```objc
#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface DesignableView : UIView

@property (nonatomic) IBInspectable CGFloat cornerRadius;

@end
```

###### DesignableView.m
```objc
// we make sure to call [self setup] from all the designated initializers (UIViews have *two*!)
#import "DesignableView.h"

@implementation DesignableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self setup];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
  if (self = [super initWithFrame:frame]) {
    [self setup];
  }
  return self;
}

- (void)prepareForInterfaceBuilder {
  self.backgroundColor = [UIColor whiteColor];
}

- (void)setup {
  self.cornerRadius = 0;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  _cornerRadius = cornerRadius;
  self.layer.cornerRadius = cornerRadius;
}

@end
```

Now open interface builder, and make your change!

    rake ib



### Using Interface Builder

Running `rake ib` will create a ib.xcodeproj in the root of your app and open XCode. You can create Storyboards or nibs, and save them in your `resources` directory in order to be picked up by RubyMotion.

Everytime you make a change in your ruby files (like adding a new outlet or action method) you have to run `rake ib` in order to let Interface Builder see the changes.

**Tip** : add ib.xcodeproj to your .gitignore

### How it works

This gem parses your Ruby code and generates two Objective-c files (Stub.m and Stub.h) which are populated with the classes, methods and outlets you have defined. This is necessary for Interface Builder to bind outlets and actions to your code.

### Warning

Various versions of the `ib` gem are incompatible with advancing versions of Xcode. If you are not seeing your outlets and actions in Interface Builder, it's possible you have such a mismatch. Here's a way to find out if this might be true:

* Check the version of the gem by doing `gem list|grep ib` from the command line.
* Compare the version listed with that in the most current gem (assuming you are using a current version of Xcode). You can find this in `lib/ib/version.ib`

If you find your version of the `ib` gem is not current, try `bundle update ib`. If this does not resolve the problem, the conflict can be in required versions of Thor. For example, Guard requires a particular version of Thor and `ib` does not specify. You may find removing Guard will allow your bundle update to bring `ib` up to the current version.

> Further note: If you are working on a current app and are used to creating your views programmatically, read on. If you're an Interface Builder ninja, nevermind(tm). It is important that you set your File's Owner in Interface Builder *to the controller you are using*. Remember, *File's Owner*, not View. Next, drag the `View` outlet in File's owner to the view you should have by now created. This will reduce the traffic on Google looking up "how come I can't get my nib hooked up right?" And remember, because File's Owner is the controller, you will bind all outlets and actions to File's Owner, so look there for these magic thingies.

# Sample app

Here is a [sample app](https://github.com/rubymotion/ib/tree/master/samples/ibsample) using a storyboard, by **yury**.

1. clone it
2. run `bundle`
3. run `rake ib` to change story board
4. run `rake` to run app in simulator

**Note** : this app was built for iOS 6.0

# IBDesignable Sample app

A [sample app](https://github.com/rubymotion/ib/tree/master/samples/ibdesignable) based on the code above.  Written by **malkomalko**.

# Another Sample app

Here is [another sample app](https://github.com/hqmq/whereami), by **hqmq**.

# OS X Sample app

Here is an [OS X sample app](https://github.com/MarkVillacampa/motion-osx-ib) by **MarkVillacampa**

You can play around with it in the same way as the Sample app above. This sample
uses a single xib file rather than a storyboard.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
