#import "UIView+ConstraintFormatter.h"
#import "ConstraintFormatter.h"

@implementation UIView (ConstraintFormatter)

-(NSArray *)addVisualConstraints:(NSArray *)formats views:(NSDictionary *)views metrics:(NSDictionary *)metrics {
  
  for (UIView* view in views.allValues) {
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  
  ConstraintFormatter *formatter = [[ConstraintFormatter alloc] init];
  
  NSArray *finalConstraints = [formatter buildConstraintsWithFormats:formats forViews:views withMetrics:metrics];
  
  for (NSLayoutConstraint *constraint in finalConstraints) {
    [self addConstraint:constraint];
  }
  
  return finalConstraints;
}

@end
