//
//  IPButton.h
//  Impossible
//
//  Created by Max Winde on 16.04.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IPButton : UIButton

+ (IPButton *)button;
+ (IPButton *)buttonWithRedColor;

@property (assign) BOOL changeAlphaOnHighlight;

@end
