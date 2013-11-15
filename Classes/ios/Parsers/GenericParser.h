#import <Foundation/Foundation.h>
#import "ConstraintContext.h"


@interface GenericParser : NSObject

-(BOOL)parse:(NSString *)text context:(ConstraintContext *)context;

-(NSString *)regexFor:(NSString *)string;
-(float)parseMetric:(NSString *)string withContext:(ConstraintContext *)context;
-(NSLayoutRelation)layoutRelationByString:(NSString *)string;

@property(nonatomic, copy) NSString *regex;

@end
