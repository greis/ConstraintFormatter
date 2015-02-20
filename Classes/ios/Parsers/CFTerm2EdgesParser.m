#import "CFTerm2EdgesParser.h"
#import "RegexKitLite.h"

@implementation CFTerm2EdgesParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^(<view>)\\.edges(?:\\((<metric>), (<metric>), (<metric>), (<metric>)\\))?$"]];
  return self;
}

-(BOOL)parse:(NSString *)term1 context:(CFConstraintContext *)context {
  NSDictionary *match = [term1 dictionaryByMatchingRegex:self.regex withKeysAndCaptures:@"viewName", 1, @"topInset", 2, @"leftInset", 3, @"bottomInset", 4, @"rightInset", 5, nil];
  if (match.count > 0) {
    [context setView2Name:match[@"viewName"]];
    [context addView2Attribute:NSLayoutAttributeTop];
    [context addView2Attribute:NSLayoutAttributeLeft];
    [context addView2Attribute:NSLayoutAttributeBottom];
    [context addView2Attribute:NSLayoutAttributeRight];
    
    if (match[@"topInset"]) {
      CGFloat topInset = [self parseMetric:match[@"topInset"] withContext:context];
      CGFloat leftInset = [self parseMetric:match[@"leftInset"] withContext:context];
      CGFloat bottomInset = [self parseMetric:match[@"bottomInset"] withContext:context];
      CGFloat rightInset = [self parseMetric:match[@"rightInset"] withContext:context];
      [context addConstant:topInset];
      [context addConstant:leftInset];
      [context addConstant:-bottomInset];
      [context addConstant:-rightInset];
    }
    
    return YES;
  } else {
    return NO;
  }
}

@end
