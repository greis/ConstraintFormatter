#import "ConstraintFormatter.h"
#import "RegexKitLite.h"
#import <UIKit/UIKit.h>

@implementation ConstraintFormatter

-(NSArray *)buildConstraintsWithFormats:(NSArray *)formats forView:(NSDictionary *)views {
  
  NSMutableArray *finalConstraints = [NSMutableArray array];
  
  NSString *numberRegex = @"\\d+(?:\\.\\d+)?";
  
  NSString *relation = [self.layoutRelations.allKeys componentsJoinedByString:@"|"];
  NSString *attribute1 = @"(\\w+\\.\\w+)";
  NSString *attribute2 = [NSString stringWithFormat:@"(\\w+\\.\\w+(?: \\* %@)?(?: [+-] %@)?)", numberRegex, numberRegex];
  
  NSString *regex = [NSString stringWithFormat:@"%@ (%@) %@", attribute1, relation, attribute2];
  
  for (NSString *visualFormat in formats) {
    
    NSRange range = [visualFormat rangeOfString:regex options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
      NSString *view1String = [visualFormat stringByMatching:regex capture:1];
      NSString *relationString = [visualFormat stringByMatching:regex capture:2];
      NSString *view2String = [visualFormat stringByMatching:regex capture:3];
      
      NSString *attribute1Regex = @"(\\w+)\\.(\\w+)";
      NSString *view1Name = [view1String stringByMatching:attribute1Regex capture:1];
      NSString *view1Attrbute = [view1String stringByMatching:attribute1Regex capture:2];
      UIView *view1 = views[view1Name];
      NSLayoutAttribute layoutAttribute1 = [self layoutAttributeByString:view1Attrbute];
      
      NSString *attribute2Regex = [NSString stringWithFormat:@"(\\w+)\\.(\\w+)(?: \\* (%@))?(?: ([+-]) (%@))?", numberRegex, numberRegex];
      NSString *view2Name = [view2String stringByMatching:attribute2Regex capture:1];
      NSString *view2Attrbute = [view2String stringByMatching:attribute2Regex capture:2];
      NSString *multiplierString = [view2String stringByMatching:attribute2Regex capture:3];
      NSString *constantOperator = [view2String stringByMatching:attribute2Regex capture:4];
      NSString *constantString = [view2String stringByMatching:attribute2Regex capture:5];
      UIView *view2 = views[view2Name];
      NSLayoutAttribute layoutAttribute2 = [self layoutAttributeByString:view2Attrbute];
      
      NSLayoutRelation relation = [self layoutRelationByString:relationString];
      CGFloat multiplier = multiplierString ? [multiplierString floatValue] : 1;
      CGFloat constant = constantString ? [[constantOperator stringByAppendingString:constantString] floatValue]: 0;
      
      [finalConstraints addObject:[NSLayoutConstraint constraintWithItem:view1 attribute:layoutAttribute1 relatedBy:relation toItem:view2 attribute:layoutAttribute2 multiplier:multiplier constant:constant]];
    } else {
      [finalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:views]];
    }
  }
  
  return finalConstraints;
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
