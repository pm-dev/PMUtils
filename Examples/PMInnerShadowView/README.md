# PMInnerShadowView

![Demo](http://pm-dev.github.io/PMInnerShadowView.png)

## Requirements & Notes

- PMInnerShadowView was built for iOS and requires a minimum iOS target of iOS 7.

#### Podfile

```ruby
pod "PMUtils/PMInnerShadowView"
```

## Usage

```objective-c
    self.innerShadowView = [[PMInnerShadowView alloc] init];
    self.innerShadowView.cornerRadius = 4.0f;
    self.innerShadowView.shadowOffset = CGSizeZero;
    self.innerShadowView.shadowOpacity = 0.8f;
    self.innerShadowView.shadowRadius = 22.0f;
    self.innerShadowView.shadowColor = [UIColor redColor];
    self.innerShadowView.edges = UIRectEdgeLeft | UIRectEdgeRight;
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


