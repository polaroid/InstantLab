//
//  IPConstants.h
//  Impossible
//
//  Created by Ullrich Schäfer on 11.03.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#ifndef Impossible_IPConstants_h
#define Impossible_IPConstants_h

// height = IPAspectRatio x width
extern const CGFloat IPAspectRatio;
extern const CGFloat IPFullPictureAspectRatio;

extern const CGFloat IPyOffset;
extern const CGFloat IPyOffsetTallScreen;


extern const NSTimeInterval IPPreExposeDelay;
extern const NSTimeInterval IPExposeDelay;

extern BOOL IPAppIsRunningOnTallScreen();

extern NSString * const IPTourWasShownDefaultsKey;
extern NSString * const IPFilmPickerWasShownDefaultsKey;
extern NSString * const IPSelectedInstaLabFilmDefaultsKey;
extern NSString * const IPInstaLabDebugCustomExposureTimeDefaultsKey;
extern NSString * const IPInstaLabDebugExposureXAdjustDefaultsKey;
extern NSString * const IPInstaLabScannerSaveInfoWasShownDefaultsKey;
extern NSString * const IPInstaLabExposureInstructionVideoWasShownDefaultsKey;

// InstaLab Film PList Keys
extern NSString * const IPSelectedInstaLabFilmLocalizedNameKey; // value should be NSString
extern NSString * const IPSelectedInstaLabFilmIdentifierKey; // value should be NSString
extern NSString * const IPSelectedInstaLabFilmExposureKey; // value should be NSNumber


#endif
