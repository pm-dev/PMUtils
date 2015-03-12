# PMRoundedBorderView

![Demo](http://pm-dev.github.io/PMRoundedBorderView.png)

## Requirements & Notes

- PMRoundedBorderView was built for iOS and requires a minimum iOS target of iOS 7.

#### Podfile

```ruby
pod "PMUtils/PMRoundedBorderView"
```

## Usage

```objective-c

- (void)viewDidLoad {
    [super viewDidLoad];

    self.topView = [[PMRoundedBorderView alloc] init];
    self.bottomView =[[PMRoundedBorderView alloc] init];
    
    self.topView.cornerRadii = CGSizeMake(10.0f, 10.0f);
    self.bottomView.cornerRadii = CGSizeMake(10.0f, 10.0f);
    
    self.topView.corners = UIRectCornerTopLeft | UIRectCornerTopRight;
    self.bottomView.corners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
    
    self.topView.borderWidth = 2.0f;
    self.bottomView.borderWidth = 2.0f;
    
    self.topView.borderColor = [UIColor blackColor];
    self.bottomView.borderColor = [UIColor blackColor];
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


