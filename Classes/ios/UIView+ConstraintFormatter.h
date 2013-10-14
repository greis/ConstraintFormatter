#import <UIKit/UIKit.h>

@interface UIView (VisualConstraints)

-(NSArray *)addVisualConstraints:(NSArray *)constraints views:(NSDictionary *)views metrics:(NSDictionary *)metrics;

@end
