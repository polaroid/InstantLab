//
//  NXImage.m
//  NXKit
//
//  Created by Ullrich Schäfer on 01.04.11.
//  Copyright 2011 nxtbgthng. All rights reserved.
//

#import "NXImage.h"

// private helpers
static inline CGFloat NXImageDegreesToRadians(CGFloat degrees)
{
    return M_PI * (degrees / 180.0);
}

static inline CGSize NXImageSwapWidthAndHeight(CGSize size)
{
    CGFloat  swap = size.width;
    
    size.width  = size.height;
    size.height = swap;
    
    return size;
}


@implementation NXImage (NXKit)

+ (NXImage *)nx_imageWithData:(NSData *)data;
{
#if TARGET_OS_IPHONE
	return [UIImage imageWithData:data];
#else
	return [[NSImage alloc] initWithData:data];
#endif
}

+ (NXImage *)nx_imageFromFileURL:(NSURL *)URL;
{
#if TARGET_OS_IPHONE
    return [UIImage imageWithContentsOfFile:URL.path];
#else
    return [[NSImage alloc] initWithContentsOfFile:URL.path];
#endif
}

- (NSData *)nx_pngRepresentation;
{
#if TARGET_OS_IPHONE
	return UIImagePNGRepresentation(self);
#else
	NSArray *imageRepresentations = [self representations];
	if (imageRepresentations.count < 1) {
		return nil;
	}
	NSBitmapImageRep *bits = [imageRepresentations objectAtIndex: 0];
	
	return[bits representationUsingType:NSPNGFileType properties:nil];
#endif
}

- (NSData *)nx_jpegRepresentation;
{
    return [self nx_jpegRepresentationWithQuality:1.0];
}

- (NSData *)nx_jpegRepresentationWithQuality:(float)quality;
{
#if TARGET_OS_IPHONE
	return UIImageJPEGRepresentation(self, quality);
#else
	NSArray *imageRepresentations = [self representations];
	if (imageRepresentations.count < 1) {
		return nil;
	}
	NSBitmapImageRep *bits = [imageRepresentations objectAtIndex: 0];
	
	return [bits representationUsingType:NSJPEGFileType
                              properties:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:quality]
                                                                     forKey:NSImageCompressionFactor]];
#endif
}

#if TARGET_OS_IPHONE
+ (NXImage *)nx_imageNamed:(NSString *)name leftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;
{
    if (name == nil) {
        return nil;
    }
	return [[NXImage imageNamed:name] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
}

+ (NXImage *)nx_imageAtPath:(NSString *)path scale:(CGFloat)scale;
{
    NSString *extension = [[path pathExtension] lowercaseString];
    
    if ([extension isEqualToString:@"jpg"] == NO &&
        [extension isEqualToString:@"png"] == NO) {
        NSAssert1(NO, @"Unsupported image format: %@", extension);
        return nil;
    }
    
    CFDataRef imageData = (CFDataRef)CFBridgingRetain([NSData dataWithContentsOfFile:path]);
    if (imageData == NULL) {
        return nil;
    }
    CGDataProviderRef imageDataProvider = CGDataProviderCreateWithCFData(imageData);
    CGImageRef imageRef = NULL;
    if ([extension isEqualToString:@"jpg"]) {
        imageRef = CGImageCreateWithJPEGDataProvider(imageDataProvider, NULL, true, kCGRenderingIntentDefault);
    } else if ([extension isEqualToString:@"png"]) {
        imageRef = CGImageCreateWithPNGDataProvider(imageDataProvider, NULL, true, kCGRenderingIntentDefault);
    }
    
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef
                                                scale:scale
                                          orientation:UIImageOrientationUp];
    
    CGImageRelease(imageRef);
    CGDataProviderRelease(imageDataProvider);
    CFRelease(imageData);
    
    return image;
}

+ (NXImage *)nx_imageWithColor:(UIColor *)color;
{
    CGSize size = CGSizeMake(1.0f, 1.0f);
	return [[self class] nx_imageWithColor:color size:size];
}

+ (NXImage *)nx_imageWithColor:(UIColor *)color size:(CGSize)size;
{
	CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
	
    NXImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return image;
}

- (NXImage *)nx_imageByResizingTo:(CGSize)newSize;
{
    return [self nx_imageByResizingTo:newSize maintainAspectRatio:NO];
}

- (NXImage *)nx_imageByResizingTo:(CGSize)newSize maintainAspectRatio:(BOOL)maintainRatio;
{
    if (maintainRatio) {
        CGFloat sourceWidth  = self.size.width;
        CGFloat sourceHeight = self.size.height;
        CGFloat targetWidth  = newSize.width;
        CGFloat targetHeight = newSize.height;

        CGFloat sourceRatio = sourceWidth / sourceHeight;
        CGFloat targetRatio = targetWidth / targetHeight;

        BOOL shouldScaleWidth = (sourceRatio <= targetRatio);

        CGFloat scalingFactor;
        if (shouldScaleWidth) {
            scalingFactor  = 1.0f / sourceRatio;
            newSize.height = roundf(scalingFactor * targetWidth);
            newSize.width  = targetWidth;
        } else {
            scalingFactor  = sourceRatio;
            newSize.height = targetHeight;
            newSize.width  = roundf(scalingFactor * targetHeight);
        }
    }

    UIGraphicsBeginImageContext(newSize);
    [self drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
	NXImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

- (NXImage *)nx_imageByResizingTo:(CGSize)newSize forRetinaDisplay:(BOOL)forRetinaDisplay;
{
    if (forRetinaDisplay && [[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(newSize, YES, 2.0);
        } else {
            UIGraphicsBeginImageContext(newSize);
        }
    } else {
        UIGraphicsBeginImageContext(newSize);
    }
    [self drawInRect:CGRectMake(0.0f, 0.0f, newSize.width, newSize.height)];
	NXImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return scaledImage;
}

- (NXImage *)nx_imageByRotatingToStandard;
{
    CGImageRef imgRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orientation = self.imageOrientation;
    switch(orientation) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight || orientation == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    NXImage *copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}

#endif

@end
