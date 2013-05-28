//
//  IPAppereance.m
//  Impossible
//
//  Created by Ullrich Schäfer on 25.03.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import <WCAlertView/WCAlertView.h>

#import "UIColor+ImpossibleProject.h"
#import "UIFont+ImpossibleProject.h"
#import "IPButton.h"

#import "IPNavigationController.h"

#import "IPAppereance.h"

@implementation IPAppereance

+ (void)loadAppereance;
{
    [[UINavigationBar appearanceWhenContainedIn:[IPNavigationController class], nil] setBackgroundImage:[UIImage imageNamed:@"instantlab_bar-top"]
                                                                                          forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearanceWhenContainedIn:[IPNavigationController class], nil] setTitleTextAttributes:@{
                                                                                        UITextAttributeFont: [UIFont ip_boldFontOfSize:22.0],
                                                                                   UITextAttributeTextColor: [UIColor ip_textColor],
                                                                             UITextAttributeTextShadowColor: [UIColor clearColor]
     }];
    [[UINavigationBar appearanceWhenContainedIn:[IPNavigationController class], nil] setTintColor:[UIColor ip_backgroundColor]];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[IPNavigationController class], nil] setTitleTextAttributes:@{
                                                                                   UITextAttributeTextColor: [UIColor ip_textColor],
                                                                             UITextAttributeTextShadowColor: [UIColor clearColor]
     }
                                                                                                   forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[IPNavigationController class], nil] setTitleTextAttributes:@{
                                                                                   UITextAttributeTextColor: [UIColor ip_disabledTextColor],
                                                                             UITextAttributeTextShadowColor: [UIColor clearColor]
     }
                                                                                                   forState:UIControlStateDisabled];
    
    [[IPButton appearanceWhenContainedIn:[IPNavigationController class], nil] setTitleColor:[UIColor ip_textColor] forState:UIControlStateNormal];
    
    
    
    [[UISlider appearanceWhenContainedIn:[IPNavigationController class], nil] setThumbImage:[UIImage imageNamed:@"instantlab_screen4a_controls-knob"]
                                                                                   forState:UIControlStateNormal];
    [[UISlider appearanceWhenContainedIn:[IPNavigationController class], nil] setThumbImage:[UIImage imageNamed:@"instantlab_screen4a_controls-knob"]
                                                                                   forState:UIControlStateHighlighted];
    UIEdgeInsets trackImageEdgeInsets = UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0);
    [[UISlider appearanceWhenContainedIn:[IPNavigationController class], nil] setMinimumTrackImage:[[UIImage imageNamed:@"instantlab_screen4a_controls-black"] resizableImageWithCapInsets:trackImageEdgeInsets]
                                                                                          forState:UIControlStateNormal];
    [[UISlider appearanceWhenContainedIn:[IPNavigationController class], nil] setMaximumTrackImage:[[UIImage imageNamed:@"instantlab_screen4a_controls-white"] resizableImageWithCapInsets:trackImageEdgeInsets]
                                                                                          forState:UIControlStateNormal];
    
    [WCAlertView setDefaultCustomiaztonBlock:^(WCAlertView *alertView) {
        alertView.labelTextColor = [UIColor ip_textColor];
        alertView.labelShadowColor = [UIColor whiteColor];
        alertView.titleFont = [UIFont ip_boldFontOfSize:18];
        alertView.messageFont = [UIFont ip_fontOfSize:18];
        alertView.cornerRadius = 3;
        
        alertView.gradientColors = @[[UIColor ip_backgroundColor], [UIColor ip_backgroundColor], [UIColor ip_backgroundColor]];
        
        alertView.outerFrameColor = [UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
        
        alertView.buttonTextColor = [UIColor ip_textColor];
        alertView.buttonFont = [UIFont ip_boldFontOfSize:18];
        alertView.buttonShadowColor = [UIColor whiteColor];
    }];
}

@end
