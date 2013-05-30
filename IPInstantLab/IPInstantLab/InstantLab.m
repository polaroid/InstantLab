//
//  IPInstantLab.m
//  IPInstantLab
//
//  Created by Tobias Kräntzer on 28.05.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import "NXImage.h"

#import "IPConstants.h"

#import "IPImageCropperViewController.h"
#import "IPOptimizationViewController.h"

#import "IPNavigationController.h"
#import "IPAppereance.h"

#import "IPBarButtonItem.h"



#import "InstantLab.h"

@implementation IPInstantLab

+ (void)initialize;
{
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
                  IPInstaLabDebugExposureXAdjustDefaultsKey: @0,
                                  IPTourWasShownDefaultsKey: @NO,
                            IPFilmPickerWasShownDefaultsKey: @NO,
               IPInstaLabScannerSaveInfoWasShownDefaultsKey: @NO,
      IPInstaLabExposureInstructionVideoWasShownDefaultsKey: @NO}];
    
    // migrate to only storing the identifier
    NSDictionary *defaultsDict = [[NSUserDefaults standardUserDefaults] objectForKey:IPSelectedInstaLabFilmDefaultsKey];
    if ([defaultsDict isKindOfClass:[NSDictionary class]]) {
        [[NSUserDefaults standardUserDefaults] setObject:defaultsDict[IPSelectedInstaLabFilmIdentifierKey]
                                                  forKey:IPSelectedInstaLabFilmDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

+ (void)presentInstantLabWithImage:(UIImage *)anImage
{
    [self presentInstantLabWithImage:anImage skipCropping:NO];
}

+ (void)presentInstantLabWithImage:(UIImage *)anImage skipCropping:(BOOL)skipCropping;
{
    [IPAppereance loadAppereance];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIViewController *rootViewController = [window rootViewController];
    
    
    IPNavigationController *navigationController = nil;
    
    if (skipCropping) {
        IPOptimizationViewController *optimizationViewController = [[IPOptimizationViewController alloc] initWithImage:[anImage nx_imageByRotatingToStandard]];
        optimizationViewController.navigationItem.leftBarButtonItem = [IPBarButtonItem barButtonItemForPosition:IPBarButtonItemPositionLeft
                                                                                                 withImage:[UIImage imageNamed:@"instantlab_icon-close_inactive"]
                                                                                                   handler:^(id sender) {
                                                                                                       [rootViewController dismissViewControllerAnimated:YES completion:^{ }];
                                                                                                   }];
        navigationController = [[IPNavigationController alloc] initWithRootViewController:optimizationViewController];
    } else {
        IPImageCropperViewController *cropperViewController = [[IPImageCropperViewController alloc] initWithImage:[anImage nx_imageByRotatingToStandard]];
        cropperViewController.navigationItem.leftBarButtonItem = [IPBarButtonItem barButtonItemForPosition:IPBarButtonItemPositionLeft
                                                                                                 withImage:[UIImage imageNamed:@"instantlab_icon-close_inactive"]
                                                                                                   handler:^(id sender) {
                                                                                                       [rootViewController dismissViewControllerAnimated:YES completion:^{ }];
                                                                                                   }];
        navigationController = [[IPNavigationController alloc] initWithRootViewController:cropperViewController];
    }
    
    [rootViewController presentViewController:navigationController
                                     animated:YES
                                   completion:^{
                                       
                                   }];
}

@end
