class CustomView < UIView
  extend IB

  ib_outlet :greenLabel,  UIGreenLabel
  ib_outlet :redLabel, "UILabel"

  ib_outlet :untyped_label

  outlet_accessor :yellowLabel

  ib_outlet_collection :greenLabel,  UIGreenLabel
  ib_outlet_collection :redLabel, "UILabel"

  ib_outlet_collection :untyped_label

  outlet_collection_accessor :yellowLabel

  ib_action :someAction

  def anotherAction button
  end

  def actionWithComment sender # test
  end

  def actionWithBrackets(sender)
  end

  def notAction with, toArgs
  end
  
end
