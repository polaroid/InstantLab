//
//  IPInstantLab.m
//  IPInstantLab
//
//  Created by Tobias Kräntzer on 28.05.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import "NXImage.h"

#import "IPConstants.h"

#import "IPImageCropperViewController.h"
#import "IPNavigationController.h"
#import "IPAppereance.h"

#import "IPBarButtonItem.h"



#import "IPInstantLab.h"

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
    [IPAppereance loadAppereance];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIViewController *rootViewController = [window rootViewController];

    
    IPImageCropperViewController *cropperViewController = [[IPImageCropperViewController alloc] initWithImage:[anImage nx_imageByRotatingToStandard]];
    cropperViewController.navigationItem.leftBarButtonItem = [IPBarButtonItem barButtonItemForPosition:IPBarButtonItemPositionLeft
                                                                                             withImage:[UIImage imageNamed:@"instantlab_icon-close_inactive"]
                                                                                               handler:^(id sender) {
                                                                                                   [rootViewController dismissViewControllerAnimated:YES completion:^{ }];
                                                                                               }];
    
    [rootViewController presentViewController:[[IPNavigationController alloc] initWithRootViewController:cropperViewController]
                                     animated:YES
                                   completion:^{
                                       
                                   }];
}

@end
