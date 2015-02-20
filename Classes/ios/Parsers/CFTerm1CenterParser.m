#import "CFTerm1CenterParser.h"
#import "RegexKitLite.h"

@implementation CFTerm1CenterParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^(<view>)\\.center$"]];
  return self;
}

-(BOOL)parse:(NSString *)term1 context:(CFConstraintContext *)context {
  NSDictionary *match = [term1 dictionaryByMatchingRegex:self.regex withKeysAndCaptures:@"viewName", 1, nil];
  if (match.count > 0) {
    [context setView1Name:match[@"viewName"]];
    [context addView1Attribute:NSLayoutAttributeCenterX];
    [context addView1Attribute:NSLayoutAttributeCenterY];
    return YES;
  } else {
    return NO;
  }
}

@end
