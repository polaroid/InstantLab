//
//  UIView+ImpossibleProject.m
//  IPInstantLab
//
//  Created by Max Winde on 15.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <BlocksKit/BlocksKit.h>

#import "IPConstants.h"
#import "UIFont+ImpossibleProject.h"

#import "UIView+ImpossibleProject.h"

@interface UIFont (private)
+ (UIFont *)ip_condensedBoldFontOfSize:(CGFloat)size;
@end

@implementation UIView (ImpossibleProject)

- (void)ip_fixLabelFonts;
{
    [[self subviewsOfClass:[UILabel class]] each:^(UILabel *label) {
        if ([label.font isEqual:[UIFont systemFontOfSize:label.font.pointSize]]) {
            label.font = [UIFont ip_condensedBoldFontOfSize:label.font.pointSize];
        }
    }];
}

- (NSArray *)subviewsOfClass:(Class)aClass;
{
    NSMutableArray *views = [[NSMutableArray alloc] init];
    
    [self.subviews each:^(UIView *view) {
        if ([view isKindOfClass:aClass]) {
            [views addObject:view];
        }
        
        [views addObjectsFromArray:[view subviewsOfClass:aClass]];
    }];
    
    return (views.count == 0 ? nil : views);
}

@end

