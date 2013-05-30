//
//  IPExposureViewController.h
//  IPInstantLab
//
//  Created by Ullrich Schäfer on 15.03.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPExposureViewController : UIViewController

- (id)initWithImage:(UIImage *)image exposureTime:(NSTimeInterval)exposureTimeInterval filmIdentifier:(NSString *)filmIdentifier;

@end
