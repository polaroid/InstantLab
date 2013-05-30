//
//  IPImageCropperViewController.h
//  IPInstantLab
//
//  Created by Ullrich Schäfer on 12.03.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import "IPExposureFlowViewController.h"


@class IPPhotoFrameView, IPGridView;

@interface IPImageCropperViewController : IPExposureFlowViewController

@property (strong) UIScrollView *scrollView;
@property (strong) IPPhotoFrameView *photoFrameView;
@property (strong) IPGridView *gridView;
@property (strong) UIImageView *imageView;

- (id)initWithImage:(UIImage *)image;

- (void)continueWithImage:(UIImage *)image;

@end
