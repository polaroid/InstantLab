//
//  UIFont+ImpossibleProject.h
//  Impossible
//
//  Created by Max Winde on 12.04.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (ImpossibleProject)

+ (UIFont *)ip_fontOfSize:(CGFloat)size;
+ (UIFont *)ip_boldFontOfSize:(CGFloat)size;

#pragma mark Menu

+ (UIFont *)ip_menuBigFont;
+ (UIFont *)ip_menuSmallFont;

@end
