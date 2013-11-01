#import "Term2CenterParser.h"
#import "RegexKitLite.h"

@implementation Term2CenterParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^(<view>)\\.center$"]];
  return self;
}

-(BOOL)parse:(NSString *)term1 context:(ConstraintContext *)context {
  NSDictionary *match = [term1 dictionaryByMatchingRegex:self.regex withKeysAndCaptures:@"viewName", 1, nil];
  if (match.count > 0) {
    [context setView2Name:match[@"viewName"]];
    [context addView2Attribute:NSLayoutAttributeCenterX];
    [context addView2Attribute:NSLayoutAttributeCenterY];
    return YES;
  } else {
    return NO;
  }
}

@end
