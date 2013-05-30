//
//  UIFont+ImpossibleProject.m
//  IPInstantLab
//
//  Created by Max Winde on 12.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import "UIFont+ImpossibleProject.h"


@implementation UIFont (ImpossibleProject)

+ (UIFont *)ip_fontOfSize:(CGFloat)size;
{
    return [UIFont fontWithName:@"GoodMobiPro-Book" size:size];
}

+ (UIFont *)ip_boldFontOfSize:(CGFloat)size;
{
    return [UIFont fontWithName:@"GoodMobiPro-Bold" size:size];
}

+ (UIFont *)ip_condensedFontOfSize:(CGFloat)size;
{
    return [UIFont fontWithName:@"GoodMobiPro-CondBook" size:size];
}

+ (UIFont *)ip_condensedBoldFontOfSize:(CGFloat)size;
{
    return [UIFont fontWithName:@"GoodMobiPro-CondBold" size:size];
}

+ (UIFont *)ip_georgiaFontOfSize:(CGFloat)size;
{
    return [UIFont fontWithName:@"Georgia" size:size];
}

+ (UIFont *)ip_georgiaBoldFontOfSize:(CGFloat)size;
{
    return [UIFont fontWithName:@"Georgia-Bold" size:size];
}


#pragma mark General

+ (UIFont *)ip_navigationTitleFont;
{
    return [self ip_condensedBoldFontOfSize:22];
}

+ (UIFont *)ip_buttonTitleFont;
{
    return [self ip_condensedBoldFontOfSize:15.0];
}


#pragma mark Exposure

+ (UIFont *)ip_exposureFilmTypeLabelFont;
{
    return [self ip_condensedFontOfSize:14];
}

+ (UIFont *)ip_exposureFilmTypeCellFont;
{
    return [self ip_condensedBoldFontOfSize:18];
}

+ (UIFont *)ip_exposureOptimizeResetButtonFont;
{
    return [self ip_condensedBoldFontOfSize:15];
}

#pragma mark Menu

+ (UIFont *)ip_menuBigFont;
{
    return [self ip_condensedBoldFontOfSize:20];
}

+ (UIFont *)ip_menuSmallFont;
{
    return [self ip_condensedFontOfSize:20];
}


#pragma mark Alerts

+ (UIFont *)ip_alertTitleFont;
{
    return [self ip_condensedBoldFontOfSize:18];
}

+ (UIFont *)ip_alertMessageFont;
{
    return [self ip_condensedFontOfSize:18];
}

+ (UIFont *)ip_alertInputFont;
{
    return [self ip_fontOfSize:20];
}

+ (UIFont *)ip_alertButtonFont;
{
    return  [self ip_condensedBoldFontOfSize:18];
}


#pragma mark Tour

+ (UIFont *)ip_tourTitleFont;
{
    return [self ip_boldFontOfSize:22];
}

+ (UIFont *)ip_tourTextFont;
{
    return [self ip_georgiaFontOfSize:20];
}


#pragma mark Gallery

+ (UIFont *)ip_galleryMetaUserFont;
{
    return [self ip_boldFontOfSize:17];
}

+ (UIFont *)ip_galleryMetaDateFont;
{
    return [self ip_fontOfSize:15];
}

+ (UIFont *)ip_galleryTitleFont;
{
    return [self ip_boldFontOfSize:15];
}

+ (UIFont *)ip_galleryFilmTypeFont;
{
    return [self ip_condensedFontOfSize:15];
}

+ (UIFont *)ip_galleryFollowButtonFont;
{
    return [self ip_condensedBoldFontOfSize:14];
}

+ (UIFont *)ip_galleryMenuButtonFont;
{
    return [self ip_condensedBoldFontOfSize:14];
}

+ (UIFont *)ip_galleryControlButtonFont;
{
    return [self ip_condensedBoldFontOfSize:13];
}

+ (UIFont *)ip_galleryCommentNicknameFont;
{
    return [self ip_boldFontOfSize:15];
}

+ (UIFont *)ip_galleryCommentTextFont;
{
    return [self ip_fontOfSize:12.5];
}

+ (UIFont *)ip_galleryCommentInputFont;
{
    return [self ip_fontOfSize:17.0];
}

+ (UIFont *)ip_galleryCommentInputButtonFont;
{
    return [self ip_condensedBoldFontOfSize:17.0];
}

+ (UIFont *)ip_galleryLikeAndCommentFont;
{
    return [self ip_fontOfSize:14];
}

+ (UIFont *)ip_galleryLikeAndCommentBoldFont;
{
    return [self ip_boldFontOfSize:14];
}

+ (UIFont *)ip_galleryUploadFont;
{
    return [self ip_boldFontOfSize:18];
}

+ (UIFont *)ip_galleryEmptyViewFont;
{
    return [self ip_fontOfSize:24];
}


#pragma mark Scanner

+ (UIFont *)ip_scannerFilmTypeLabelFont;
{
    return [self ip_condensedBoldFontOfSize:14.0];
}

+ (UIFont *)ip_scannerTitleInputFont;
{
    return [self ip_condensedBoldFontOfSize:14.0];
}

+ (UIFont *)ip_scannerFilmTypeCellFont;
{
    return [self ip_condensedBoldFontOfSize:18.0];
}


#pragma mark Login

+ (UIFont *)ip_loginTitleFont;
{
    return [self ip_georgiaFontOfSize:16];
}

+ (UIFont *)ip_loginInputFont;
{
    return [self ip_georgiaFontOfSize:16];
}

+ (UIFont *)ip_loginResetFont;
{
    return [self ip_condensedBoldFontOfSize:12];
}

@end
