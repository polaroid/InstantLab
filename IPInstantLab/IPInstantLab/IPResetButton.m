//
//  IPResetButton.m
//  IPInstantLab
//
//  Created by Max Winde on 29.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import "UIColor+ImpossibleProject.h"
#import "UIFont+ImpossibleProject.h"
#import "IPResetButton.h"

@implementation IPResetButton

- (id)initWithCoder:(NSCoder *)aDecoder;
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
        [self setTitleColor:[UIColor ip_textColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor ip_textColor] forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont ip_exposureOptimizeResetButtonFont];
        [self setBackgroundImage:[[UIImage imageNamed:@"instantlab_screen4b_button-reset"] resizableImageWithCapInsets:edgeInsets]
                        forState:UIControlStateNormal];
        [self setBackgroundImage:[[UIImage imageNamed:@"instantlab_screen4b_button-reset_active"] resizableImageWithCapInsets:edgeInsets]
                        forState:UIControlStateHighlighted];
    }
    
    return self;
}

@end
