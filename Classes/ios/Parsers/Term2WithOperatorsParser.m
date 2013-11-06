#import "Term2WithOperatorsParser.h"
#import "RegexKitLite.h"

@implementation Term2WithOperatorsParser

-(id)init {
  self = [super init];
  [self setRegex:[self regexFor:@"^(<view>)\\.(<attr>)(( <operator> <metric>)*)$"]];
  return self;
}

-(BOOL)parse:(NSString *)term2 context:(ConstraintContext *)context {
  NSDictionary *match = [term2 dictionaryByMatchingRegex:self.regex withKeysAndCaptures:@"viewName", 1, @"attribute", 2, @"operators", 3, nil];
  
  if (match.count > 0) {
    NSLayoutAttribute layoutAttribute2 = [self layoutAttributeByString:match[@"attribute"]];
    [context setView2Name:match[@"viewName"]];
    [context addView2Attribute:layoutAttribute2];
    
    NSArray *operators = [match[@"operators"] arrayOfDictionariesByMatchingRegex:[self regexFor:@" (<operator>) (<metric>)"] withKeysAndCaptures:@"operator", 1, @"metric", 2, nil];
    
    CGFloat multiplier = 1;
    CGFloat constant = 0;
    for (NSDictionary *operator in operators) {
      float value = [self parseMetric:operator[@"metric"] withContext:context];
      switch ([operator[@"operator"] characterAtIndex:0]) {
        case '*':
          multiplier = value;
          break;
        case '/':
          multiplier = 1 / value;
          break;
        case '+':
          constant = value;
          break;
        case '-':
          constant = -value;
          break;
      }
    }
    
    [context setMultiplier:multiplier];
    [context addConstant:constant];
    return YES;
  } else {
    return NO;
  }
}


@end
