#import "ConstraintLogger.h"

@implementation ConstraintLogger

+(void)log:(NSString *)message, ... {
  va_list args;
  va_start(args, message);
  NSLogv(message, args);
  va_end(args);
}

@end
