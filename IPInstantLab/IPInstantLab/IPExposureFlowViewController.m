//
//  IPExposureFlowViewController.m
//  Impossible
//
//  Created by Thomas Kollbach on 09.04.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import "UIColor+ImpossibleProject.h"

#import "IPExposureFlowViewController.h"


@interface IPExposureFlowViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong, readwrite) UIImageView *continueWithImageView;

@end

@implementation IPExposureFlowViewController


#pragma mark Accessors

- (CGRect)continueImageViewFrame;
{
    return CGRectZero;
}

- (UIImage *)continueImage
{
    return nil;
}


#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor ip_opaqueBarColor];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    
    self.continueWithImageView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    
    // only do this if the callback is not due to a modal controller 
    if ([self.navigationController.visibleViewController isKindOfClass:[IPExposureFlowViewController class]] && !self.navigationController.isBeingDismissed) {
        
        UIImage *continueImage = self.continueImage;
        
        if (continueImage) {
            if (!self.continueWithImageView) {
                self.continueWithImageView = [[UIImageView alloc] initWithFrame:self.continueImageViewFrame];
            }
            self.continueWithImageView.frame = [self.view.window convertRect:self.continueWithImageView.frame
                                                                    fromView:self.view];
            self.continueWithImageView.clipsToBounds = YES;
            self.continueWithImageView.contentMode = UIViewContentModeScaleAspectFill;
            self.continueWithImageView.image = continueImage;
            if (self.continueWithImageView.superview != self.view.window) {
                [self.view.window addSubview:self.continueWithImageView];
            }
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated;
{
    [super viewDidDisappear:animated];
    
    [self.continueWithImageView removeFromSuperview];
    self.continueWithImageView = nil;
}

@end
