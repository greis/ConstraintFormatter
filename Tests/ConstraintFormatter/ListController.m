#import "ListController.h"
#import "ExampleViewController.h"

@interface ListController ()
@property(nonatomic) NSDictionary *formats;
@end

@implementation ListController {
}

- (id)init {
  self = [super initWithStyle:UITableViewStylePlain];
  if (self) {
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self setTitle:@"Examples"];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.formats = @{
                 @"Center": @[@"view1.center == superview.center", @"view1.width == 40", @"view1.height == 40", @"view2.center == view1.center(40, 40)", @"view2.width == 40", @"view2.height == 40"],
                 @"Size": @[@"view1.size == superview.size(-30, -100)", @"view1.center == superview.center", @"view2.size == view1", @"view2.center == view1.center(0, 20)"],
                 @"Edges": @[@"view1.edges == superview.edges(25, 35, 25, 35)", @"view2.edges == view1.edges(20, 20, 20, 20)"],
                 @"Left": @[@"view1.left == superview.left + 10", @"view2.left == view1.right", @"view1.size == (50, 50)", @"view2.size == view1.size", @"view1.centerY == superview.centerY", @"view2.centerY == superview.centerY"],
                 };
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.formats count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *simpleTableIdentifier = @"List";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
  
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
  }
  
  cell.textLabel.text = [[self.formats.allKeys sortedArrayUsingSelector:@selector(compare:)] objectAtIndex:indexPath.row];
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  
  NSString *name = cell.textLabel.text;
  
  ExampleViewController *exampleController = [[ExampleViewController alloc]initWithName:name andFormats:self.formats[name]];
  [self.navigationController pushViewController:exampleController animated:YES];
}

@end
