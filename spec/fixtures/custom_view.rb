class CustomView < UIView
  extend IB

  ib_outlet :greenLabel,  UIGreenLabel
  ib_outlet :redLabel, "UILabel"

  ib_outlet :untyped_label

  outlet :yellowLabel

  ib_outlet_collection :greenLabelCollection,  UIGreenLabel
  ib_outlet_collection :redLabelCollection, "UILabel"

  ib_outlet_collection :untyped_label_collection

  outlet_collection :yellowLabelCollection

  ib_action :someAction
  ib_action :segueAction, UIStoryboardSegue

  def anotherAction button
  end

  def actionWithComment sender # test
  end

  def actionWithBrackets(sender)
  end

  def notAction with, toArgs
  end

  def actionWithoutArgs
  end

  def actionWithDefaultedArgs(sender = nil) #comment
  end

end
