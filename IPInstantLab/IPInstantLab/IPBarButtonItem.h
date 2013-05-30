//
//  IPNavbarButton.h
//  IPInstantLab
//
//  Created by Max Winde on 16.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BlocksKit/BlocksKit.h>

typedef enum {
    IPBarButtonItemPositionLeft,
    IPBarButtonItemPositionRight
} IPBarButtonItemPosition;


@interface IPBarButtonItem : UIBarButtonItem

@property (weak, readonly) UIButton *button;

- (id)initForPosition:(IPBarButtonItemPosition)position withImage:(UIImage *)image;

+ (IPBarButtonItem *)barButtonItemForPosition:(IPBarButtonItemPosition)position
                                    withImage:(UIImage *)image
                                       target:(id)target
                                     selector:(SEL)action;
+ (IPBarButtonItem *)barButtonItemForPosition:(IPBarButtonItemPosition)position
                                    withImage:(UIImage *)image
                                      handler:(BKSenderBlock)handler;

@end
