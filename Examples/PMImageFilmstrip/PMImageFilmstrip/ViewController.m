//
//  ViewController.m
//  PMImageFilmstrip
//
//  Created by Peter Meyers on 3/6/15.
//  Copyright (c) 2015 Peter Meyers. All rights reserved.
//

#import "ViewController.h"
#import "PMImageFilmstrip.h"

@interface ViewController () <PMZoomableImageFilmstripDelegate>
@property (weak, nonatomic) IBOutlet PMZoomableImageFilmstrip *imageFilmstrip;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageFilmstrip.delegate = self;
    self.imageFilmstrip.maximumZoomScale = 3.0f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - PMZoomableImageFilmstripDelegate


- (NSInteger) numberOfImagesInImageFilmstrip:(PMImageFilmstrip *)imageFilmstrip {
    return 3;
}

- (void) imageFilmstrip:(PMImageFilmstrip *)imageFilmstrip configureFilmstripImageView:(UIImageView *)imageView atIndex:(NSUInteger)index
{
    switch (index) {
        case 0:
            imageView.image = [UIImage imageNamed:@"one.jpg"];
            break;
        case 1:
            imageView.image = [UIImage imageNamed:@"two.jpg"];
            break;
        case 2:
            imageView.image = [UIImage imageNamed:@"three.jpg"];
            break;
        default:
            break;
    }
    imageView.contentMode = UIViewContentModeScaleAspectFill;
}

@end
