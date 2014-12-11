class AppDelegate
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindowController = MainWindowController.alloc.initWithWindowNibName('MainWindowController')
    @mainWindowController.window.makeKeyAndOrderFront(self)
  end
end


class MainWindowController < NSWindowController
  extend IB

  outlet :label, NSTextField
  outlet :button, NSButton

  def windowDidLoad
    @label.stringValue = 'oh hello there!'
    @button.bordered = false
    @button.cell.backgroundColor = NSColor.redColor
  end

  def button_pressed(sender)
    @label.stringValue = 'don’t touch that!'
  end

end
