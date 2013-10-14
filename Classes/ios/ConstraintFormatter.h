#import <Foundation/Foundation.h>

@interface ConstraintFormatter : NSObject

-(NSArray *)buildConstraintsWithFormats:(NSArray *)formats forView:(NSDictionary *)views;

@end