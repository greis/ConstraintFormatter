#import "ConstraintFormatter.h"
#import <UIKit/UIKit.h>
#import "ConstraintParser.h"

@implementation ConstraintFormatter

-(NSArray *)buildConstraintsWithFormats:(NSArray *)formats views:(NSDictionary *)views metrics:(NSDictionary *)metrics {
  NSMutableArray *finalConstraints = [NSMutableArray array];
  
  for (NSString *visualFormat in formats) {
    ConstraintParser *parser = [[ConstraintParser alloc] initWithViews:views metrics:metrics];
    [finalConstraints addObjectsFromArray:[parser parse:visualFormat]];
  }
  
  return finalConstraints;
}

@end

@implementation UIView (ConstraintFormatterExtension)

-(NSArray *)addConstraintsWithFormats:(NSArray *)formats views:(NSDictionary *)views metrics:(NSDictionary *)metrics {
  
  for (UIView* view in views.allValues) {
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  
  NSMutableDictionary *allViews = [NSMutableDictionary dictionaryWithDictionary:views];
  allViews[@"superview"] = self;
  
  ConstraintFormatter *formatter = [[ConstraintFormatter alloc] init];
  
  NSArray *finalConstraints = [formatter buildConstraintsWithFormats:formats views:allViews metrics:metrics];
  
  for (NSLayoutConstraint *constraint in finalConstraints) {
    [self addConstraint:constraint];
  }
  
  return finalConstraints;
}

@end
