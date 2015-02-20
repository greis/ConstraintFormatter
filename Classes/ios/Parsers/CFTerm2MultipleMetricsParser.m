#import "CFTerm2MultipleMetricsParser.h"
#import "RegexKitLite.h"

@implementation CFTerm2MultipleMetricsParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^\\((<metric>,?\\s*)+\\)$"]];
  return self;
}

-(BOOL)parse:(NSString *)term2 context:(CFConstraintContext *)context {
  if ([term2 isMatchedByRegex:self.regex]) {
    NSArray *matches = [term2 arrayOfDictionariesByMatchingRegex:[self regexFor:@"(<metric>)"] withKeysAndCaptures:@"metric", 1, nil];
    for (NSDictionary *match in matches) {
      [context addConstant:[self parseMetric:match[@"metric"] withContext:context]];
      [context addView2Attribute:NSLayoutAttributeNotAnAttribute];
    }
    return YES;
  } else {
    return NO;
  }
}

@end
