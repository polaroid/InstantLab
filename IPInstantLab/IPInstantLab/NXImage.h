//
//  NXImage.h
//  NXKit
//
//  Created by Ullrich Schäfer on 01.04.11.
//  Copyright 2011 nxtbgthng. All rights reserved.
//

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define NXImage UIImage
#else
#import <AppKit/AppKit.h>
#define NXImage NSImage
#endif


// Helper to unify UIImage & NSImage for use in NXKit

@interface NXImage (NXKit)

+ (NXImage *)nx_imageWithData:(NSData *)data;
+ (NXImage *)nx_imageFromFileURL:(NSURL *)URL;

- (NSData *)nx_pngRepresentation;
- (NSData *)nx_jpegRepresentation;
- (NSData *)nx_jpegRepresentationWithQuality:(float)quality;

#if TARGET_OS_IPHONE
+ (NXImage *)nx_imageNamed:(NSString *)name leftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;
+ (NXImage *)nx_imageAtPath:(NSString *)path scale:(CGFloat)scale;

+ (NXImage *)nx_imageWithColor:(UIColor *)color size:(CGSize)size;
+ (NXImage *)nx_imageWithColor:(UIColor *)color;

- (NXImage *)nx_imageByResizingTo:(CGSize)newSize;
- (NXImage *)nx_imageByResizingTo:(CGSize)newSize maintainAspectRatio:(BOOL)maintainRatio;
- (NXImage *)nx_imageByResizingTo:(CGSize)newSize forRetinaDisplay:(BOOL)forRetinaDisplay;

- (NXImage *)nx_imageByRotatingToStandard;

#endif


@end
