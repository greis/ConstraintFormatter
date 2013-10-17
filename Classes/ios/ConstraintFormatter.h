#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ConstraintFormatter : NSObject

-(NSArray *)buildConstraintsWithFormats:(NSArray *)formats views:(NSDictionary *)views metrics:(NSDictionary *)metrics;

@end

@interface UIView (ConstraintFormatterExtension)

-(NSArray *)addConstraintsWithFormats:(NSArray *)constraints views:(NSDictionary *)views metrics:(NSDictionary *)metrics;

@end