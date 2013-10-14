#import <UIKit/UIKit.h>

@interface UIView (ConstraintFormatter)

-(NSArray *)addVisualConstraints:(NSArray *)constraints views:(NSDictionary *)views metrics:(NSDictionary *)metrics;

@end
