//
//  IPGridView.m
//  Impossible
//
//  Created by Ullrich Schäfer on 12.03.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import "IPGridView.h"

@implementation IPGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    [[UIColor whiteColor] setStroke];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // vertical lines
    CGFloat x1 = CGRectGetMinX(bounds) + CGRectGetWidth(bounds) / 3;
    CGFloat x2 = CGRectGetMaxX(bounds) - CGRectGetWidth(bounds) / 3;
    CGFloat y1 = CGRectGetMinY(bounds);
    CGFloat y2 = CGRectGetMaxY(bounds);
    
    CGContextMoveToPoint(ctx, x1, y1);
    CGContextAddLineToPoint(ctx, x1, y2);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, x2, y1);
    CGContextAddLineToPoint(ctx, x2, y2);
    CGContextStrokePath(ctx);
    
    // horizontal lines
    
    x1 = CGRectGetMinX(bounds);
    x2 = CGRectGetMaxX(bounds);
    y1 = CGRectGetMinY(bounds) + CGRectGetHeight(bounds) / 3;
    y2 = CGRectGetMaxY(bounds) - CGRectGetHeight(bounds) / 3;
    
    CGContextMoveToPoint(ctx, x1, y1);
    CGContextAddLineToPoint(ctx, x2, y1);
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, x1, y2);
    CGContextAddLineToPoint(ctx, x2, y2);
    CGContextStrokePath(ctx);
}

@end
