#import <Foundation/Foundation.h>

@interface CFConstraintParser : NSObject

-(id)initWithViews:(NSDictionary *)views metrics:(NSDictionary *)metrics;
-(NSArray *)parse:(NSString *)expression;

@property(nonatomic) NSDictionary* views;
@property(nonatomic) NSDictionary* metrics;
@property(nonatomic) NSArray *term1Parsers;
@property(nonatomic) NSArray *relationParsers;
@property(nonatomic) NSArray *term2Parsers;

@end
