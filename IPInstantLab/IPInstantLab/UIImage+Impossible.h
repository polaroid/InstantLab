//
//  UIImage+Impossible.h
//  IPInstantLab
//
//  Created by Ullrich Schäfer on 15.05.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Impossible)

// for carrying the metaData
// set manually or loaded from file system via ip_imageFromPathWithLoadingExifMetaData
@property (strong, nonatomic) NSDictionary *ip_exifMetaData;

+ (UIImage *)ip_imageFromURLWithLoadingExifMetaData:(NSURL *)imageURL;

- (NSData *)ip_jpegRepresentationWithExifMetadata:(NSDictionary *)exifMetaData;

- (NSInteger)ip_exifImageOrientation;

@end
