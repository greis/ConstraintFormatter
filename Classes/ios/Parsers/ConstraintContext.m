#import "ConstraintContext.h"

@interface ConstraintContext ()
@property(nonatomic) NSMutableArray *view1Attributes;
@property(nonatomic) NSMutableArray *view2Attributes;
@property(nonatomic) NSMutableArray *constants;
@property(nonatomic) NSMutableArray *errors;
@end

@implementation ConstraintContext

- (id)init
{
  self = [super init];
  if (self) {
    [self setView1Attributes:[NSMutableArray array]];
    [self setView2Attributes:[NSMutableArray array]];
    [self setConstants:[NSMutableArray array]];
    [self setErrors:[NSMutableArray array]];
    [self setMultiplier:1];
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
    CGFloat constant = [self constantForIndex:i];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:view1 attribute:attribute1 relatedBy:self.relation toItem:view2 attribute:attribute2 multiplier:self.multiplier constant:constant];
    [constraints addObject:constraint];
  }
  return constraints;
}

-(CGFloat)constantForIndex:(int)index {
  if (self.constants.count == 0) {
    return 0;
  } else {
    return [self.constants[index] floatValue];
  }
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

-(void)addView1Attribute:(NSLayoutAttribute)attribute {
  [self.view1Attributes addObject:@(attribute)];
}

-(void)addView1AttributeByName:(NSString *)attribute {
  NSNumber *attr = self.layoutAttributes[attribute];
  if (attr) {
    [self.view1Attributes addObject:attr];
  } else {
    [self addError:@"Attribute %@ is invalid", attribute];
  }
}

-(void)addView2Attribute:(NSLayoutAttribute)attribute {
  [self.view2Attributes addObject:@(attribute)];
}

-(void)addView2AttributeByName:(NSString *)attribute {
  NSNumber *attr = self.layoutAttributes[attribute];
  if (attr) {
    [self.view2Attributes addObject:attr];
  } else {
    [self addError:@"Attribute %@ is invalid", attribute];
  }
}

-(void)addConstant:(CGFloat)constant {
  [self.constants addObject:@(constant)];
}

-(void)setView1Name:(NSString *)viewName {
  if (self.views[viewName]) {
    _view1Name = viewName;
  } else {
    [self addError:@"View %@ is not present on the dictionary", viewName];
  }
}

-(void)setView2Name:(NSString *)viewName {
  if (self.views[viewName]) {
    _view2Name = viewName;
  } else {
    [self addError:@"View %@ is not present on the dictionary", viewName];
  }
}

-(void)addError:(NSString *)error, ... {
  NSString *contents;
  va_list args;
  va_start(args, error);
  contents = [[NSString alloc] initWithFormat:error arguments:args];
  va_end(args);
  [self.errors addObject:contents];
}

-(NSString *)errorsMessage {
  return [self.errors componentsJoinedByString:@", "];
}

-(BOOL)hasErrors {
  return self.errors.count > 0;
}

@end
