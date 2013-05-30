//
//  IPConstants.m
//  IPInstantLab
//
//  Created by Ullrich Schäfer on 11.03.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

const CGFloat IPAspectRatio = 1.0259f;
const CGFloat IPFullPictureAspectRatio = 10.8 / 8.9;

const CGFloat IPyOffset = 98.0f;
const CGFloat IPyOffsetTallScreen = 172.0f;

const NSTimeInterval IPPreExposeDelay = 2.0;
const NSTimeInterval IPExposeDelay = 3.0;

NSString * const IPTourWasShownDefaultsKey = @"IPTourWasShownDefaultsKey";
NSString * const IPFilmPickerWasShownDefaultsKey = @"IPFilmPickerWasShownDefaultsKey";
NSString * const IPSelectedInstaLabFilmDefaultsKey = @"IPSelectedInstaLabFilm";
NSString * const IPInstaLabDebugCustomExposureTimeDefaultsKey = @"IPInstaLabDebugCustomExposureTime";
NSString * const IPInstaLabDebugExposureXAdjustDefaultsKey = @"IPInstaLabDebugExposureXAdjust";
NSString * const IPInstaLabScannerSaveInfoWasShownDefaultsKey = @"IPInstaLabScannerSaveInfoWasShownDefaultsKey";
NSString * const IPInstaLabExposureInstructionVideoWasShownDefaultsKey = @"IPInstaLabExposureInstructionVideoWasShownDefaultsKey";
NSString * const IPInstaLabTowerExtensionPopupWasShownDefaultsKey = @"IPInstaLabTowerExtensionPopupWasShownDefaultsKey";
NSString * const IPTermsOfServicePopupWasShownDefaultsKey = @"IPTermsOfServicePopupWasShownDefaultsKey";

NSString * const IPSelectedInstaLabFilmLocalizedNameKey = @"localizedName"; // value should be NSString
NSString * const IPSelectedInstaLabFilmIdentifierKey = @"identifier"; // value should be NSString
NSString * const IPSelectedInstaLabFilmExposureKey = @"exposureTimeInSeconds"; // value should be NSNumber

NSString * const IPAlbumName_InstantLab = @"Instant Lab Sources";
NSString * const IPAlbumName_Scans = @"Impossible Scans";

BOOL IPAppIsRunningOnTallScreen() {
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
    [UIScreen mainScreen].bounds.size.height >= 568.0f;
}
