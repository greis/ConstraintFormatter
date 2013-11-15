#import "GenericParser.h"
#import "RegexKitLite.h"

@implementation GenericParser

-(BOOL)parse:(NSString *)text context:(ConstraintContext *)context {
  return NO;
}

-(NSString *)regexFor:(NSString *)string {
  NSString *number = @"-?\\d+(?:\\.\\d+)?";
  NSDictionary *replacements = @{
                                 @"<view>": @"\\w+",
                                 @"<attr>": @"\\w+",
                                 @"<relation>": [self.layoutRelations.allKeys componentsJoinedByString:@"|"],
                                 @"<operator>": @"[*+-/]",
                                 @"<number>": number,
                                 @"<metric>": [NSString stringWithFormat:@"(?:%@|-?\\w+)", number]
                                 };
  
  for (NSString *key in replacements.allKeys) {
    string = [string stringByReplacingOccurrencesOfString:key withString:replacements[key]];
  }
  return string;
}

-(NSDictionary *)layoutRelations {
  return @{
           @"<=": @(NSLayoutRelationLessThanOrEqual),
           @"==": @(NSLayoutRelationEqual),
           @">=": @(NSLayoutRelationGreaterThanOrEqual)
           };
}

-(NSLayoutRelation)layoutRelationByString:(NSString *)string {
  return [self.layoutRelations[string] integerValue];
}

-(float)parseMetric:(NSString *)string withContext:(ConstraintContext *)context {
  if ([string isMatchedByRegex:[self regexFor:@"^<number>$"]]) {
    return [string floatValue];
  } else {
    int sign = 1;
    if ([string characterAtIndex:0] == '-') {
      sign = -1;
      string = [string substringFromIndex:1];
    }
    return [context.metrics[string] floatValue] * sign;
  }
}

@end
