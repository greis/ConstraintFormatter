#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CFConstraintContext : NSObject

@property(nonatomic, copy) NSString *view1Name;
@property(nonatomic) NSLayoutRelation relation;
@property(nonatomic, copy) NSString *view2Name;
@property(nonatomic) CGFloat multiplier;
@property(nonatomic, strong) NSDictionary *metrics;
@property(nonatomic, strong) NSDictionary *views;

-(NSArray *)constraints;

-(void)addView1Attribute:(NSLayoutAttribute)attribute;
-(void)addView1AttributeByName:(NSString *)attribute;
-(void)addView2Attribute:(NSLayoutAttribute)attribute;
-(void)addView2AttributeByName:(NSString *)attribute;
-(void)copyView1AttributesToView2;
-(void)addConstant:(CGFloat)constant;
-(void)addError:(NSString *)error, ...;
-(BOOL)hasErrors;
-(NSString *)errorsMessage;
@end
