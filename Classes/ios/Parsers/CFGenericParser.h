#import <Foundation/Foundation.h>
#import "CFConstraintContext.h"


@interface CFGenericParser : NSObject

-(BOOL)parse:(NSString *)text context:(CFConstraintContext *)context;

-(NSString *)regexFor:(NSString *)string;
-(float)parseMetric:(NSString *)string withContext:(CFConstraintContext *)context;
-(NSLayoutRelation)layoutRelationByString:(NSString *)string;

@property(nonatomic, copy) NSString *regex;

@end
