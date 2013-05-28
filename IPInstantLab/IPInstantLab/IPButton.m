//
//  IPButton.m
//  Impossible
//
//  Created by Max Winde on 16.04.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import "UIFont+ImpossibleProject.h"

#import "IPButton.h"


static const UIEdgeInsets edgeInsets = (UIEdgeInsets){4.0, 4.0, 4.0, 4.0};

@implementation IPButton

+ (IPButton *)button;
{
    return [[IPButton alloc] initWithFrame:CGRectZero];
}

+ (IPButton *)buttonWithRedColor;
{
    IPButton *button = [self button];
    [button setBackgroundImage:[[UIImage imageNamed:@"gallery_button_resize_inactive"] resizableImageWithCapInsets:edgeInsets
                                                                                                      resizingMode:UIImageResizingModeStretch]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[[UIImage imageNamed:@"gallery_button_resize_active"] resizableImageWithCapInsets:edgeInsets
                                                                                                    resizingMode:UIImageResizingModeStretch]
                      forState:UIControlStateHighlighted];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

- (id)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self setBackgroundImage:[[UIImage imageNamed:@"instantlab_button_resize_inactive"] resizableImageWithCapInsets:edgeInsets
                                                                                                           resizingMode:UIImageResizingModeStretch]
                        forState:UIControlStateNormal];
        [self setBackgroundImage:[[UIImage imageNamed:@"instantlab_button_resize_active"] resizableImageWithCapInsets:edgeInsets
                                                                                                         resizingMode:UIImageResizingModeStretch]
                        forState:UIControlStateHighlighted];
        [self setBackgroundImage:[[UIImage imageNamed:@"instantlab_button_resize_active"] resizableImageWithCapInsets:edgeInsets
                                                                                                         resizingMode:UIImageResizingModeStretch]
                        forState:UIControlStateHighlighted|UIControlStateSelected];
        [self setBackgroundImage:[[UIImage imageNamed:@"instantlab_button_resize_selected"] resizableImageWithCapInsets:edgeInsets
                                                                                                           resizingMode:UIImageResizingModeStretch]
                        forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont ip_boldFontOfSize:15.0];
        self.titleEdgeInsets = UIEdgeInsetsMake(3.0, 0.0, 0.0, 0.0);
        self.changeAlphaOnHighlight = YES;
    }
    
    return self;
}

- (void)setHighlighted:(BOOL)highlighted;
{
    [super setHighlighted:highlighted];

    if (!self.changeAlphaOnHighlight) return;
    
    CGFloat alpha = (highlighted ? 0.4 : 1.0);
    self.titleLabel.alpha = alpha;
    self.imageView.alpha = alpha;
}

- (void)setAttributedTitle:(NSAttributedString *)title forState:(UIControlState)state
{
    [super setAttributedTitle:title forState:state];
    
    if ([self titleForState:UIControlStateNormal] ||
        [self attributedTitleForState:UIControlStateNormal]) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 15.0);
    } else {
        self.imageEdgeInsets = UIEdgeInsetsZero;
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    if ([self titleForState:UIControlStateNormal] ||
        [self attributedTitleForState:UIControlStateNormal]) {
        self.imageEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 15.0);
    } else {
        self.imageEdgeInsets = UIEdgeInsetsZero;
    }
}

@end
