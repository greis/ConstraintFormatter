#import "ConstraintContext.h"

@interface ConstraintContext ()
@property(nonatomic) NSMutableArray *view1Attributes;
@property(nonatomic) NSMutableArray *view2Attributes;
@end

@implementation ConstraintContext

- (id)init
{
  self = [super init];
  if (self) {
    [self setView1Attributes:[NSMutableArray array]];
    [self setView2Attributes:[NSMutableArray array]];
    [self setMultiplier:1];
    [self setConstant:0];
  }
  return self;
}

-(NSArray *)constraints {
  NSMutableArray *constraints = [NSMutableArray array];
  for (int i = 0; i < self.view1Attributes.count; i++) {
    
    UIView *view1 = self.views[self.view1Name];
    NSLayoutAttribute attribute1 = [self.view1Attributes[i] integerValue];
    UIView *view2 = self.views[self.view2Name];
    NSLayoutAttribute attribute2 = [self.view2Attributes[i] integerValue];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view1 attribute:attribute1 relatedBy:self.relation toItem:view2 attribute:attribute2 multiplier:self.multiplier constant:self.constant];
    [constraints addObject:constraint];
  }
  return constraints;
}

-(void)addView1Attribute:(NSLayoutAttribute)attribute {
  [self.view1Attributes addObject:@(attribute)];
}

-(void)addView2Attribute:(NSLayoutAttribute)attribute {
  [self.view2Attributes addObject:@(attribute)];
}

@end
