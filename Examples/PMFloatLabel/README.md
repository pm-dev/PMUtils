# PMFloatLabel

![Demo](http://pm-dev.github.io/PMFloatLabel.gif)

## Requirements & Notes

- PMFloatLabel was built for iOS and requires a minimum iOS target of iOS 7.

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the ["Getting Started" guide for more information](http://guides.cocoapods.org/using/getting-started.html).

#### Podfile

```ruby
pod "PMUtils/PMFloatLabel"
```

## Usage


``` objective-c

#pragma mark - PMFloatTextFieldDelegate


- (BOOL) floatTextField:(PMFloatTextField *)floatTextField shouldShowFloatLabelWithText:(BOOL)isText editing:(BOOL)isEditing
{
    return isText;
}

- (CGFloat) floatTextField:(PMFloatTextField *)floatTextField floatLabelVerticalSpacing:(BOOL)isEditing
{
    return 6.0f;
}

- (NSAttributedString *) floatTextField:(PMFloatTextField *)floatTextField floatLabelAttributedString:(BOOL)isEditing
{
    UIColor *color = isEditing? [UIColor colorWithRed:0.5f green:0.5f blue:0.9f alpha:1.0f] : [UIColor colorWithWhite:0.0f alpha:1.0f];
    return [[NSAttributedString alloc] initWithString:@"Name" attributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: [UIFont systemFontOfSize:13.0f]}];
}

```

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/PMUtils). (Tag 'PMUtils')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/PMUtils).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.


## Author

- [Peter Meyers](mailto:petermeyers1@gmail.com)

## License

All PMUtils specs are available under the MIT license. See the LICENSE file for more info.


