#import "Term2MetricParser.h"
#import "RegexKitLite.h"

@implementation Term2MetricParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^<metric>$"]];
  return self;
}

-(BOOL)parse:(NSString *)term2 context:(ConstraintContext *)context {
  if ([term2 isMatchedByRegex:self.regex]) {
    [context addConstant:[self parseMetric:term2 withContext:context]];
    [context addView2Attribute:NSLayoutAttributeNotAnAttribute];
    return YES;
  } else {
    return NO;
  }
}


@end
