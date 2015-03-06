# PMCircularCollectionView

PMCircularCollectionView is a subclass of UICollectionView that scrolls infinitely in the horizontal or vertical direction. PMCircularCollectionView also includes a subclass which automatically centers the cell nearest to the middle of the collection view after scrolling.

![Demo](http://pm-dev.github.io/PMCircularCollectionView.gif)


## Requirements & Notes

- PMCircularCollectionView was built for iOS and requires a minimum iOS target of iOS 7.
- Thorough commenting of header files is currently in progress. (6/11/14).
- PMCircularCollectionView is currently lacking unit tests.

## How To Get Started

- Check out the documentation (coming soon).

### Installation with CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like PMCircularCollectionView in your projects. See the ["Getting Started" guide for more information](http://guides.cocoapods.org/using/getting-started.html).

#### Podfile

```ruby
platform :ios, '7.0'
pod "PMCircularCollectionView"
```

## Usage


### Creating a PMCircularCollectionView

```objective-c
PMCenteredCollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
layout.minimumLineSpacing = 10;	
layout.minimumInteritemSpacing = 0;

PMCenteredCircularCollectionView *collectionView = [PMCircularCollectionView collectionViewWithFrame:self.view.bounds collectionViewLayout:layout];
collectionView.delegate = self;
collectionView.dataSource = self;
```

### UICollectionViewDataSource

```objective-c
- (UICollectionViewCell *) collectionView:(PMCenteredCircularCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PMCellReuseIdentifier forIndexPath:indexPath];
    NSInteger normalizedIndex = [collectionView normalizeIndex:indexPath.item];
    /*
    * Configure cell based on indexPath.section and normalizedIndex.
    */
}
```

#### Discussion

 - To achieve infinite scrolling, PMCircularCollectionView employes a technique described in [this blog post](http://iphone2020.wordpress.com/2012/10/01/uitableview-tricks-part-2-infinite-scrolling) which multiplies the content size and consequently the number of index paths. Thus, it is possible for dataSource and delegate methods to pass an index path with item == 15, when less than 16 items were returned to the -collectionView:numberOfItemsInSection: delegate method. As seen in the examples above, call -normalizeIndex: to change the item index to the correct value.
 - -numberOfSectionsInCollectionView: will never be called. PMCircularCollectionView only supports 1 section.

### Creating a PMCenteredCircularCollectionView

```objective-c
PMCenteredCollectionViewFlowLayout *layout = [PMCenteredCollectionViewFlowLayout new];
layout.centeringDisabled = NO;
layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
layout.minimumLineSpacing = 10;	
layout.minimumInteritemSpacing = 0;

PMCenteredCircularCollectionView *collectionView = [PMCenteredCircularCollectionView collectionViewWithFrame:self.view.bounds collectionViewLayout:layout];
collectionView.delegate = self;
collectionView.dataSource = self;
```

### PMCenteredCircularCollectionViewDelegate

```objective-c
- (void) collectionView:(PMCenteredCircularCollectionView *)collectionView didCenterItemAtIndex:(NSUInteger)index
{
    NSUInteger normalizedIndex = [collectionView normalizeIndex:index];
	NSLog(@"Collection View: %@\nDid center item at index %d", collectionView, normalizedIndex);
}
```

## Communication

- If you **need help**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/PMCircularCollectionView). (Tag 'PMCircularCollectionView')
- If you'd like to **ask a general question**, use [Stack Overflow](http://stackoverflow.com/questions/tagged/PMCircularCollectionView).
- If you **found a bug**, open an issue.
- If you **have a feature request**, open an issue.
- If you **want to contribute**, submit a pull request.


## Author

- [Peter Meyers](mailto:petermeyers1@gmail.com)

## License

PMCircularCollectionView is available under the MIT license. See the LICENSE file for more info.

