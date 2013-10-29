#import "ConstraintParser.h"
#import "GenericParser.h"
#import "Term1Parser.h"
#import "RelationParser.h"
#import "MetricParser.h"
#import "Term2WithOperatorsParser.h"
#import "RegexKitLite.h"
#import "ConstraintContext.h"

@implementation ConstraintParser

-(id)initWithViews:(NSDictionary *)views metrics:(NSDictionary *)metrics {
  self = [super init];
  if (self) {
    [self setViews:views];
    [self setMetrics:metrics];
    
    [self setTerm1Parsers:@[
                            [[Term1Parser alloc] init]
                            ]];
    
    [self setRelationParsers:@[
                               [[RelationParser alloc] init]
                               ]];

    [self setTerm2Parsers:@[
                            [[MetricParser alloc] init],
                            [[Term2WithOperatorsParser alloc] init]
                            ]];
  }
  return self;
}

-(NSArray *)parse:(NSString *)expression {
  NSString *regex = [NSString stringWithFormat:@"^(%@) (%@) (%@)$",
                     [self regexForParsers:self.term1Parsers],
                     [self regexForParsers:self.relationParsers],
                     [self regexForParsers:self.term2Parsers]];
  
  NSDictionary *match = [expression dictionaryByMatchingRegex:regex withKeysAndCaptures:@"term1", 1, @"relation", 2, @"term2", 3, nil];
  
  if (match.count) {
    ConstraintContext *context = [[ConstraintContext alloc] init];
    [context setViews:self.views];
    [context setMetrics:self.metrics];
    
    [self executeParsers:self.term1Parsers withText:match[@"term1"] context:context];
    [self executeParsers:self.relationParsers withText:match[@"relation"] context:context];
    [self executeParsers:self.term2Parsers withText:match[@"term2"] context:context];
    
    return context.constraints;
    
  } else {
    return [NSLayoutConstraint constraintsWithVisualFormat:expression options:0 metrics:self.metrics views:self.views];
  }
}

-(void)executeParsers:(NSArray *)parsers withText:(NSString *)text context:(ConstraintContext *)context {
  for (GenericParser *parser in parsers) {
    if ([parser parse:text context:context]) {
      break;
    }
  }
}

-(NSString *)regexForParsers:(NSArray *)parsers {
  NSMutableArray *regexps = [NSMutableArray array];
  for (GenericParser *parser in parsers) {
    NSString *regex = [parser.regex stringByReplacingOccurrencesOfRegex:@"\\((?!\\?:)" withString:@"(?:"];
    regex = [regex stringByReplacingOccurrencesOfRegex:@"[$^]" withString:@""];
    [regexps addObject:regex];
  }
  return [regexps componentsJoinedByString:@"|"];
}

@end
