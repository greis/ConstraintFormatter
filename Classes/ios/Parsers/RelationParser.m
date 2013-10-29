#import "RelationParser.h"
#import "RegexKitLite.h"

@implementation RelationParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^<relation>$"]];
  return self;
}

-(BOOL)parse:(NSString *)relation context:(ConstraintContext *)context {
  if ([relation isMatchedByRegex:self.regex]) {
    [context setRelation:[self layoutRelationByString:relation]];
    return YES;
  } else {
    return NO;
  }
}


@end
