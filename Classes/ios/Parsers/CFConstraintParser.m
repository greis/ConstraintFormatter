#import "CFConstraintParser.h"
#import "CFGenericParser.h"
#import "CFTerm1Parser.h"
#import "CFRelationParser.h"
#import "CFTerm2MetricParser.h"
#import "CFTerm2WithOperatorsParser.h"
#import "CFTerm1CenterParser.h"
#import "CFTerm2CenterParser.h"
#import "CFTerm1SizeParser.h"
#import "CFTerm2SizeParser.h"
#import "CFTerm1EdgesParser.h"
#import "CFTerm2EdgesParser.h"
#import "CFTerm2MultipleMetricsParser.h"
#import "CFTerm2ViewNameParser.h"
#import "RegexKitLite.h"
#import "CFConstraintContext.h"

@implementation CFConstraintParser

-(id)initWithViews:(NSDictionary *)views metrics:(NSDictionary *)metrics {
  self = [super init];
  if (self) {
    [self setViews:views];
    [self setMetrics:metrics];
    
    [self setTerm1Parsers:@[
                            [[CFTerm1CenterParser alloc] init],
                            [[CFTerm1SizeParser alloc] init],
                            [[CFTerm1EdgesParser alloc] init],
                            [[CFTerm1Parser alloc] init]
                            ]];
    
    [self setRelationParsers:@[
                               [[CFRelationParser alloc] init]
                               ]];

    [self setTerm2Parsers:@[
                            [[CFTerm2ViewNameParser alloc] init],
                            [[CFTerm2MetricParser alloc] init],
                            [[CFTerm2MultipleMetricsParser alloc] init],
                            [[CFTerm2CenterParser alloc] init],
                            [[CFTerm2SizeParser alloc] init],
                            [[CFTerm2EdgesParser alloc] init],
                            [[CFTerm2WithOperatorsParser alloc] init]
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
    CFConstraintContext *context = [[CFConstraintContext alloc] init];
    [context setViews:self.views];
    [context setMetrics:self.metrics];
    
    [self executeParsers:self.term1Parsers withText:match[@"term1"] context:context];
    [self executeParsers:self.relationParsers withText:match[@"relation"] context:context];
    [self executeParsers:self.term2Parsers withText:match[@"term2"] context:context];
    
    if ([context hasErrors]) {
      NSLog(@"Invalid constraint: '%@'. Errors: %@", expression, context.errorsMessage);
      return @[];
    } else {
      return context.constraints;
    }
    
  } else {
    return [NSLayoutConstraint constraintsWithVisualFormat:expression options:0 metrics:self.metrics views:self.views];
  }
}

-(void)executeParsers:(NSArray *)parsers withText:(NSString *)text context:(CFConstraintContext *)context {
  for (CFGenericParser *parser in parsers) {
    if ([parser parse:text context:context]) {
      break;
    }
  }
}

-(NSString *)regexForParsers:(NSArray *)parsers {
  NSMutableArray *regexps = [NSMutableArray array];
  for (CFGenericParser *parser in parsers) {
    NSString *regex = [parser.regex stringByReplacingOccurrencesOfRegex:@"([^\\\\]\\((?!\\?:))" withString:@"$1?:"];
    regex = [regex stringByReplacingOccurrencesOfRegex:@"[$^]" withString:@""];
    [regexps addObject:regex];
  }
  return [regexps componentsJoinedByString:@"|"];
}

@end
