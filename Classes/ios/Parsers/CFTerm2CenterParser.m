#import "CFTerm2CenterParser.h"
#import "RegexKitLite.h"

@implementation CFTerm2CenterParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^(<view>)\\.center(?:\\((<metric>), (<metric>)\\))?$"]];
  return self;
}

-(BOOL)parse:(NSString *)term1 context:(CFConstraintContext *)context {
  NSDictionary *match = [term1 dictionaryByMatchingRegex:self.regex withKeysAndCaptures:@"viewName", 1, @"xOffset", 2, @"yOffset", 3, nil];
  if (match.count > 0) {
    [context setView2Name:match[@"viewName"]];
    [context addView2Attribute:NSLayoutAttributeCenterX];
    [context addView2Attribute:NSLayoutAttributeCenterY];
    
    if (match[@"xOffset"]) {
      CGFloat xOffset = [self parseMetric:match[@"xOffset"] withContext:context];
      CGFloat yOffset = [self parseMetric:match[@"yOffset"] withContext:context];
      [context addConstant:xOffset];
      [context addConstant:yOffset];
    }
    
    return YES;
  } else {
    return NO;
  }
}

@end
