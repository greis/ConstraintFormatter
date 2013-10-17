#import "Kiwi.h"
#import <ConstraintFormatter/ConstraintFormatter.h>

SPEC_BEGIN(ConstraintFormatterSpec)

describe(@"#buildConstraintsWithFormats:forView:", ^{
  ConstraintFormatter *formatter = [[ConstraintFormatter alloc] init];
  
  describe(@"constrain 1 view", ^{
    UIView *view1 = UIView.new;
    id views = @{@"view1": view1};
    
    it(@"builds 1 constraint", ^{
      NSArray *formats = @[@"view1.width == 30"];
      NSArray *constraints = [formatter buildConstraintsWithFormats:formats forView:views];
      [[constraints should] haveCountOf:1];

      NSLayoutConstraint *constraint = constraints[0];
      [[constraint.firstItem should] equal:view1];
      [[@(constraint.firstAttribute) should] equal:@(NSLayoutAttributeWidth)];
      [[@(constraint.relation) should] equal:@(NSLayoutRelationEqual)];
      [[constraint.secondItem should] beNil];
      [[@(constraint.secondAttribute) should] equal:@(NSLayoutAttributeNotAnAttribute)];
      [[@(constraint.multiplier) should] equal:@(1)];
      [[@(constraint.constant) should] equal:@(30)];
    });
    
  });
  
  describe(@"constrain 2 views", ^{
    UIView *view1 = UIView.new;
    UIView *view2 = UIView.new;
    id views = @{@"view1": view1, @"view2": view2};
    
    context(@"without multiplier and constant", ^{
      it(@"builds 1 constraint", ^{
        NSArray *formats = @[@"view1.bottom == view2.top"];
        NSArray *constraints = [formatter buildConstraintsWithFormats:formats forView:views];
        [[constraints should] haveCountOf:1];
        
        NSLayoutConstraint *constraint = constraints[0];
        [[constraint.firstItem should] equal:view1];
        [[@(constraint.firstAttribute) should] equal:@(NSLayoutAttributeBottom)];
        [[@(constraint.relation) should] equal:@(NSLayoutRelationEqual)];
        [[constraint.secondItem should] equal:view2];
        [[@(constraint.secondAttribute) should] equal:@(NSLayoutAttributeTop)];
        [[@(constraint.multiplier) should] equal:@(1)];
        [[@(constraint.constant) should] equal:@(0)];
      });
    });
    
    context(@"with multiplier", ^{
      context(@"integer number", ^{
        it(@"builds 1 constraint", ^{
          NSArray *formats = @[@"view1.bottom == view2.top * 2"];
          NSArray *constraints = [formatter buildConstraintsWithFormats:formats forView:views];
          [[constraints should] haveCountOf:1];
          
          NSLayoutConstraint *constraint = constraints[0];
          [[constraint.firstItem should] equal:view1];
          [[@(constraint.firstAttribute) should] equal:@(NSLayoutAttributeBottom)];
          [[@(constraint.relation) should] equal:@(NSLayoutRelationEqual)];
          [[constraint.secondItem should] equal:view2];
          [[@(constraint.secondAttribute) should] equal:@(NSLayoutAttributeTop)];
          [[@(constraint.multiplier) should] equal:@(2)];
          [[@(constraint.constant) should] equal:@(0)];
        });
      });
      context(@"float number", ^{
        it(@"builds 1 constraint", ^{
          NSArray *formats = @[@"view1.bottom == view2.top * 0.5"];
          NSArray *constraints = [formatter buildConstraintsWithFormats:formats forView:views];
          [[constraints should] haveCountOf:1];
          
          NSLayoutConstraint *constraint = constraints[0];
          [[constraint.firstItem should] equal:view1];
          [[@(constraint.firstAttribute) should] equal:@(NSLayoutAttributeBottom)];
          [[@(constraint.relation) should] equal:@(NSLayoutRelationEqual)];
          [[constraint.secondItem should] equal:view2];
          [[@(constraint.secondAttribute) should] equal:@(NSLayoutAttributeTop)];
          [[@(constraint.multiplier) should] equal:@(0.5)];
          [[@(constraint.constant) should] equal:@(0)];
        });
      });
    });
    
    context(@"with constant", ^{
      context(@"positive constant", ^{
        context(@"integer value", ^{
          it(@"builds 1 constraint", ^{
            NSArray *formats = @[@"view1.bottom == view2.top + 2"];
            NSArray *constraints = [formatter buildConstraintsWithFormats:formats forView:views];
            [[constraints should] haveCountOf:1];
            
            NSLayoutConstraint *constraint = constraints[0];
            [[constraint.firstItem should] equal:view1];
            [[@(constraint.firstAttribute) should] equal:@(NSLayoutAttributeBottom)];
            [[@(constraint.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint.secondItem should] equal:view2];
            [[@(constraint.secondAttribute) should] equal:@(NSLayoutAttributeTop)];
            [[@(constraint.multiplier) should] equal:@(1)];
            [[@(constraint.constant) should] equal:@(2)];
          });
        });
        context(@"float value", ^{
          it(@"builds 1 constraint", ^{
            NSArray *formats = @[@"view1.bottom == view2.top + 2.5"];
            NSArray *constraints = [formatter buildConstraintsWithFormats:formats forView:views];
            [[constraints should] haveCountOf:1];
            
            NSLayoutConstraint *constraint = constraints[0];
            [[constraint.firstItem should] equal:view1];
            [[@(constraint.firstAttribute) should] equal:@(NSLayoutAttributeBottom)];
            [[@(constraint.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint.secondItem should] equal:view2];
            [[@(constraint.secondAttribute) should] equal:@(NSLayoutAttributeTop)];
            [[@(constraint.multiplier) should] equal:@(1)];
            [[@(constraint.constant) should] equal:@(2.5)];
          });
        });
      });
      context(@"negative constant", ^{
        it(@"builds 1 constraint", ^{
          NSArray *formats = @[@"view1.bottom == view2.top - 2"];
          NSArray *constraints = [formatter buildConstraintsWithFormats:formats forView:views];
          [[constraints should] haveCountOf:1];
          
          NSLayoutConstraint *constraint = constraints[0];
          [[constraint.firstItem should] equal:view1];
          [[@(constraint.firstAttribute) should] equal:@(NSLayoutAttributeBottom)];
          [[@(constraint.relation) should] equal:@(NSLayoutRelationEqual)];
          [[constraint.secondItem should] equal:view2];
          [[@(constraint.secondAttribute) should] equal:@(NSLayoutAttributeTop)];
          [[@(constraint.multiplier) should] equal:@(1)];
          [[@(constraint.constant) should] equal:@(-2)];
        });
      });
    });
    
    context(@"with multiplier and constant", ^{
      it(@"builds 1 constraint", ^{
        NSArray *formats = @[@"view1.bottom == view2.top * 2 + 3"];
        NSArray *constraints = [formatter buildConstraintsWithFormats:formats forView:views];
        [[constraints should] haveCountOf:1];
        
        NSLayoutConstraint *constraint = constraints[0];
        [[constraint.firstItem should] equal:view1];
        [[@(constraint.firstAttribute) should] equal:@(NSLayoutAttributeBottom)];
        [[@(constraint.relation) should] equal:@(NSLayoutRelationEqual)];
        [[constraint.secondItem should] equal:view2];
        [[@(constraint.secondAttribute) should] equal:@(NSLayoutAttributeTop)];
        [[@(constraint.multiplier) should] equal:@(2)];
        [[@(constraint.constant) should] equal:@(3)];
      });
    });
    
  });
  
});

SPEC_END