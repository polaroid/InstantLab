//
//  IPInstantLab.h
//  IPInstantLab
//
//  Created by Tobias Kräntzer on 28.05.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IPInstantLab : NSObject

+ (void)presentInstantLabWithImage:(UIImage *)anImage;
+ (void)presentInstantLabWithImage:(UIImage *)anImage skipCropping:(BOOL)skipCropping;

@end
