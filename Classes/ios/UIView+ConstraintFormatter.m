#import "UIView+VisualConstraints.h"
#import "RegexKitLite.h"

@implementation UIView (VisualConstraints)

-(NSArray *)addVisualConstraints:(NSArray *)visualFormats views:(NSDictionary *)views metrics:(NSDictionary *)metrics {
  
  for (UIView* view in views.allValues) {
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
  }
  
  NSMutableArray *finalConstraints = [NSMutableArray array];
  
  
  NSString *relation = [self.layoutRelations.allKeys componentsJoinedByString:@"|"];
  NSString *attribute1 = @"(\\w+\\.\\w+)";
  NSString *attribute2 = @"(\\w+\\.\\w+)";
  
  NSString *regex = [NSString stringWithFormat:@"%@ (%@) %@", attribute1, relation, attribute2];
  
  for (NSString *visualFormat in visualFormats) {
    
    NSRange r = [visualFormat rangeOfString:regex options:NSRegularExpressionSearch];
    if (r.location != NSNotFound) {
      NSString *a1 = [visualFormat stringByMatching:regex capture:1];
      NSString *o = [visualFormat stringByMatching:regex capture:2];
      NSString *a2 = [visualFormat stringByMatching:regex capture:3];
      NSLog(@"Found a1:%@ o:%@ a2:%@", a1, o, a2);
      
      NSString *attribute1Regex = @"(\\w+)\\.(\\w+)";
      NSString *view1Name = [a1 stringByMatching:attribute1Regex capture:1];
      NSString *view1Attrbute = [a1 stringByMatching:attribute1Regex capture:2];
      UIView *view1 = views[view1Name];
      NSLayoutAttribute layoutAttribute1 = [self layoutAttributeByString:view1Attrbute];
      
      NSString *attribute2Regex = @"(\\w+)\\.(\\w+)";
      NSString *view2Name = [a2 stringByMatching:attribute2Regex capture:1];
      NSString *view2Attrbute = [a2 stringByMatching:attribute2Regex capture:2];
      UIView *view2 = views[view2Name];
      NSLayoutAttribute layoutAttribute2 = [self layoutAttributeByString:view2Attrbute];
      
      NSLayoutRelation relation = [self layoutRelationByString:o];
      CGFloat multiplier = 1;
      CGFloat constant = 0;
      
      [finalConstraints addObject:[NSLayoutConstraint constraintWithItem:view1 attribute:layoutAttribute1 relatedBy:relation toItem:view2 attribute:layoutAttribute2 multiplier:multiplier constant:constant]];
    } else {
      NSLog(@"Not found: %@", visualFormat);
      [finalConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:nil views:views]];
    }
  }
  
  for (NSLayoutConstraint *constraint in finalConstraints) {
    [self addConstraint:constraint];
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
