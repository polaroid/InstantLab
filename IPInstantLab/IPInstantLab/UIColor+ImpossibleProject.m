//
//  UIColor+ImpossibleProject.m
//  Impossible
//
//  Created by Max Winde on 12.04.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import "UIColor_NXKit.h"

#import "UIColor+ImpossibleProject.h"


@implementation UIColor (ImpossibleProject)

#pragma mark General

- (UIColor *)ip_colorWithAlpha:(CGFloat)alpha;
{
	const CGFloat *components = (CGFloat *)CGColorGetComponents([self CGColor]);
	const int numComponents = CGColorGetNumberOfComponents([self CGColor]);
    
	CGFloat newComponents[4];
    
	switch (numComponents) {
		case 2: // Greyscale
			newComponents[0] = components[0];
			newComponents[1] = components[0];
			newComponents[2] = components[0];
			newComponents[3] = alpha;
			break;
		case 4: // RGBA
			newComponents[0] = components[0];
			newComponents[1] = components[1];
			newComponents[2] = components[2];
			newComponents[3] = alpha;
			break;
	}
    
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGColorRef cgResult = CGColorCreate(colorSpace, newComponents);
	CGColorSpaceRelease(colorSpace);
    
	UIColor *result = [UIColor colorWithCGColor:cgResult];
	CGColorRelease(cgResult);
    
	return result;
}


#pragma mark Colors

+ (UIColor *)ip_backgroundColor;
{
    return [UIColor nx_colorWithHexColor:0xF3F2F0];
}

+ (UIColor *)ip_textColor;
{
    return [UIColor nx_colorWithHexColor:0x4D4D4D];
}

+ (UIColor *)ip_disabledTextColor;
{
    return [UIColor nx_colorWithHexColor:0x9D9D9D];
}

+ (UIColor *)ip_selectedTextColor;
{
    return [UIColor nx_colorWithHexColor:0xc53d08];
}

+ (UIColor *)ip_alertBackgroundColor;
{
    return [UIColor nx_colorWithHexColor:0xd0cfca];
}

+ (UIColor *)ip_shutterColor;
{
    return [UIColor nx_colorWithHexColor:0x333333];
}

+ (UIColor *)ip_menuBackgroundColor;
{
    return [UIColor nx_colorWithHexColor:0x333333];
}

+ (UIColor *)ip_menuForegroundColor;
{
    return [UIColor nx_colorWithHexColor:0xFFFFFF];
}

+ (UIColor *)ip_menuSeperatorColor1;
{
    return [UIColor colorWithRed:0.275 green:0.275 blue:0.275 alpha:1.0];
}

+ (UIColor *)ip_menuSeperatorColor2;
{
    return [UIColor colorWithRed:0.122 green:0.122 blue:0.122 alpha:1.0];
}

+ (UIColor *)ip_transparentBarColor;
{
    return [UIColor colorWithWhite:0.0 alpha:0.5];
}

+ (UIColor *)ip_opaqueBarColor;
{
    return [UIColor nx_colorWithHexColor:0xe3e3e3];
}

#pragma mark Gallery

+ (UIColor *)ip_galleryBackgroundColor;
{
    return [UIColor nx_colorWithHexColor:0xdcdad4];
}

+ (UIColor *)ip_galleryMenuButtonColor;
{
    return [UIColor ip_galleryBackgroundColor];
}

+ (UIColor *)ip_galleryMenuButtonSelectedColor;
{
    return [UIColor nx_colorWithHexColor:0xD8D7D4];
}

+ (UIColor *)ip_galleryMenuButtonHighlightedColor;
{
    return [UIColor nx_colorWithHexColor:0xAAA9A7];
}

+ (UIColor *)ip_galleryMenuButtonUploadColor;
{
    return [UIColor nx_colorWithHexColor:0xC53D1E];
}

+ (UIColor *)ip_galleryMenuButtonUploadHighlightedColor;
{
    return [UIColor nx_colorWithHexColor:0x8E2C16];
}


@end
