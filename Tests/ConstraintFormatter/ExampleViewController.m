#import "ExampleViewController.h"
#import "ConstraintFormatter.h"

@interface ExampleViewController ()
@property(nonatomic) NSArray *formats;
@end

@implementation ExampleViewController

- (id)initWithName:(NSString *)name andFormats:(NSArray *)formats {
  self = [super init];
  if (self) {
    [self setTitle: name];
    [self setFormats:formats];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController.navigationBar setTranslucent:NO];
  
  UIView *containerView = [self viewWithName:@"superview" color:[UIColor grayColor]];
  [self.view addSubview:containerView];
  
  UILabel *constraintsLabel = [[UILabel alloc]initWithFrame:CGRectZero];
  [constraintsLabel setFont:[UIFont systemFontOfSize:12]];
  [constraintsLabel setText:[self.formats componentsJoinedByString:@"\n"]];
  [constraintsLabel setNumberOfLines:0];
  [self.view addSubview:constraintsLabel];
  
  
  id formats = @[@"V:|-[container]-[constraintsLabel]-|",
                 @"H:|-[container]-|",
                 @"H:|-[constraintsLabel]-|",
                 @"container.height == container.width"];
  id views = @{@"container": containerView, @"constraintsLabel": constraintsLabel};
  [self.view addConstraintsWithFormats:formats views:views metrics:nil];
  
  
  [self applyFormatsInView:containerView];
}

-(void)applyFormatsInView:(UIView *)containerView {
  UIView *view1 = [self viewWithName:@"view1" color:[UIColor blueColor]];
  UIView *view2 = [self viewWithName:@"view2" color:[UIColor redColor]];
  
  [containerView addSubview:view1];
  [containerView addSubview:view2];
  
  id views = @{@"view1": view1, @"view2": view2};
  id metrics = nil;
  
  [containerView addConstraintsWithFormats:self.formats views:views metrics:metrics];
}

-(UIView *)viewWithName:(NSString *)name color:(UIColor *)color {
  UIView *view = [[UIView alloc] init];
  [view.layer setBorderColor:color.CGColor];
  [view.layer setBorderWidth:1];
  UILabel *label = [[UILabel alloc] init];
  [label setFont:[UIFont systemFontOfSize:12]];
  [label setTextColor:color];
  [label setText:name];
  [view addSubview:label];
  [view addConstraintsWithFormats:@[@"label.left == superview.left + 5", @"label.top == superview.top"] views:@{@"label": label} metrics:nil];
  return view;
}

@end
