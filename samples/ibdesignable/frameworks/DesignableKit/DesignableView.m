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
  self.cornerRadius = 5;
  self.borderWidth = 2;
  self.borderColor = [UIColor lightGrayColor];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
  _cornerRadius = cornerRadius;
  self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
  _borderWidth = borderWidth;
  self.layer.borderWidth = borderWidth;
}

- (void)setBorderColor:(UIColor*)borderColor {
  _borderColor = borderColor;
  self.layer.borderColor = borderColor.CGColor;
}

@end
