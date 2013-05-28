//
//  IPImageCropperViewController.m
//  Impossible
//
//  Created by Ullrich Schäfer on 12.03.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import "UIView+NXKit.h"

#import "IPConstants.h"

#import "UIColor+ImpossibleProject.h"
#import "UIView+ImpossibleProject.h"

#import "IPGridView.h"
#import "IPPhotoFrameView.h"
#import "IPButton.h"
#import "IPExposureButtonAreaView.h"

#import "IPOptimizationViewController.h"

#import "IPImageCropperViewController.h"


@interface IPImageCropperViewController () <UIScrollViewDelegate>
@property (strong) UIImage *image;
@property (strong) UIImage *croppedImage;

@property (strong) UIView *buttonContainer;
@property (strong) IPButton *cropButton;
@end


@implementation IPImageCropperViewController

#pragma mark Lifecycle

- (id)initWithImage:(UIImage *)image;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.image = image;
        self.title = @"Crop";
    }
    return self;
}


#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoFrameView = [[IPPhotoFrameView alloc] initWithStyle:IPPhotoViewStyleOpaqueBar];
    self.photoFrameView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.photoFrameView];
    
    UIView *scrollAndGridViewContrainer = [[UIView alloc] initWithFrame:CGRectZero];
    scrollAndGridViewContrainer.translatesAutoresizingMaskIntoConstraints = NO;
    self.photoFrameView.contentView = scrollAndGridViewContrainer;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:scrollAndGridViewContrainer.bounds];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scrollView.backgroundColor = [UIColor blackColor];
    self.scrollView.delegate = self;
    self.scrollView.showsHorizontalScrollIndicator = self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.maximumZoomScale = 2.0;
    [scrollAndGridViewContrainer addSubview:self.scrollView];
    
    self.gridView = [[IPGridView alloc] initWithFrame:scrollAndGridViewContrainer.bounds];
    self.gridView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [scrollAndGridViewContrainer addSubview:self.gridView];
    
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageView.autoresizingMask = UIViewAutoresizingNone;
    self.imageView.frame = (CGRect){CGPointZero, self.image.size};
    self.imageView.backgroundColor = [UIColor redColor];
    [self.scrollView addSubview:self.imageView];
    
    self.scrollView.contentSize = self.imageView.bounds.size;
        
    // <Buttons>
    self.buttonContainer = [[IPExposureButtonAreaView alloc] initWithFrame:self.view.bounds];
    self.buttonContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.buttonContainer];
    
    self.cropButton = [IPButton button];
    self.cropButton.changeAlphaOnHighlight = NO;
    self.cropButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.cropButton setImage:[UIImage imageNamed:@"instantlab_screen3_button-crop_inactive"]
                     forState:UIControlStateNormal];
    [self.cropButton setImage:[UIImage imageNamed:@"instantlab_screen3_button-crop_active"]
                     forState:UIControlStateHighlighted];
    [self.cropButton addTarget:self action:@selector(crop:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonContainer addSubview:self.cropButton];
    
    // </Buttons>

    // layout main views
    [self.view nx_addVisualConstraints:(@[
                                        @"H:|[photoFrameView]|",
                                        @"H:|[buttonContainer]|",
                                        @"V:|[photoFrameView][buttonContainer]|"])
                                 views:(@{
                                        @"photoFrameView" : self.photoFrameView,
                                        @"buttonContainer" : self.buttonContainer})];
    
    // layout buttons
    [self.view nx_addVisualConstraints:(@[
                                        @"H:|[cropButton]|",
                                        @"V:|[cropButton]|"])
                                 views:(@{
                                        @"cropButton" : self.cropButton})];
    
    
    // lets layout first so we can calculate the scrollView properties
    [self.view layoutIfNeeded];
    
    CGFloat aspectRatio = self.image.size.width / self.image.size.height;
    CGFloat minimumZoomScale = 0;
    if (aspectRatio >= 1.0) {
        minimumZoomScale = CGRectGetHeight(self.scrollView.bounds) / self.scrollView.contentSize.height;
    } else {
        minimumZoomScale = CGRectGetWidth(self.scrollView.bounds) / self.scrollView.contentSize.width;
    }
    self.scrollView.minimumZoomScale = minimumZoomScale;
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    
    CGFloat xOffset = 0, yOffset = 0; // needs to be calculated after setting the zoomScale
    if (aspectRatio >= 1.0) {
        xOffset = (self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.bounds)) / 2;
    } else {
        yOffset = (self.scrollView.contentSize.height - CGRectGetHeight(self.scrollView.bounds)) / 2;
    }
    
    self.scrollView.contentOffset = CGPointMake(xOffset, yOffset);
}

- (void)viewDidDisappear:(BOOL)animated;
{
    [super viewDidDisappear:animated];
    
    // do not keep a reference to the image after the view is hidden
    // as this is only needed to satisfy IPExposureFlowViewController
    self.croppedImage = nil;
}

#pragma mark IPExposureFlowViewController

- (CGRect)continueImageViewFrame;
{
    return [self.view convertRect:self.scrollView.bounds
                         fromView:self.scrollView];
}

- (UIImage *)continueImage;
{
    if (self.croppedImage) return self.croppedImage;
    
    return self.image;
}

- (void)continueWithImage:(UIImage *)image;
{
    IPOptimizationViewController *filterController = [[IPOptimizationViewController alloc] initWithImage:image];
    [self.navigationController pushViewController:filterController animated:YES];
}


#pragma mark Actions

- (IBAction)crop:(id)sender
{
    float zoomScale = 1.0 / self.scrollView.zoomScale;
	
    CGPoint offset = self.scrollView.contentOffset;
    CGSize size = self.scrollView.bounds.size;
	CGRect rect = CGRectMake(offset.x * zoomScale,
                             offset.y * zoomScale,
                             size.width * zoomScale,
                             size.height * zoomScale);
	CGImageRef cgImageRef = CGImageCreateWithImageInRect(self.image.CGImage, rect);
	
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0); // 0.0 uses the scale of the current mainScreen

    CGRect resampleRect = CGRectMake(0, 0, size.width, size.height);

	UIImage *cropped = [UIImage imageWithCGImage:cgImageRef];
    
	CGImageRelease(cgImageRef);
    
    [cropped drawInRect:resampleRect];
    cropped = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
    
    self.croppedImage = cropped;
    
    [self continueWithImage:cropped];
}


#pragma mark UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return self.imageView;
}

@end
