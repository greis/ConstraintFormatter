#import "CFTerm2SizeParser.h"
#import "RegexKitLite.h"

@implementation CFTerm2SizeParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^(<view>)\\.size(?:\\((<metric>), (<metric>)\\))?$"]];
  return self;
}

-(BOOL)parse:(NSString *)term1 context:(CFConstraintContext *)context {
  NSDictionary *match = [term1 dictionaryByMatchingRegex:self.regex withKeysAndCaptures:@"viewName", 1, @"widthOffset", 2, @"heightOffset", 3, nil];
  if (match.count > 0) {
    [context setView2Name:match[@"viewName"]];
    [context addView2Attribute:NSLayoutAttributeWidth];
    [context addView2Attribute:NSLayoutAttributeHeight];
    
    if (match[@"widthOffset"]) {
      CGFloat widthOffset = [self parseMetric:match[@"widthOffset"] withContext:context];
      CGFloat heightOffset = [self parseMetric:match[@"heightOffset"] withContext:context];
      [context addConstant:widthOffset];
      [context addConstant:heightOffset];
    }
    
    return YES;
  } else {
    return NO;
  }
}

@end
