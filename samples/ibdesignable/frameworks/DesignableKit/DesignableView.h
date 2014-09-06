#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface DesignableView : UIView

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, retain) IBInspectable UIColor *borderColor;

@end
