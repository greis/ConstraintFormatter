#import "CFTerm2ViewNameParser.h"
#import "RegexKitLite.h"

@implementation CFTerm2ViewNameParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^<view>$"]];
  return self;
}

-(BOOL)parse:(NSString *)term2 context:(CFConstraintContext *)context {
  if ([term2 isMatchedByRegex:self.regex] && context.views[term2]) {
    [context setView2Name:term2];
    [context copyView1AttributesToView2];
    return YES;
  } else {
    return NO;
  }
}

@end
