//
//  IPExposureFlowViewController.h
//  IPInstantLab
//
//  Created by Thomas Kollbach on 09.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPExposureFlowViewController : UIViewController

@property (nonatomic, strong, readonly) UIImageView *continueWithImageView;

// subclasses need to override these methods for the overly image to work
@property (nonatomic, strong, readonly) UIImage *continueImage;
- (CGRect)continueImageViewFrame;

@end
