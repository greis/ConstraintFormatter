#import "Term1Parser.h"
#import "RegexKitLite.h"

@implementation Term1Parser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^(<view1>)\\.(<attr1>)$"]];
  return self;
}

-(BOOL)parse:(NSString *)term1 context:(ConstraintContext *)context {
  NSDictionary *match = [term1 dictionaryByMatchingRegex:self.regex withKeysAndCaptures:@"viewName", 1, @"attribute", 2, nil];
  if (match.count > 0) {
    NSLayoutAttribute layoutAttribute = [self layoutAttributeByString:match[@"attribute"]];
    [context setView1Name:match[@"viewName"]];
    [context setView1Attribute:layoutAttribute];
    return YES;
  } else {
    return NO;
  }
}



@end
