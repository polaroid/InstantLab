//
//  IPAppereance.m
//  IPInstantLab
//
//  Created by Ullrich Schäfer on 25.03.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <CoreText/CoreText.h>

#import <WCAlertView/WCAlertView.h>

#import "UIColor+ImpossibleProject.h"
#import "UIFont+ImpossibleProject.h"
#import "IPButton.h"

#import "IPNavigationController.h"

#import "IPAppereance.h"

@implementation IPAppereance

+ (void)loadAppereance;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self loadFontWithName:@"GoodMobiPro-CondBold" extension:@"ttf"];
        [self loadFontWithName:@"GoodMobiPro-CondBook" extension:@"ttf"];
        [self loadFontWithName:@"GoodMobiPro-Bold" extension:@"ttf"];
        [self loadFontWithName:@"GoodMobiPro-Book" extension:@"ttf"];
        
        
        [[UINavigationBar appearanceWhenContainedIn:[IPNavigationController class], nil] setBackgroundImage:[UIImage imageNamed:@"instantlab_bar-top"]
                                           forBarMetrics:UIBarMetricsDefault];
        [[UINavigationBar appearanceWhenContainedIn:[IPNavigationController class], nil] setTitleTextAttributes:@{
                                         UITextAttributeFont: [UIFont ip_navigationTitleFont],
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
            alertView.titleFont = [UIFont ip_alertTitleFont];
            alertView.messageFont = [UIFont ip_alertMessageFont];
            alertView.cornerRadius = 3;
            
            alertView.gradientColors = @[[UIColor ip_backgroundColor], [UIColor ip_backgroundColor], [UIColor ip_backgroundColor]];
            
            alertView.outerFrameColor = [UIColor colorWithRed:250.0f/255.0f green:250.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
            
            alertView.buttonTextColor = [UIColor ip_textColor];
            alertView.buttonFont = [UIFont ip_alertButtonFont];
            alertView.buttonShadowColor = [UIColor whiteColor];
        }];
    });
}

+ (void)loadFontWithName:(NSString *)name extension:(NSString *)extension
{
    NSData *inData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:extension]];
    CFErrorRef error;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)inData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    if (! CTFontManagerRegisterGraphicsFont(font, &error)) {
        CFStringRef errorDescription = CFErrorCopyDescription(error);
        NSLog(@"Failed to load font: %@", errorDescription);
        CFRelease(errorDescription);
    }
    CFRelease(font);
    CFRelease(provider);
}

@end
