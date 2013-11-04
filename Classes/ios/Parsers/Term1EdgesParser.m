#import "Term1EdgesParser.h"
#import "RegexKitLite.h"

@implementation Term1EdgesParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^(<view>)\\.edges$"]];
  return self;
}

-(BOOL)parse:(NSString *)term1 context:(ConstraintContext *)context {
  NSDictionary *match = [term1 dictionaryByMatchingRegex:self.regex withKeysAndCaptures:@"viewName", 1, nil];
  if (match.count > 0) {
    [context setView1Name:match[@"viewName"]];
    [context addView1Attribute:NSLayoutAttributeTop];
    [context addView1Attribute:NSLayoutAttributeLeft];
    [context addView1Attribute:NSLayoutAttributeBottom];
    [context addView1Attribute:NSLayoutAttributeRight];
    return YES;
  } else {
    return NO;
  }
}

@end
