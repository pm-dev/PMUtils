# PMProgressHUD

![Demo](http://pm-dev.github.io/PMProgressHUD.gif)

## Requirements & Notes

- PMProgressHUD was built for iOS and requires a minimum iOS target of iOS 7.

#### Podfile

```ruby
pod "PMUtils/PMProgressHUD"
```

## Usage

```objective-c
- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self connect];
}

- (void) connect {
    _HUD.message = @"Connecting...";
    _HUD.progressHUDState = PMProgressHUDStatePending;
    [_HUD presentAfterDelay:0.0 completion:nil];
    [self performSelector:@selector(failed) withObject:nil afterDelay:3.0];
}

- (void) failed {
    _HUD.message = @"Failed.";
    _HUD.progressHUDState = PMProgressHUDStateFailed;
    [self performSelector:@selector(tryAgain) withObject:nil afterDelay:3.0];
}

- (void) tryAgain {
    _HUD.message = @"Trying Again...";
    _HUD.progressHUDState = PMProgressHUDStatePending;
    [self performSelector:@selector(complete) withObject:nil afterDelay:3.0];
}

- (void) complete {
    _HUD.message = @"Complete!";
    _HUD.progressHUDState = PMProgressHUDStateComplete;
    [_HUD dismissAfterDelay:2.0 completion:nil];
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


