//
//  UIImage+Impossible.m
//  IPInstantLab
//
//  Created by Ullrich Schäfer on 15.05.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import <ImageIO/ImageIO.h>
#import <ObjcAssociatedObjectHelpers/ObjcAssociatedObjectHelpers.h>

#import "UIImage+Impossible.h"

@implementation UIImage (Impossible)

SYNTHESIZE_ASC_OBJ(ip_exifMetaData, setIp_exifMetaData)

+ (UIImage *)ip_imageFromURLWithLoadingExifMetaData:(NSURL *)imageURL;
{
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL((__bridge CFURLRef)(imageURL), NULL);
    
    NSString *imageType = (__bridge NSString *)CGImageSourceGetType(imageSource);
    
    if ([imageType isEqualToString:(__bridge NSString *)kUTTypeJPEG] == NO) {
        NSLog(@"Image type (%@) does not support EXIF", imageType);
    }
    
    CFDictionaryRef cfMetadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
    
    CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
    
    UIImage *result = [UIImage imageWithCGImage:cgImage];
    result.ip_exifMetaData = [CFBridgingRelease(cfMetadata) objectForKey:(NSString *)kCGImagePropertyExifDictionary];
    
    CFRelease(imageSource);
    CGImageRelease(cgImage);
    
    return result;
}

- (NSData *)ip_jpegRepresentationWithExifMetadata:(NSDictionary *)exifMetaData;
{
    NSMutableData *imageData = nil;
    @autoreleasepool {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)(UIImageJPEGRepresentation(self, 1)), NULL);
        
        CFDictionaryRef cfMetadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        NSMutableDictionary *metadata = [(NSDictionary *)CFBridgingRelease(cfMetadata) mutableCopy];
        NSMutableDictionary *exifData = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
        
        metadata = metadata ?: [NSMutableDictionary dictionary];
        exifData = exifData ?: [NSMutableDictionary dictionary];
        
        [exifData setValuesForKeysWithDictionary:exifMetaData];
        [metadata setObject:exifData forKey:(NSString *)kCGImagePropertyExifDictionary];
        
        imageData = [NSMutableData data];
        CGDataConsumerRef imageDataConsumer = CGDataConsumerCreateWithCFData((__bridge CFMutableDataRef)imageData);
        CGImageDestinationRef destination = CGImageDestinationCreateWithDataConsumer(imageDataConsumer, kUTTypeJPEG, 1, NULL);
        
        CGImageDestinationAddImageFromSource(destination, imageSource, 0,  (__bridge CFDictionaryRef)metadata); // some sources tell to pass the meta data here....
//        CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)metadata);
        
        BOOL success = CGImageDestinationFinalize(destination);
        if (!success) {
            NSLog(@"Could not finalize image");
        }
    }
    return imageData;
}

- (NSInteger)ip_exifImageOrientation;
{
    switch (self.imageOrientation) {
        case UIImageOrientationUp:
            return 1;
        case UIImageOrientationUpMirrored:
            return 2;
        case UIImageOrientationDown:
            return 3;
        case UIImageOrientationDownMirrored:
            return 4;
        case UIImageOrientationLeftMirrored:
            return 5;
        case UIImageOrientationRight:
            return 6;
        case UIImageOrientationRightMirrored:
            return 7;
        case UIImageOrientationLeft:
            return 8;
        default:
            break;
    }
}

@end
