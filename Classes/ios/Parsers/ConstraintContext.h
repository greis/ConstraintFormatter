#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ConstraintContext : NSObject

@property(nonatomic) NSString *view1Name;
@property(nonatomic) NSLayoutAttribute view1Attribute;
@property(nonatomic) NSLayoutRelation relation;
@property(nonatomic) NSString *view2Name;
@property(nonatomic) NSLayoutAttribute view2Attribute;
@property(nonatomic) CGFloat multiplier;
@property(nonatomic) CGFloat constant;
@property(nonatomic) NSDictionary *metrics;
@property(nonatomic) NSDictionary *views;

-(NSArray *)constraints;
@end
