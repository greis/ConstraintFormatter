#import "UIView+ConstraintFormatter.h"
#import "ConstraintFormatter.h"

@implementation UIView (ConstraintFormatter)

-(NSArray *)addVisualConstraints:(NSArray *)formats views:(NSDictionary *)views metrics:(NSDictionary *)metrics {
  
  ConstraintFormatter *formatter = [[ConstraintFormatter alloc] init];
  
  NSArray *finalConstraints = [formatter buildConstraintsWithFormats:formats forView:views];
  
  for (NSLayoutConstraint *constraint in finalConstraints) {
    [self addConstraint:constraint];
  }
  
  return finalConstraints;
}

@end
