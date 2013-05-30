//
//  UIView+Constraints.m
//  IPInstantLab
//
//  Created by Max Winde on 18.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import "UIView+Constraints.h"

@implementation UIView (Constraints)

- (void)contraintFromWidth;
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:CGRectGetWidth(self.bounds)]];
}

- (void)contraintFromHeight;
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:nil
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                      constant:CGRectGetHeight(self.bounds)]];
}

@end
