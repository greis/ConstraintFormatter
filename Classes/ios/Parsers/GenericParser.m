#import "GenericParser.h"
#import "RegexKitLite.h"

@implementation GenericParser

-(BOOL)parse:(NSString *)text context:(ConstraintContext *)context {
  return NO;
}

-(NSString *)regexFor:(NSString *)string {
  NSString *number = @"\\d+(?:\\.\\d+)?";
  NSDictionary *replacements = @{
                                 @"<view1>": @"\\w+",
                                 @"<attr1>": @"\\w+",
                                 @"<view2>": @"\\w+",
                                 @"<attr2>": @"\\w+",
                                 @"<relation>": [self.layoutRelations.allKeys componentsJoinedByString:@"|"],
                                 @"<operator>": @"[*+-]",
                                 @"<number>": number,
                                 @"<metric>": [NSString stringWithFormat:@"(?:%@|\\w+)", number]
                                 };
  
  for (NSString *key in replacements.allKeys) {
    string = [string stringByReplacingOccurrencesOfString:key withString:replacements[key]];
  }
  return string;
}

-(NSDictionary *)layoutAttributes {
  return  @{
            @"left": @(NSLayoutAttributeLeft),
            @"right": @(NSLayoutAttributeRight),
            @"top": @(NSLayoutAttributeTop),
            @"bottom": @(NSLayoutAttributeBottom),
            @"leading": @(NSLayoutAttributeLeading),
            @"trailing": @(NSLayoutAttributeTrailing),
            @"width": @(NSLayoutAttributeWidth),
            @"height": @(NSLayoutAttributeHeight),
            @"centerX": @(NSLayoutAttributeCenterX),
            @"centerY": @(NSLayoutAttributeCenterY),
            @"baseline": @(NSLayoutAttributeBaseline)
            };
}

-(NSDictionary *)layoutRelations {
  return @{
           @"<=": @(NSLayoutRelationLessThanOrEqual),
           @"==": @(NSLayoutRelationEqual),
           @">=": @(NSLayoutRelationGreaterThanOrEqual)
           };
}

-(NSLayoutAttribute)layoutAttributeByString:(NSString *)string {
  return [self.layoutAttributes[string] integerValue];
}

-(NSLayoutRelation)layoutRelationByString:(NSString *)string {
  return [self.layoutRelations[string] integerValue];
}

-(float)parseMetric:(NSString *)string withContext:(ConstraintContext *)context {
  if ([string isMatchedByRegex:[self regexFor:@"^<number>$"]]) {
    return [string floatValue];
  } else {
    return [context.metrics[string] floatValue];
  }
}

@end