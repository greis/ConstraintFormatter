#import "Kiwi.h"
#import <ConstraintFormatter/ConstraintFormatter.h>

SPEC_BEGIN(ConstraintFormatterSpec)

describe(@"#buildConstraintsWithFormats:forView:", ^{
  
  describe(@"view1.attrA relation view2.attrB", ^{
    it(@"builds 1 constraint", ^{
      ConstraintFormatter *formatter = [[ConstraintFormatter alloc] init];
      UIView *view1 = UIView.new;
      UIView *view2 = UIView.new;
      id views = @{@"view1": view1, @"view2": view2};
      NSArray *formats = @[@"view1.bottom == view2.top"];
      NSArray *constraints = [formatter buildConstraintsWithFormats:formats forView:views];
      [[constraints should] haveCountOf:1];
      
      NSLayoutConstraint *constraint = constraints[0];
      [[constraint.firstItem should] equal:view1];
      [[@(constraint.firstAttribute) should] equal:@(NSLayoutAttributeBottom)];
      [[@(constraint.relation) should] equal:@(NSLayoutRelationEqual)];
      [[constraint.secondItem should] equal:view2];
      [[@(constraint.secondAttribute) should] equal:@(NSLayoutAttributeTop)];
    });
    
  });
  
});

SPEC_END