//
//  IPNavbarButton.m
//  Impossible
//
//  Created by Max Winde on 16.04.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import "IPButton.h"
#import "IPBarButtonItem.h"

@interface IPBarButtonItem ()

@property (weak, readwrite) UIButton *button;

@end


@implementation IPBarButtonItem

- (id)initForPosition:(IPBarButtonItemPosition)position withImage:(UIImage *)image;
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 44.0, 44.0)];
    IPButton *button = [IPButton button];
    [button setBackgroundImage:nil forState:UIControlStateNormal];
    if (position == IPBarButtonItemPositionLeft) {
        [button setBackgroundImage:[UIImage imageNamed:@"instantlab_bar-top-left_active"]
                          forState:UIControlStateHighlighted];
    } else {
        [button setBackgroundImage:[UIImage imageNamed:@"instantlab_bar-top-right_active"]
                          forState:UIControlStateHighlighted];
    }
    
    CGRect frame = backgroundView.bounds;
    frame.origin.x -= 8.0;
    frame.size.width = 44.0 + 8.0 * 2.0;
    button.frame = frame;
    [button setImage:image forState:UIControlStateNormal];
    [backgroundView addSubview:button];

    self = [super initWithCustomView:backgroundView];
    
    if (self) {
        self.button = button;
    }
    
    return self;
}

+ (IPBarButtonItem *)barButtonItemForPosition:(IPBarButtonItemPosition)position
                                    withImage:(UIImage *)image
                                       target:(id)target
                                     selector:(SEL)action;
{
    IPBarButtonItem *barButtonItem = [[IPBarButtonItem alloc] initForPosition:position withImage:image];
    [barButtonItem.button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return barButtonItem;
}

+ (IPBarButtonItem *)barButtonItemForPosition:(IPBarButtonItemPosition)position
                                    withImage:(UIImage *)image
                                      handler:(BKSenderBlock)handler;
{
    IPBarButtonItem *barButtonItem = [[IPBarButtonItem alloc] initForPosition:position withImage:image];
    [barButtonItem.button addEventHandler:handler forControlEvents:UIControlEventTouchUpInside];
    return barButtonItem;
}

@end
