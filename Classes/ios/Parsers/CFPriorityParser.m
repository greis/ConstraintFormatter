#import "CFPriorityParser.h"
#import "RegexKitLite.h"

@implementation CFPriorityParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^@(<metric>)$"]];
  return self;
}

-(BOOL)parse:(NSString *)term1 context:(CFConstraintContext *)context {
  NSDictionary *match = [term1 dictionaryByMatchingRegex:self.regex withKeysAndCaptures:@"metric", 1, nil];
  if (match.count > 0) {
    [context setPriority:[self parseMetric:match[@"metric"] withContext:context]];
    return YES;
  } else {
    return NO;
  }
}

@end
