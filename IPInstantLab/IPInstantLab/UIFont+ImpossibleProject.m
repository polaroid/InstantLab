//
//  UIFont+ImpossibleProject.m
//  Impossible
//
//  Created by Max Winde on 12.04.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import "UIFont+ImpossibleProject.h"

@implementation UIFont (ImpossibleProject)

+ (UIFont *)ip_fontOfSize:(CGFloat)size;
{
    return [UIFont fontWithName:@"GoodMobiPro-CondBook" size:size];
}

+ (UIFont *)ip_boldFontOfSize:(CGFloat)size;
{
    return [UIFont fontWithName:@"GoodMobiPro-CondBold" size:size];
}

#pragma mark Menu

+ (UIFont *)ip_menuBigFont;
{
    return [self ip_boldFontOfSize:20];
}

+ (UIFont *)ip_menuSmallFont;
{
    return [self ip_fontOfSize:20];
}

@end
