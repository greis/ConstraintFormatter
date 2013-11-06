#import "AppDelegate.h"
#import "ListController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  
  ListController *listController = [[ListController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:listController];
  [self.window setRootViewController:navController];

  [self.window makeKeyAndVisible];
  return YES;
}

@end
