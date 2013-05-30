//
//  UIColor+ImpossibleProject.h
//  IPInstantLab
//
//  Created by Max Winde on 12.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (ImpossibleProject)

#pragma mark General

- (UIColor *)ip_colorWithAlpha:(CGFloat)alpha;

#pragma mark Colors

+ (UIColor *)ip_backgroundColor;
+ (UIColor *)ip_textColor;
+ (UIColor *)ip_disabledTextColor;
+ (UIColor *)ip_selectedTextColor;
+ (UIColor *)ip_placeholderTextColor;

+ (UIColor *)ip_alertBackgroundColor;

+ (UIColor *)ip_shutterColor;

+ (UIColor *)ip_menuBackgroundColor;
+ (UIColor *)ip_menuForegroundColor;
+ (UIColor *)ip_menuSeperatorColor1;
+ (UIColor *)ip_menuSeperatorColor2;

+ (UIColor *)ip_transparentBarColor;
+ (UIColor *)ip_opaqueBarColor;


#pragma mark Gallery

+ (UIColor *)ip_galleryBackgroundColor;
+ (UIColor *)ip_galleryMenuButtonColor;
+ (UIColor *)ip_galleryMenuButtonSelectedColor;
+ (UIColor *)ip_galleryMenuButtonHighlightedColor;
+ (UIColor *)ip_galleryMenuButtonUploadColor;
+ (UIColor *)ip_galleryMenuButtonUploadHighlightedColor;

@end
