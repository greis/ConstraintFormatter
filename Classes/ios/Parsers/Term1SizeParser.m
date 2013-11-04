#import "Term1SizeParser.h"
#import "RegexKitLite.h"

@implementation Term1SizeParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^(<view>)\\.size$"]];
  return self;
}

-(BOOL)parse:(NSString *)term1 context:(ConstraintContext *)context {
  NSDictionary *match = [term1 dictionaryByMatchingRegex:self.regex withKeysAndCaptures:@"viewName", 1, nil];
  if (match.count > 0) {
    [context setView1Name:match[@"viewName"]];
    [context addView1Attribute:NSLayoutAttributeWidth];
    [context addView1Attribute:NSLayoutAttributeHeight];
    return YES;
  } else {
    return NO;
  }
}

@end
