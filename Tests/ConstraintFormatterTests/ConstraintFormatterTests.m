#import "Kiwi.h"
#import <ConstraintFormatter/ConstraintFormatter.h>

SPEC_BEGIN(ConstraintFormatterSpec)

describe(@"#buildConstraintsWithFormats:forView:", ^{
  ConstraintFormatter *formatter = [[ConstraintFormatter alloc] init];
  __block id metrics = nil;
  
  describe(@"constrain 1 view", ^{
    UIView *view1 = UIView.new;
    id views = @{@"view1": view1};
    
    context(@"with numeric value", ^{
      it(@"builds 1 constraint", ^{
        NSArray *formats = @[@"view1.width == 30"];
        NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
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
    
    context(@"with metrics", ^{
      it(@"builds 1 constraint", ^{
        NSArray *formats = @[@"view1.width == width"];
        metrics = @{@"width": @(31)};
        NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
        [[constraints should] haveCountOf:1];
        
        NSLayoutConstraint *constraint = constraints[0];
        [[constraint.firstItem should] equal:view1];
        [[@(constraint.firstAttribute) should] equal:@(NSLayoutAttributeWidth)];
        [[@(constraint.relation) should] equal:@(NSLayoutRelationEqual)];
        [[constraint.secondItem should] beNil];
        [[@(constraint.secondAttribute) should] equal:@(NSLayoutAttributeNotAnAttribute)];
        [[@(constraint.multiplier) should] equal:@(1)];
        [[@(constraint.constant) should] equal:@(31)];
      });
    });
    
    context(@"with multiple metrics", ^{
      context(@"size attribute", ^{
        it(@"builds 2 constraints", ^{
          NSArray *formats = @[@"view1.size == (20, 30)"];
          NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
          [[constraints should] haveCountOf:2];
          
          NSLayoutConstraint *constraint1 = constraints[0];
          [[constraint1.firstItem should] equal:view1];
          [[@(constraint1.firstAttribute) should] equal:@(NSLayoutAttributeWidth)];
          [[@(constraint1.relation) should] equal:@(NSLayoutRelationEqual)];
          [[constraint1.secondItem should] beNil];
          [[@(constraint1.secondAttribute) should] equal:@(NSLayoutAttributeNotAnAttribute)];
          [[@(constraint1.multiplier) should] equal:@(1)];
          [[@(constraint1.constant) should] equal:@(20)];
          
          NSLayoutConstraint *constraint2 = constraints[1];
          [[constraint2.firstItem should] equal:view1];
          [[@(constraint2.firstAttribute) should] equal:@(NSLayoutAttributeHeight)];
          [[@(constraint2.relation) should] equal:@(NSLayoutRelationEqual)];
          [[constraint2.secondItem should] beNil];
          [[@(constraint2.secondAttribute) should] equal:@(NSLayoutAttributeNotAnAttribute)];
          [[@(constraint2.multiplier) should] equal:@(1)];
          [[@(constraint2.constant) should] equal:@(30)];
        });
      });
    });
    
    context(@"with invalid attribute", ^{
      it(@"does not build a constraint", ^{
        NSArray *formats = @[@"view1.invalid == 30"];
        NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
        [[constraints should] haveCountOf:0];
      });
    });
    
    context(@"with view not present in dictionary", ^{
      it(@"does not build a constraint", ^{
        NSArray *formats = @[@"viewNotPresent.width == 30"];
        NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
        [[constraints should] haveCountOf:0];
      });
    });
    
    context(@"with metric not present in dictionary", ^{
      it(@"does not build a constraint", ^{
        NSArray *formats = @[@"view1.width == metricNotPresent"];
        NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
        [[constraints should] haveCountOf:0];
      });
    });
    
  });
  
  describe(@"constrain 2 views", ^{
    UIView *view1 = UIView.new;
    UIView *view2 = UIView.new;
    id views = @{@"view1": view1, @"view2": view2};
    
    context(@"without multiplier and constant", ^{
      it(@"builds 1 constraint", ^{
        NSArray *formats = @[@"view1.bottom == view2.top"];
        NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
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
          NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
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
          NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
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
    
    context(@"with divider", ^{
      context(@"integer number", ^{
        it(@"builds 1 constraint", ^{
          NSArray *formats = @[@"view1.bottom == view2.top / 2"];
          NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
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
      context(@"float number", ^{
        it(@"builds 1 constraint", ^{
          NSArray *formats = @[@"view1.bottom == view2.top / 0.5"];
          NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
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
    });
    
    context(@"with constant", ^{
      context(@"positive constant", ^{
        context(@"integer value", ^{
          it(@"builds 1 constraint", ^{
            NSArray *formats = @[@"view1.bottom == view2.top + 2"];
            NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
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
            NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
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
          NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
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
      context(@"metric constant", ^{
        it(@"builds 1 constraint", ^{
          NSArray *formats = @[@"view1.bottom == view2.top + margin"];
          metrics = @{@"margin": @(10)};
          NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
          [[constraints should] haveCountOf:1];
          
          NSLayoutConstraint *constraint = constraints[0];
          [[constraint.firstItem should] equal:view1];
          [[@(constraint.firstAttribute) should] equal:@(NSLayoutAttributeBottom)];
          [[@(constraint.relation) should] equal:@(NSLayoutRelationEqual)];
          [[constraint.secondItem should] equal:view2];
          [[@(constraint.secondAttribute) should] equal:@(NSLayoutAttributeTop)];
          [[@(constraint.multiplier) should] equal:@(1)];
          [[@(constraint.constant) should] equal:@(10)];
        });
      });
    });
    
    context(@"with multiplier and constant", ^{
      it(@"builds 1 constraint", ^{
        NSArray *formats = @[@"view1.bottom == view2.top * 2 + 3"];
        NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
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
    
    context(@"with center attribute", ^{
      context(@"without offset", ^{
        it(@"builds 2 constraints", ^{
          NSArray *formats = @[@"view1.center == view2.center"];
          NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
          [[constraints should] haveCountOf:2];
          
          NSLayoutConstraint *constraint1 = constraints[0];
          [[constraint1.firstItem should] equal:view1];
          [[@(constraint1.firstAttribute) should] equal:@(NSLayoutAttributeCenterX)];
          [[@(constraint1.relation) should] equal:@(NSLayoutRelationEqual)];
          [[constraint1.secondItem should] equal:view2];
          [[@(constraint1.secondAttribute) should] equal:@(NSLayoutAttributeCenterX)];
          [[@(constraint1.multiplier) should] equal:@(1)];
          [[@(constraint1.constant) should] equal:@(0)];
          
          NSLayoutConstraint *constraint2 = constraints[1];
          [[constraint2.firstItem should] equal:view1];
          [[@(constraint2.firstAttribute) should] equal:@(NSLayoutAttributeCenterY)];
          [[@(constraint2.relation) should] equal:@(NSLayoutRelationEqual)];
          [[constraint2.secondItem should] equal:view2];
          [[@(constraint2.secondAttribute) should] equal:@(NSLayoutAttributeCenterY)];
          [[@(constraint2.multiplier) should] equal:@(1)];
          [[@(constraint2.constant) should] equal:@(0)];
        });
      });
      context(@"with offset", ^{
        context(@"and positive and negative numbers", ^{
          it(@"builds 2 constraints", ^{
            NSArray *formats = @[@"view1.center == view2.center(2, -3)"];
            NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
            [[constraints should] haveCountOf:2];
            
            NSLayoutConstraint *constraint1 = constraints[0];
            [[constraint1.firstItem should] equal:view1];
            [[@(constraint1.firstAttribute) should] equal:@(NSLayoutAttributeCenterX)];
            [[@(constraint1.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint1.secondItem should] equal:view2];
            [[@(constraint1.secondAttribute) should] equal:@(NSLayoutAttributeCenterX)];
            [[@(constraint1.multiplier) should] equal:@(1)];
            [[@(constraint1.constant) should] equal:@(2)];
            
            NSLayoutConstraint *constraint2 = constraints[1];
            [[constraint2.firstItem should] equal:view1];
            [[@(constraint2.firstAttribute) should] equal:@(NSLayoutAttributeCenterY)];
            [[@(constraint2.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint2.secondItem should] equal:view2];
            [[@(constraint2.secondAttribute) should] equal:@(NSLayoutAttributeCenterY)];
            [[@(constraint2.multiplier) should] equal:@(1)];
            [[@(constraint2.constant) should] equal:@(-3)];
          });
        });
        context(@"and positive and negative metrics", ^{
          it(@"builds 2 constraints", ^{
            NSArray *formats = @[@"view1.center == view2.center(offset, -offset)"];
            metrics = @{@"offset": @(2)};
            NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
            [[constraints should] haveCountOf:2];
            
            NSLayoutConstraint *constraint1 = constraints[0];
            [[constraint1.firstItem should] equal:view1];
            [[@(constraint1.firstAttribute) should] equal:@(NSLayoutAttributeCenterX)];
            [[@(constraint1.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint1.secondItem should] equal:view2];
            [[@(constraint1.secondAttribute) should] equal:@(NSLayoutAttributeCenterX)];
            [[@(constraint1.multiplier) should] equal:@(1)];
            [[@(constraint1.constant) should] equal:@(2)];
            
            NSLayoutConstraint *constraint2 = constraints[1];
            [[constraint2.firstItem should] equal:view1];
            [[@(constraint2.firstAttribute) should] equal:@(NSLayoutAttributeCenterY)];
            [[@(constraint2.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint2.secondItem should] equal:view2];
            [[@(constraint2.secondAttribute) should] equal:@(NSLayoutAttributeCenterY)];
            [[@(constraint2.multiplier) should] equal:@(1)];
            [[@(constraint2.constant) should] equal:@(-2)];
          });
        });
      });
    });
    
    context(@"with size attribute", ^{
      context(@"without offset", ^{
        it(@"builds 2 constraints", ^{
          NSArray *formats = @[@"view1.size == view2.size"];
          NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
          [[constraints should] haveCountOf:2];
          
          NSLayoutConstraint *constraint1 = constraints[0];
          [[constraint1.firstItem should] equal:view1];
          [[@(constraint1.firstAttribute) should] equal:@(NSLayoutAttributeWidth)];
          [[@(constraint1.relation) should] equal:@(NSLayoutRelationEqual)];
          [[constraint1.secondItem should] equal:view2];
          [[@(constraint1.secondAttribute) should] equal:@(NSLayoutAttributeWidth)];
          [[@(constraint1.multiplier) should] equal:@(1)];
          [[@(constraint1.constant) should] equal:@(0)];
          
          NSLayoutConstraint *constraint2 = constraints[1];
          [[constraint2.firstItem should] equal:view1];
          [[@(constraint2.firstAttribute) should] equal:@(NSLayoutAttributeHeight)];
          [[@(constraint2.relation) should] equal:@(NSLayoutRelationEqual)];
          [[constraint2.secondItem should] equal:view2];
          [[@(constraint2.secondAttribute) should] equal:@(NSLayoutAttributeHeight)];
          [[@(constraint2.multiplier) should] equal:@(1)];
          [[@(constraint2.constant) should] equal:@(0)];
        });
      });
      context(@"with offset", ^{
        context(@"and positive and negative numbers", ^{
          it(@"builds 2 constraints", ^{
            NSArray *formats = @[@"view1.size == view2.size(2, -3)"];
            NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
            [[constraints should] haveCountOf:2];
            
            NSLayoutConstraint *constraint1 = constraints[0];
            [[constraint1.firstItem should] equal:view1];
            [[@(constraint1.firstAttribute) should] equal:@(NSLayoutAttributeWidth)];
            [[@(constraint1.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint1.secondItem should] equal:view2];
            [[@(constraint1.secondAttribute) should] equal:@(NSLayoutAttributeWidth)];
            [[@(constraint1.multiplier) should] equal:@(1)];
            [[@(constraint1.constant) should] equal:@(2)];
            
            NSLayoutConstraint *constraint2 = constraints[1];
            [[constraint2.firstItem should] equal:view1];
            [[@(constraint2.firstAttribute) should] equal:@(NSLayoutAttributeHeight)];
            [[@(constraint2.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint2.secondItem should] equal:view2];
            [[@(constraint2.secondAttribute) should] equal:@(NSLayoutAttributeHeight)];
            [[@(constraint2.multiplier) should] equal:@(1)];
            [[@(constraint2.constant) should] equal:@(-3)];
          });
        });
        context(@"and positive and negative metrics", ^{
          it(@"builds 2 constraints", ^{
            NSArray *formats = @[@"view1.size == view2.size(offset, -offset)"];
            metrics = @{@"offset": @(2)};
            NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
            [[constraints should] haveCountOf:2];
            
            NSLayoutConstraint *constraint1 = constraints[0];
            [[constraint1.firstItem should] equal:view1];
            [[@(constraint1.firstAttribute) should] equal:@(NSLayoutAttributeWidth)];
            [[@(constraint1.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint1.secondItem should] equal:view2];
            [[@(constraint1.secondAttribute) should] equal:@(NSLayoutAttributeWidth)];
            [[@(constraint1.multiplier) should] equal:@(1)];
            [[@(constraint1.constant) should] equal:@(2)];
            
            NSLayoutConstraint *constraint2 = constraints[1];
            [[constraint2.firstItem should] equal:view1];
            [[@(constraint2.firstAttribute) should] equal:@(NSLayoutAttributeHeight)];
            [[@(constraint2.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint2.secondItem should] equal:view2];
            [[@(constraint2.secondAttribute) should] equal:@(NSLayoutAttributeHeight)];
            [[@(constraint2.multiplier) should] equal:@(1)];
            [[@(constraint2.constant) should] equal:@(-2)];
          });
        });
      });
    });
    
    context(@"with edges attribute", ^{
      context(@"without inset", ^{
        it(@"builds 4 constraints", ^{
          NSArray *formats = @[@"view1.edges == view2.edges"];
          NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
          [[constraints should] haveCountOf:4];
          
          NSLayoutConstraint *constraint1 = constraints[0];
          [[constraint1.firstItem should] equal:view1];
          [[@(constraint1.firstAttribute) should] equal:@(NSLayoutAttributeTop)];
          [[@(constraint1.relation) should] equal:@(NSLayoutRelationEqual)];
          [[constraint1.secondItem should] equal:view2];
          [[@(constraint1.secondAttribute) should] equal:@(NSLayoutAttributeTop)];
          [[@(constraint1.multiplier) should] equal:@(1)];
          [[@(constraint1.constant) should] equal:@(0)];
          
          NSLayoutConstraint *constraint2 = constraints[1];
          [[constraint2.firstItem should] equal:view1];
          [[@(constraint2.firstAttribute) should] equal:@(NSLayoutAttributeLeft)];
          [[@(constraint2.relation) should] equal:@(NSLayoutRelationEqual)];
          [[constraint2.secondItem should] equal:view2];
          [[@(constraint2.secondAttribute) should] equal:@(NSLayoutAttributeLeft)];
          [[@(constraint2.multiplier) should] equal:@(1)];
          [[@(constraint2.constant) should] equal:@(0)];
          
          NSLayoutConstraint *constraint3 = constraints[2];
          [[constraint3.firstItem should] equal:view1];
          [[@(constraint3.firstAttribute) should] equal:@(NSLayoutAttributeBottom)];
          [[@(constraint3.relation) should] equal:@(NSLayoutRelationEqual)];
          [[constraint3.secondItem should] equal:view2];
          [[@(constraint3.secondAttribute) should] equal:@(NSLayoutAttributeBottom)];
          [[@(constraint3.multiplier) should] equal:@(1)];
          [[@(constraint3.constant) should] equal:@(0)];
          
          NSLayoutConstraint *constraint4 = constraints[3];
          [[constraint4.firstItem should] equal:view1];
          [[@(constraint4.firstAttribute) should] equal:@(NSLayoutAttributeRight)];
          [[@(constraint4.relation) should] equal:@(NSLayoutRelationEqual)];
          [[constraint4.secondItem should] equal:view2];
          [[@(constraint4.secondAttribute) should] equal:@(NSLayoutAttributeRight)];
          [[@(constraint4.multiplier) should] equal:@(1)];
          [[@(constraint4.constant) should] equal:@(0)];
        });
      });
      context(@"with inset", ^{
        context(@"and positive and negative numbers", ^{
          it(@"builds 4 constraints", ^{
            NSArray *formats = @[@"view1.edges == view2.edges(2, 3, 4, 5)"];
            NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
            [[constraints should] haveCountOf:4];
            
            NSLayoutConstraint *constraint1 = constraints[0];
            [[constraint1.firstItem should] equal:view1];
            [[@(constraint1.firstAttribute) should] equal:@(NSLayoutAttributeTop)];
            [[@(constraint1.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint1.secondItem should] equal:view2];
            [[@(constraint1.secondAttribute) should] equal:@(NSLayoutAttributeTop)];
            [[@(constraint1.multiplier) should] equal:@(1)];
            [[@(constraint1.constant) should] equal:@(2)];
            
            NSLayoutConstraint *constraint2 = constraints[1];
            [[constraint2.firstItem should] equal:view1];
            [[@(constraint2.firstAttribute) should] equal:@(NSLayoutAttributeLeft)];
            [[@(constraint2.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint2.secondItem should] equal:view2];
            [[@(constraint2.secondAttribute) should] equal:@(NSLayoutAttributeLeft)];
            [[@(constraint2.multiplier) should] equal:@(1)];
            [[@(constraint2.constant) should] equal:@(3)];
            
            NSLayoutConstraint *constraint3 = constraints[2];
            [[constraint3.firstItem should] equal:view1];
            [[@(constraint3.firstAttribute) should] equal:@(NSLayoutAttributeBottom)];
            [[@(constraint3.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint3.secondItem should] equal:view2];
            [[@(constraint3.secondAttribute) should] equal:@(NSLayoutAttributeBottom)];
            [[@(constraint3.multiplier) should] equal:@(1)];
            [[@(constraint3.constant) should] equal:@(-4)];
            
            NSLayoutConstraint *constraint4 = constraints[3];
            [[constraint4.firstItem should] equal:view1];
            [[@(constraint4.firstAttribute) should] equal:@(NSLayoutAttributeRight)];
            [[@(constraint4.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint4.secondItem should] equal:view2];
            [[@(constraint4.secondAttribute) should] equal:@(NSLayoutAttributeRight)];
            [[@(constraint4.multiplier) should] equal:@(1)];
            [[@(constraint4.constant) should] equal:@(-5)];
          });
        });
        context(@"and positive and negative metrics", ^{
          it(@"builds 4 constraints", ^{
            NSArray *formats = @[@"view1.edges == view2.edges(topInset, leftInset, bottomInset, rightInset)"];
            metrics = @{@"topInset": @(2),
                        @"leftInset": @(3),
                        @"bottomInset": @(4),
                        @"rightInset": @(5)};
            NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
            [[constraints should] haveCountOf:4];
            
            NSLayoutConstraint *constraint1 = constraints[0];
            [[constraint1.firstItem should] equal:view1];
            [[@(constraint1.firstAttribute) should] equal:@(NSLayoutAttributeTop)];
            [[@(constraint1.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint1.secondItem should] equal:view2];
            [[@(constraint1.secondAttribute) should] equal:@(NSLayoutAttributeTop)];
            [[@(constraint1.multiplier) should] equal:@(1)];
            [[@(constraint1.constant) should] equal:@(2)];
            
            NSLayoutConstraint *constraint2 = constraints[1];
            [[constraint2.firstItem should] equal:view1];
            [[@(constraint2.firstAttribute) should] equal:@(NSLayoutAttributeLeft)];
            [[@(constraint2.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint2.secondItem should] equal:view2];
            [[@(constraint2.secondAttribute) should] equal:@(NSLayoutAttributeLeft)];
            [[@(constraint2.multiplier) should] equal:@(1)];
            [[@(constraint2.constant) should] equal:@(3)];
            
            NSLayoutConstraint *constraint3 = constraints[2];
            [[constraint3.firstItem should] equal:view1];
            [[@(constraint3.firstAttribute) should] equal:@(NSLayoutAttributeBottom)];
            [[@(constraint3.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint3.secondItem should] equal:view2];
            [[@(constraint3.secondAttribute) should] equal:@(NSLayoutAttributeBottom)];
            [[@(constraint3.multiplier) should] equal:@(1)];
            [[@(constraint3.constant) should] equal:@(-4)];
            
            NSLayoutConstraint *constraint4 = constraints[3];
            [[constraint4.firstItem should] equal:view1];
            [[@(constraint4.firstAttribute) should] equal:@(NSLayoutAttributeRight)];
            [[@(constraint4.relation) should] equal:@(NSLayoutRelationEqual)];
            [[constraint4.secondItem should] equal:view2];
            [[@(constraint4.secondAttribute) should] equal:@(NSLayoutAttributeRight)];
            [[@(constraint4.multiplier) should] equal:@(1)];
            [[@(constraint4.constant) should] equal:@(-5)];

          });
        });
      });
    });
    
    context(@"with invalid attribute", ^{
      it(@"does not build a constraint", ^{
        NSArray *formats = @[@"view1.bottom == view2.invalid"];
        NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
        [[constraints should] haveCountOf:0];
      });
    });
    
    context(@"with view not present in dictionary", ^{
      it(@"does not build a constraint", ^{
        NSArray *formats = @[@"view1.width == viewNotPresent.width"];
        NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
        [[constraints should] haveCountOf:0];
      });
    });
    
  });
  
  describe(@"visual format", ^{
    UIView *view1 = UIView.new;
    UIView *view2 = UIView.new;
    id views = @{@"view1": view1, @"view2": view2};
    
    it(@"builds the constraints", ^{
      NSArray *formats = @[@"H:[view1]-30-[view2]"];
      
      NSArray *constraints = [formatter buildConstraintsWithFormats:formats views:views metrics:metrics];
      [[constraints should] haveCountOf:1];
      
      NSLayoutConstraint *constraint = constraints[0];
      [[constraint.firstItem should] equal:view2];
      [[@(constraint.firstAttribute) should] equal:@(NSLayoutAttributeLeading)];
      [[@(constraint.relation) should] equal:@(NSLayoutRelationEqual)];
      [[constraint.secondItem should] equal:view1];
      [[@(constraint.secondAttribute) should] equal:@(NSLayoutAttributeTrailing)];
      [[@(constraint.multiplier) should] equal:@(1)];
      [[@(constraint.constant) should] equal:@(30)];
    });
    
  });
  
});

SPEC_END