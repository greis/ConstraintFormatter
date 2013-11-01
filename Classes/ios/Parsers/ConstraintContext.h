#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ConstraintContext : NSObject

@property(nonatomic, copy) NSString *view1Name;
@property(nonatomic) NSLayoutRelation relation;
@property(nonatomic, copy) NSString *view2Name;
@property(nonatomic) CGFloat multiplier;
@property(nonatomic) CGFloat constant;
@property(nonatomic, strong) NSDictionary *metrics;
@property(nonatomic, strong) NSDictionary *views;

-(NSArray *)constraints;

-(void)addView1Attribute:(NSLayoutAttribute)attribute;
-(void)addView2Attribute:(NSLayoutAttribute)attribute;
@end
