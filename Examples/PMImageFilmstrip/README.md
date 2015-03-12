# PMImageFilmstrip

![Demo](http://pm-dev.github.io/PMImageFilmstrip.gif)

## Requirements & Notes

- PMImageFilmstrip was built for iOS and requires a minimum iOS target of iOS 7.


#### Podfile

```ruby
pod "PMUtils/PMImageFilmstrip"
```

## Usage


```objective-c

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageFilmstrip.delegate = self;
    self.imageFilmstrip.maximumZoomScale = 3.0f;
}


#pragma mark - PMImageFilmstripDelegate


- (NSInteger) numberOfImagesInImageFilmstrip:(PMImageFilmstrip *)imageFilmstrip {
    return 3;
}

- (void) imageFilmstrip:(PMImageFilmstrip *)imageFilmstrip configureFilmstripImageView:(UIImageView *)imageView atIndex:(NSUInteger)index
{
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    switch (index) {
        case 0:
            imageView.image = /*First image*/
            break;
        case 1:
            imageView.image = /*Second image*/
            break;
        case 2:
            imageView.image = /*Third image*/
            break;
        default:
            break;
    }    
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


