class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    ctlr = DesignableController.new
    @window.rootViewController = ctlr
    @window.makeKeyAndVisible
    true
  end
end


class DesignableController < UIViewController
  extend IB

  outlet :designable_view, 'DesignableView'

  def awakeFromNib
    NSLog("designable_view: %@", @designable_view)
  end

end
