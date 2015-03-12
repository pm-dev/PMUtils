# PMAnimationOperation

![Demo](http://pm-dev.github.io/PMAnimationOperation.gif)

## Requirements & Notes

- PMAnimationOperation was built for iOS and requires a minimum iOS target of iOS 7.

#### Podfile

```ruby
pod "PMUtils/PMAnimationOperation"
```

## Usage

```objective-c
        [[PMAnimationOperation animationWithDelay:0.0
                                         duration:i
                                          options:UIViewAnimationOptionCurveLinear
                                     preAnimation:^(PMAnimationOperation *operation) {
                                         // Do something immediately before the animation
                                     } animation:^{
                                         // Animate something
                                     } postAnimation:^(BOOL finished) {
                                         // Do something immediately after the animation
                                     }] enqueue];
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


