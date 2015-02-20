#import "CFTerm1Parser.h"
#import "RegexKitLite.h"

@implementation CFTerm1Parser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^(<view>)\\.(<attr>)$"]];
  return self;
}

-(BOOL)parse:(NSString *)term1 context:(CFConstraintContext *)context {
  NSDictionary *match = [term1 dictionaryByMatchingRegex:self.regex withKeysAndCaptures:@"viewName", 1, @"attribute", 2, nil];
  if (match.count > 0) {
    [context setView1Name:match[@"viewName"]];
    [context addView1AttributeByName:match[@"attribute"]];
    return YES;
  } else {
    return NO;
  }
}



@end
