#import "CFRelationParser.h"
#import "RegexKitLite.h"

@implementation CFRelationParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^<relation>$"]];
  return self;
}

-(BOOL)parse:(NSString *)relation context:(CFConstraintContext *)context {
  if ([relation isMatchedByRegex:self.regex]) {
    [context setRelation:[self layoutRelationByString:relation]];
    return YES;
  } else {
    return NO;
  }
}


@end
