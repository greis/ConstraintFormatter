#import "ConstraintContext.h"

@implementation ConstraintContext

-(NSArray *)constraints {
  return @[[NSLayoutConstraint constraintWithItem:self.views[self.view1Name]
                               attribute:self.view1Attribute
                               relatedBy:self.relation
                                  toItem:self.views[self.view2Name]
                               attribute:self.view2Attribute
                              multiplier:self.multiplier
                                constant:self.constant]];
}

@end
