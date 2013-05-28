//
//  NSLayoutConstraint+NXKit.h
//  NXExtensions
//
//  Created by Ullrich Schäfer on 05.04.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0 || __MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_7

@interface NSLayoutConstraint (NXKit)

+ (NSArray *)nx_constraintsWithVisualFormats:(NSArray *)visualFormats
                                       views:(NSDictionary *)views;

+ (NSArray *)nx_constraintsWithVisualFormats:(NSArray *)visualFormats
                                     metrics:(NSDictionary *)metrics
                                       views:(NSDictionary *)views;

+ (NSArray *)nx_constraintsWithVisualFormat:(NSString *)visualFormat
                                      views:(NSDictionary *)views;

+ (NSArray *)nx_constraintsWithVisualFormat:(NSString *)visualFormat
                                    metrics:(NSDictionary *)metrics
                                      views:(NSDictionary *)views;
@end

#endif
