//
//  ALAssetsLibrary+Impossible.h
//  IPInstantLab
//
//  Created by Ullrich Schäfer on 30.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <AssetsLibrary/AssetsLibrary.h>


typedef void(^IPAssetsLibraryCompletion)(NSError *error);

@interface ALAssetsLibrary (Impossible)

- (void)ip_saveImage:(UIImage*)image
             toAlbum:(NSString*)albumName
 withCompletionBlock:(IPAssetsLibraryCompletion)completionBlock;

- (void)ip_addAssetURL:(NSURL*)assetURL
               toAlbum:(NSString*)albumName
   withCompletionBlock:(IPAssetsLibraryCompletion)completionBlock;

@end
