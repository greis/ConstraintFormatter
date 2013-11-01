#import "MetricParser.h"
#import "RegexKitLite.h"

@implementation MetricParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^<metric>$"]];
  return self;
}

-(BOOL)parse:(NSString *)term2 context:(ConstraintContext *)context {
  if ([term2 isMatchedByRegex:self.regex]) {
    [context setConstant:[self parseMetric:term2 withContext:context]];
    [context addView2Attribute:NSLayoutAttributeNotAnAttribute];
    return YES;
  } else {
    return NO;
  }
}


@end
