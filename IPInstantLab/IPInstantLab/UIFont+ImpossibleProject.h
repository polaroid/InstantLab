//
//  UIFont+ImpossibleProject.h
//  IPInstantLab
//
//  Created by Max Winde on 12.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (ImpossibleProject)

#pragma mark General

+ (UIFont *)ip_navigationTitleFont;
+ (UIFont *)ip_buttonTitleFont;


#pragma mark Exposure

+ (UIFont *)ip_exposureFilmTypeLabelFont;
+ (UIFont *)ip_exposureFilmTypeCellFont;
+ (UIFont *)ip_exposureOptimizeResetButtonFont;

#pragma mark Menu

+ (UIFont *)ip_menuBigFont;
+ (UIFont *)ip_menuSmallFont;

#pragma mark UIAlertView

+ (UIFont *)ip_alertTitleFont;
+ (UIFont *)ip_alertMessageFont;
+ (UIFont *)ip_alertInputFont;
+ (UIFont *)ip_alertButtonFont;

#pragma mark Tour

+ (UIFont *)ip_tourTitleFont;
+ (UIFont *)ip_tourTextFont;


#pragma mark Gallery

+ (UIFont *)ip_galleryMetaUserFont;
+ (UIFont *)ip_galleryMetaDateFont;
+ (UIFont *)ip_galleryTitleFont;
+ (UIFont *)ip_galleryFilmTypeFont;
+ (UIFont *)ip_galleryFollowButtonFont;
+ (UIFont *)ip_galleryMenuButtonFont;
+ (UIFont *)ip_galleryControlButtonFont;
+ (UIFont *)ip_galleryCommentNicknameFont;
+ (UIFont *)ip_galleryCommentTextFont;
+ (UIFont *)ip_galleryCommentInputFont;
+ (UIFont *)ip_galleryCommentInputButtonFont;
+ (UIFont *)ip_galleryLikeAndCommentFont;
+ (UIFont *)ip_galleryLikeAndCommentBoldFont;
+ (UIFont *)ip_galleryUploadFont;
+ (UIFont *)ip_galleryEmptyViewFont;


#pragma mark Scanner

+ (UIFont *)ip_scannerFilmTypeLabelFont;
+ (UIFont *)ip_scannerTitleInputFont;
+ (UIFont *)ip_scannerFilmTypeCellFont;


#pragma mark Login

+ (UIFont *)ip_loginTitleFont;
+ (UIFont *)ip_loginInputFont;
+ (UIFont *)ip_loginResetFont;

@end
