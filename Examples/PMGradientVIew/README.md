# PMGradientView

![Demo](http://pm-dev.github.io/PMGradientView.png)

## Requirements & Notes

- PMGradientView was built for iOS and requires a minimum iOS target of iOS 7.


#### Podfile

```ruby
pod "PMUtils/PMGradientView"
```

## Usage

```objective-c
    self.gradientView = [PMGradientView new];
    self.gradientView.startColor = [UIColor blueColor];
    self.gradientView.endColor = [UIColor redColor];
    self.gradientView.startPoint = CGPointMake(0.0f, 0.0f);
    self.gradientView.endPoint = CGPointMake(1.0f, 1.0f);
    self.gradientView.locations = @[@0.1, @0.9];
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


