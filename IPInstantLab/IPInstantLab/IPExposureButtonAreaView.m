//
//  IPExposureButtonAreaView.m
//  Impossible
//
//  Created by Max Winde on 15.04.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import "UIColor_NXKit.h"
#import "NXLayoutConstraintHelpers.h"

#import "IPExposureButtonAreaView.h"

@implementation IPExposureButtonAreaView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor nx_colorWithHexColor:0xe3e3e3];
        
        self.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraintWhere:[self constraintItemAttribute:NSLayoutAttributeHeight]
                 shouldBeEqualTo:[NXConstraintItemAttribute constraintItemAttributeWithConstant:88.0]];
    }
    return self;
}

@end
