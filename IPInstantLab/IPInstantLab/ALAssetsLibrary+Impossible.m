//
//  ALAssetsLibrary+Impossible.m
//  IPInstantLab
//
//  Created by Ullrich Schäfer on 30.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <ImageIO/ImageIO.h>

#import "ALAssetsLibrary+Impossible.h"
#import "UIImage+Impossible.h"


typedef void(^IPAssetsAlbumBlock)(ALAssetsGroup *album, NSError *error);
typedef void(^IPAssetsAssetBlock)(ALAsset *asset, NSError *error);


@implementation ALAssetsLibrary (Impossible)

- (void)ip_saveImage:(UIImage *)image
             toAlbum:(NSString *)albumName
 withCompletionBlock:(IPAssetsLibraryCompletion)completionBlock;
{
    NSMutableDictionary *metadata = [NSMutableDictionary dictionary];
    NSDictionary *exifData = image.ip_exifMetaData;
    if (exifData) {
        [metadata setObject:exifData
                     forKey:(NSString *)kCGImagePropertyExifDictionary];
    }
    [metadata setObject:[NSNumber numberWithInteger:image.ip_exifImageOrientation]
                 forKey:(NSString *)kCGImagePropertyOrientation];
    
    [self writeImageToSavedPhotosAlbum:image.CGImage
                              metadata:metadata
                       completionBlock:^(NSURL* assetURL, NSError* error) {
                           
                           if (error == nil) {
                               if (albumName) {
                                   [self ip_addAssetURL: assetURL
                                                toAlbum:albumName
                                    withCompletionBlock:completionBlock];
                               } else {
                                   if (completionBlock) completionBlock(nil);
                               }
                           } else {
                               if (completionBlock) completionBlock(error);
                               return;
                           }
                       }];
}

- (void)ip_addAssetURL:(NSURL *)assetURL
               toAlbum:(NSString *)albumName
   withCompletionBlock:(IPAssetsLibraryCompletion)completionBlock;
{
    [self ip_continueWithAlbumWithName:albumName
                                 block:^(ALAssetsGroup *album, NSError *error) {
                                     if (error == nil) {
                                         NSParameterAssert(album);
                                         [self ip_continueWithAssetWithURL:assetURL
                                                                     block:^(ALAsset *asset, NSError *error) {
                                                                         if (error == nil) {
                                                                             [album addAsset:asset];
                                                                         }
                                                                         if (completionBlock) completionBlock(error);
                                                                     }];
                                     } else {
                                         if (completionBlock) completionBlock(error);
                                     }
                                 }];
}


#pragma mark Helper

- (void)ip_continueWithAlbumWithName:(NSString *)albumName
                               block:(IPAssetsAlbumBlock)block;
{
    __block BOOL didFindAlbum = NO;
    [self enumerateGroupsWithTypes:ALAssetsGroupAlbum
                        usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                            // block is called with group == nil when enumeration is done (see header)
                            
                            NSString *groupName = [group valueForProperty:ALAssetsGroupPropertyName];

                            if ([albumName compare:groupName]==NSOrderedSame) {
                                *stop = YES;
                                // the callback is not respecting the stop flag, so lets keep track of it ourselfes
                                didFindAlbum = YES;
                                
                                if (block) block(group, nil);

                            } else if (group == nil && didFindAlbum == NO) {
                                // create a new album
                                [self addAssetsGroupAlbumWithName:albumName
                                                      resultBlock:^(ALAssetsGroup *group) {
                                                          if (block) block(group, nil);
                                                      } failureBlock:^(NSError *error) {
                                                          if (block) block(nil, error);
                                                      }];
                            }
                        }
                      failureBlock:^(NSError *error) {
                          if (block) block(nil, error);
                      }];
}

- (void)ip_continueWithAssetWithURL:(NSURL *)assetURL
                              block:(IPAssetsAssetBlock)block;
{
    [self assetForURL: assetURL
          resultBlock:^(ALAsset *asset) {
              if (block) block(asset, nil);
          }
         failureBlock:^(NSError *error) {
             if (block) block(nil, error);
         }];
}

@end
