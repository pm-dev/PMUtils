# PMCollectionViewSwipeCell

![Demo](http://pm-dev.github.io/PMCollectionViewSwipeCell.gif)

## Requirements & Notes

- PMCollectionViewSwipeCell was built for iOS and requires a minimum iOS target of iOS 7.


#### Podfile

```ruby
pod "PMUtils/PMCollectionViewSwipeCell"
```

## Usage

```objective-c
    PMCollectionViewSwipeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PMCollectionViewSwipeCell" forIndexPath:indexPath];
	cell.leftUtilityView = /*leftView*/;
   	cell.rightUtilityView = /*rightView*/;
	cell.bouncesOpen = YES;
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


