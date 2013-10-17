#import "ConstraintFormatter.h"
#import "RegexKitLite.h"
#import <UIKit/UIKit.h>

@interface ConstraintContext : NSObject

@property(nonatomic) NSString *view1Name;
@property(nonatomic) NSLayoutAttribute *view1Attribute;
@property(nonatomic) NSLayoutRelation *relation;
@property(nonatomic) NSString *view2Name;
@property(nonatomic) NSLayoutAttribute *view2Attribute;
@property(nonatomic) CGFloat multiplier;
@property(nonatomic) CGFloat constant;

@end

@implementation ConstraintContext

@end

@implementation ConstraintFormatter

-(NSArray *)buildConstraintsWithFormats:(NSArray *)formats forView:(NSDictionary *)views {
  
  NSMutableArray *finalConstraints = [NSMutableArray array];
  
  NSString *regex = [self regexFor:@"^(<view1>\\.<attr1>) (<relation>) (<view2>\\.<attr2>( <operator> <number>)*|<number>)$"];
  
  for (NSString *visualFormat in formats) {
    
    NSDictionary *match = [visualFormat dictionaryByMatchingRegex:regex withKeysAndCaptures:@"term1", 1, @"relation", 2, @"term2", 3, nil];
    if (match != nil) {
      
      ConstraintContext *context = [ConstraintContext new];
      
      [self parseTerm1:match[@"term1"] context:context];
      [self parseRelation:match[@"relation"] context:context];
      [self parseTerm2:match[@"term2"] context:context];
      
      
      [finalConstraints addObject:
       [NSLayoutConstraint constraintWithItem:views[context.view1Name]
                                    attribute:context.view1Attribute
                                    relatedBy:context.relation
                                       toItem:views[context.view2Name]
                                    attribute:context.view2Attribute
                                   multiplier:context.multiplier
                                     constant:context.constant]];
    } else {
      [finalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:views]];
    }
  }
  
  return finalConstraints;
}

-(void)parseTerm1:(NSString *)term1 context:(ConstraintContext *)context {
  NSDictionary *match = [term1 dictionaryByMatchingRegex:[self regexFor:@"^(<view1>)\\.(<attr1>)$"] withKeysAndCaptures:@"viewName", 1, @"attribute", 2, nil];
  NSLayoutAttribute layoutAttribute = [self layoutAttributeByString:match[@"attribute"]];
  [context setView1Name:match[@"viewName"]];
  [context setView1Attribute:layoutAttribute];
}

-(void)parseRelation:(NSString *)relation context:(ConstraintContext *)context {
  [context setRelation:[self layoutRelationByString:relation]];
}

-(void)parseTerm2:(NSString *)term2 context:(ConstraintContext *)context {
  CGFloat multiplier = 1;
  CGFloat constant = 0;
  if ([term2 isMatchedByRegex:[self regexFor:@"^<number>$"]]) {
    constant = [term2 floatValue];
    [context setView2Attribute:NSLayoutAttributeNotAnAttribute];
  } else {
    NSDictionary *match = [term2 dictionaryByMatchingRegex:[self regexFor:@"^(<view2>)\\.(<attr2>)(( <operator> <number>)*)$"] withKeysAndCaptures:@"viewName", 1, @"attribute", 2, @"operators", 3, nil];
    
    NSLayoutAttribute layoutAttribute2 = [self layoutAttributeByString:match[@"attribute"]];
    [context setView2Name:match[@"viewName"]];
    [context setView2Attribute:layoutAttribute2];
    
    NSArray *operators = [match[@"operators"] arrayOfDictionariesByMatchingRegex:[self regexFor:@" (<operator>) (<number>)"] withKeysAndCaptures:@"operator", 1, @"number", 2, nil];
    
    for (NSDictionary *operator in operators) {
      if ([operator[@"operator"] isEqualToString:@"*"]) {
        multiplier = [operator[@"number"] floatValue];
      } else {
        constant = [[operator[@"operator"] stringByAppendingString:operator[@"number"]] floatValue];
      }
    }
  }
  
  [context setMultiplier:multiplier];
  [context setConstant:constant];
}

-(NSString *)regexFor:(NSString *)string {
  NSDictionary *replacements = @{
                      @"<view1>": @"\\w+",
                      @"<attr1>": @"\\w+",
                      @"<view2>": @"\\w+",
                      @"<attr2>": @"\\w+",
                      @"<relation>": [self.layoutRelations.allKeys componentsJoinedByString:@"|"],
                      @"<operator>": @"[*+-]",
                      @"<number>": @"\\d+(?:\\.\\d+)?"
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

@end
