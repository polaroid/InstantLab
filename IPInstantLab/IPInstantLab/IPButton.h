//
//  IPButton.h
//  IPInstantLab
//
//  Created by Max Winde on 16.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPButton : UIButton

+ (IPButton *)button;
+ (IPButton *)buttonWithGrayColor;
+ (IPButton *)buttonWithRedColor;

@property (assign) BOOL changeAlphaOnHighlight;

@end
