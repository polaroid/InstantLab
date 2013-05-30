//
//  IPPhotoView.m
//  IPInstantLab
//
//  Created by Max Winde on 24.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import "UIView+NXKit.h"
#import <BlocksKit/BlocksKit.h>

#import "UIColor+ImpossibleProject.h"
#import "NXLayoutConstraintHelpers.h"
#import "IPConstants.h"
#import "IPPhotoFrameView.h"

@interface IPPhotoFrameView ()

@property (strong) UIView *topBar;
@property (strong) UIView *spacerView;
@property (strong) UIView *bottomBar;

@end


@implementation IPPhotoFrameView

#pragma mark Lifecycle

- (id)initWithStyle:(IPPhotoViewStyle)style;
{
    self = [super initWithFrame:CGRectZero];
    
    if (self) {
        _style = style;
        
        self.backgroundColor = [UIColor ip_opaqueBarColor];
        self.topBar = [[UIView alloc] initWithFrame:CGRectZero];
        self.spacerView = [[UIView alloc] initWithFrame:CGRectZero];
        self.bottomBar = [[UIView alloc] initWithFrame:CGRectZero];
        
        self.spacerView.backgroundColor = [UIColor clearColor];
        self.spacerView.opaque = NO;
        self.spacerView.userInteractionEnabled = NO;
        
        [@[self.topBar, self.spacerView, self.bottomBar] each:^(UIView *view) {
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self addSubview:view];
        }];
        [self updateBarStyles];
    }
    
    return self;
}


#pragma mark Accessors

- (void)setContentView:(UIView *)contentView;
{
    if (contentView == _contentView) return;
    
    [_contentView removeFromSuperview];
    
    _contentView = contentView;
    
    [self insertSubview:contentView atIndex:0];
    
    [self removeConstraints:self.constraints];
    
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self setNeedsUpdateConstraints];
}

- (void)setStyle:(IPPhotoViewStyle)style;
{
    if (_style == style) {
        return;
    }
    _style = style;
    
    [self updateBarStyles];
    [self setNeedsUpdateConstraints];
}


#pragma mark Layout

- (void)updateConstraints;
{
    [super updateConstraints];
    
    
    // clear all old constraints
    [self removeConstraints:self.constraints];
    
    
    { // spacer & bars
        [self nx_addConstraintToCenterViewHorizontally:self.spacerView];
        [self nx_addConstraintToCenterViewVertically:self.spacerView];
        
        [self nx_addConstraintForSameWidth:self.spacerView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.spacerView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.spacerView
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:IPAspectRatio
                                                          constant:0.0]];
        
        [self nx_addConstraintToCenterViewHorizontally:self.topBar];
        [self nx_addConstraintToCenterViewHorizontally:self.bottomBar];
        [self nx_addConstraintForSameWidth:self.topBar];
        [self nx_addConstraintForSameWidth:self.bottomBar];
        [self nx_addVisualConstraint:@"V:|[topBar][spacer][bottomBar]|"
                               views:(@{@"topBar": self.topBar,
                                      @"spacer": self.spacerView,
                                      @"bottomBar": self.bottomBar})];
    }
    
    { // content view
        [self nx_addConstraintToCenterViewHorizontally:self.contentView];
        [self nx_addConstraintToCenterViewVertically:self.contentView];
        
        [self nx_addConstraintForSameWidth:self.contentView];
    }
    
    // variable constraints
    if (self.style == IPPhotoViewStyleOpaqueBar) {
        // content view height is x times it width
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.contentView
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:IPAspectRatio
                                                          constant:0.0]];
    } else {
        // use full height
        [self nx_addConstraintForSameHeight:self.contentView];
    }
}


#pragma mark Helpers

- (void)updateBarStyles;
{
    [@[self.topBar, self.bottomBar] each:^(UIView *bar){
        switch (self.style) {
            case IPPhotoViewStyleNoBar:
                bar.hidden = YES;
                bar.opaque = NO;
                break;
            case IPPhotoViewStyleOpaqueBar:
                bar.backgroundColor = [UIColor ip_opaqueBarColor];
                bar.opaque = YES;
                bar.hidden = NO;
                break;
                
            case IPPhotoViewStyleTransparentBar:
                bar.backgroundColor = [UIColor ip_transparentBarColor];
                bar.hidden = NO;
                bar.opaque = NO;
                break;
        }
    }];
}

@end
