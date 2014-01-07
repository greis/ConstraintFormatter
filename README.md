ConstraintFormatter
===================


[![Build Status](https://travis-ci.org/greis/ConstraintFormatter.png?branch=master)](https://travis-ci.org/greis/ConstraintFormatter)

ConstraintFormatter is a library to unify visual constraints and constraints based on attributes for Auto Layout.

It's really verbose to write NSLayoutConstraints based on attributes and with this library you can easily write and mix them with visual constraints. Something like this:

```objc
#import "ConstraintFormatter.h"

...

id views = @{@"view1": view1, @"view2": view2};
id metrics = @{@"margin": @10};
id formats = @[@"view1.bottom == view2.top + margin",
               @"view1.centerX == superview.centerX",
               @"H:|-margin-[view1]-margin-|",
               @"H:|[view2]|"];

[view addConstraintsWithFormats:formats
                          views:views
                        metrics:metrics];
```

As you see, the views and metrics are used to define the constraints. Also it's worth to know the library calls setTranslatesAutoresizingMaskIntoConstraints:NO in all views for you.

## Attributes

### Standard

* left
* right
* top
* bottom
* width
* height
* centerX
* centerY
* baseline
* leading
* trailing

### Special

#### center
Shortcut for centerX and centerY:

```objc
@"view2.center == view1.center"
```

To define offsets for centerX and centerY, provide them inside parenthesis:

```objc
@"view2.center == view1.center(40, 40)"
```

#### edges
Shortcut to top, left, bottom, right:

```objc
@"view1.edges == superview.edges"
```

To define insets to top, left, bottom, right, provide them inside parenthesis:

```objc
@"view1.edges == superview.edges(25, 35, 25, 35)"
```

#### size
Shortcut to width and height:

```objc
@"view1.size == view2.size"
```

To specify values for width and height with offset, provide them inside parenthesis:

```objc
@"view1.size == view2.size(50, 50)"
```

To specify values for width and height, provide them inside parenthesis:
```objc
@"view1.size == (50, 50)"
```

## Relations
* ==
* >=
* <=

Specifying relation between two views:
```objc
@"view1.centerX == view2.centerX"
```

Specifying the value of an attribute for one view:
```objc
@"view1.width >= 30"
```

## Constants
* +
* -
* *
* /

Use + or - to define constants:
```objc
@"view1.centerX == view2.centerX + 10"
@"view1.centerY == view2.centerY - 10"
```

Use * to define multipliers:
```objc
@"view1.width == view2.width * 0.5"
```

You can also use / to define multipliers:
```objc
@"view1.width == view2.width / 2"
```

You can mix constants and multipliers:
```objc
@"view1.width == view2.width * 0.5 - 10"
```

## Superview

If you want to reference the view which all constraints are being added, just use 'superview':
```objc
@"view1.centerX == superview.centerX"
```
