# PMUtils

PMUtils is a useful library that contains extensive categories on Foundation and UIKit classes for common tasks. PMUtils also contains a few custom classes for common use-cases such as PMOrderedDicionary and PMImageFilmstrip.

## Requirements & Notes

- PMUtils was built for iOS and requires a minimum iOS target of iOS 7.
- Thorough commenting of header files is currently in progress. (6/11/14).
- PMUtils is currently lacking unit tests.

## How To Get Started

- Check out the documentation (coming soon).

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like PMUtils in your projects. See the ["Getting Started" guide for more information](http://guides.cocoapods.org/using/getting-started.html).

#### Podfile

```ruby
platform :ios, '7.0'
pod "PMUtils"
```

## Usage

The example project provides a canvas to play with the different classes and categories in PMUtils. To run the example project, clone the repo, run `pod install` from the Example directory, then launch PMUtils-iOSExample.xcworkspace.

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/PMUtils). (Tag 'PMUtils')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/PMUtils).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.

## Credits

- Many of the class category methods in PMUtils were created by Jeff Cruikshank, Paul Hangas and/or Jason Bobier in the development of [One Kings Lane for iPhone/iPad](https://itunes.apple.com/us/app/one-kings-lane-home-decor/id403827899?mt=8).
- PMOrderedDictionary is a small enhancement to code developed by [Matt Gallagher](https://twitter.com/cocoawithlove). See [OrderedDictionary: Subclassing a Cocoa class cluster](http://www.cocoawithlove.com/2008/12/ordereddictionary-subclassing-cocoa.html) for an excellent tutorial on subclassing a cocoa collection class.
- PMProtocolInterceptor is built using code from [this Stack Overflow question](http://stackoverflow.com/questions/3498158/intercept-obj-c-delegate-messages-within-a-subclass) contributed to by users: [e.James](http://stackoverflow.com/users/33686/e-james) [mackworth](http://stackoverflow.com/users/580850/mackworth) and [WeZZard](http://stackoverflow.com/users/1393062/wezzard).
- UIImage+PMUtils contains a method for bluring images that is based on code from [7blur](https://github.com/justinmfischer/7blur) developed by [Justin M Fischer](https://github.com/justinmfischer).

## Author

- [Peter Meyers](mailto:petermeyers1@gmail.com)

## License

PMUtils is available under the MIT license. See the LICENSE file for more info.

