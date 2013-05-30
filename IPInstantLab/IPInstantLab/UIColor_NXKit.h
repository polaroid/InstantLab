//
//  UIColor_NXKit.h
//  NXKit
//
//  Created by Gernot Poetsch on 11.12.10.
//  Copyright 2010 Impossible GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIColor (NXKit)

// hex colors (hex color string)

+ (UIColor *)nx_colorWithHex:(NSString *)string __attribute__((deprecated("use nx_colorWithHexString: instead!")));
+ (UIColor *)nx_colorWithHexString:(NSString *)string; //accepts #ffffff or ffffff

// hex colors (actual hex numbers)

+ (UIColor *)nx_colorWithHexColor:(NSUInteger)color; // call with real hex value 0xFFFFFF
+ (UIColor *)nx_colorWithHexColor:(NSUInteger)color alpha:(CGFloat)alpha;

// int rgb colors (range: 0-255)

+ (UIColor *)nx_colorWithRedInt:(NSUInteger)red greenInt:(NSUInteger)green blueInt:(NSUInteger)blue;
+ (UIColor *)nx_colorWithRedInt:(NSUInteger)red greenInt:(NSUInteger)green blueInt:(NSUInteger)blue alphaInt:(NSUInteger)alpha;


@end
