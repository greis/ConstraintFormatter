ConstraintFormatter
===================

ConstraintFormatter is a library to unify visual constraints and constraints based on attributes for Auto Layout.

It's really verbose to write NSLayoutConstraints based on attributes and with this library you can easily write and mix them with visual constraints. Something like this:

```objc
#import "ConstraintFormatter.h"

...

id views = @{@"view1": view1, @"view2": view2};
id metrics = @{@"margin": @(10)};
id formats = @[@"view1.bottom == view2.top + margin",
               @"view1.centerX == superview.centerX",
               @"H:|-margin-[view1]-margin-|",
               @"H:|[view2]|"];
  
[view addConstraintsWithFormats:formats
                          views:views
                        metrics:metrics];
```

As you see, the views and metrics are used to define the constraints. Also it's worth to know the library calls setTranslatesAutoresizingMaskIntoConstraints:NO in all views for you.

The following attributes are available:
* left
* right
* top
* bottom
* leading
* trailing
* width
* height 
* centerX
* centerY
* baseline

The following relations are available:
* ==
* >=
* <=

Use + or - to define constants:
```objc
@"view1.centerX == view2.centerX + 10"
@"view1.centerY == view2.centerY - 10"
```

Use * to define multipliers:
```objc
@"view1.width == view2.width * 0.5"
```

You can mix constants and multipliers:
```objc
@"view1.width == view2.width * 0.5 - 10"
```

You can also write constraints for only 1 view:
```objc
@"view1.width >= 30"
```

If you want to reference the view which all constraints are being added, just use 'superview':
```objc
@"view1.centerX == superview.centerX"
```
