//
//  UIColor_NXKit.m
//  NXKit
//
//  Created by Gernot Poetsch on 11.12.10.
//  Copyright 2010 nxtbgthng GmbH. All rights reserved.
//

#import "UIColor_NXKit.h"


@implementation UIColor (NXKit)

#pragma mark hex colors (hex color string)

+ (UIColor*)nx_colorWithHex:(NSString*)string;
{
    return [UIColor nx_colorWithHexString: string];
}

+ (UIColor*)nx_colorWithHexString:(NSString*)string;
{
	if (!(string.length==6 || string.length==7)) return nil;
	
	NSInteger offset = (string.length==7) ? 1 : 0;
	
	unsigned red = 0;
	unsigned green = 0;
	unsigned blue = 0;
	
	NSScanner *scanner = [NSScanner scannerWithString:[string substringWithRange:NSMakeRange(0+offset, 2)]];
	[scanner scanHexInt:&red];
	
	scanner = [NSScanner scannerWithString:[string substringWithRange:NSMakeRange(2+offset, 2)]];
	[scanner scanHexInt:&green];
	
	scanner = [NSScanner scannerWithString:[string substringWithRange:NSMakeRange(4+offset, 2)]];
	[scanner scanHexInt:&blue];
	
	return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
}

#pragma mark hex colors (actual hex numbers)

+ (UIColor*)nx_colorWithHexColor:(NSUInteger)color
{
    return [UIColor nx_colorWithHexColor:color alpha:1.0];
}

+ (UIColor*)nx_colorWithHexColor:(NSUInteger)color alpha:(CGFloat)alpha
{
	CGFloat red   = ((float)((color & 0xFF0000) >> 16))	/ 255.0;
	CGFloat green = ((float)((color & 0xFF00) >> 8))	/ 255.0;
	CGFloat blue  = ((float) (color & 0xFF))			/ 255.0;
	
	return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

#pragma mark int rgb colors (range: 0-255)

+ (UIColor*)nx_colorWithRedInt:(NSUInteger)red greenInt:(NSUInteger)green blueInt:(NSUInteger)blue
{
	return [UIColor nx_colorWithRedInt:red greenInt:green blueInt:blue alphaInt:255];
}

+ (UIColor*)nx_colorWithRedInt:(NSUInteger)red greenInt:(NSUInteger)green blueInt:(NSUInteger)blue alphaInt:(NSUInteger)alpha
{
	CGFloat floatRed   = red   / 255.0;
	CGFloat floatGreen = green / 255.0;
	CGFloat floatBlue  = blue  / 255.0;
	CGFloat floatAlpha = alpha / 255.0;
	
	return [UIColor colorWithRed:floatRed green:floatGreen blue:floatBlue alpha:floatAlpha];
}

@end
