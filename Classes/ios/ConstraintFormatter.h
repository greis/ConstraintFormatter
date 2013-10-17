#import <Foundation/Foundation.h>

@interface ConstraintFormatter : NSObject

-(NSArray *)buildConstraintsWithFormats:(NSArray *)formats forViews:(NSDictionary *)views withMetrics:(NSDictionary *)metrics;

@end