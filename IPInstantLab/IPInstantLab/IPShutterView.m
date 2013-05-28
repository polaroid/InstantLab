//
//  IPShutterView.m
//  Impossible
//
//  Created by Ullrich Schäfer on 24.04.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UIColor+ImpossibleProject.h"

#import "IPShutterView.h"

@interface IPShutterView ()
@property (readwrite, getter=isAnimating) BOOL animating;
@property (readwrite, getter=isShut)  BOOL shut;
@property (readonly) CAShapeLayer *maskLayer;
@end

@implementation IPShutterView

#pragma mark Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor ip_shutterColor];
        
        // Set up the shape of the circle
        _maskLayer = [CAShapeLayer layer];
        // Make a circular shape
        CGPathRef maskPath = [self createCGPathWithRect:self.bounds radiusFactor:1];
        _maskLayer.path = maskPath;
        CGPathRelease(maskPath);
        
        _maskLayer.fillColor = [UIColor blackColor].CGColor;
        
        self.layer.mask = self.maskLayer;
    }
    return self;
}


#pragma mark Public

- (void)closeShutterWithCompletionBlock:(IPShutterCompletionBlock)finishBlock;    // 0.05s
{
    self.animating = YES;
    self.shut = YES;
    
    [self animateOpen:NO duration:0.05 finishBlock:^{
        self.animating = NO;
        if (finishBlock) {
            finishBlock();
        }
    }];
}

- (void)openShutterWithCompletionBlock:(IPShutterCompletionBlock)finishBlock; // 0.2s
{
    self.animating = YES;
    
    [self animateOpen:YES duration:0.2 finishBlock:^{
        self.animating = NO;
        self.shut = NO;
        if (finishBlock) {
            finishBlock();
        }
    }];
}


#pragma mark Helper

// @param radiusFactor: 1 - fully opened, 0 - fully closed
- (CGPathRef)createCGPathWithRect:(CGRect)rect radiusFactor:(CGFloat)radiusFactor;
{
    CGFloat radius = CGRectGetHeight(rect) * radiusFactor * M_SQRT1_2;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint: CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect))];
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect))];
    
    [bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(rect), CGRectGetMidY(rect))];
    [bezierPath addArcWithCenter:CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect))
                          radius:radius startAngle:0 endAngle:2 * M_PI clockwise:NO];
    [bezierPath closePath];
    
    CGPathRef path = bezierPath.CGPath;
    return CGPathRetain(path);
}

- (void)animateOpen:(BOOL)openOrClose duration:(NSTimeInterval)duration finishBlock:(IPShutterCompletionBlock)finishBlock;
{
    CAShapeLayer *maskLayer = self.maskLayer;
    // Configure animation
    [CATransaction lock];
    [CATransaction begin];
    CGPathRef startPath = [self createCGPathWithRect:self.bounds radiusFactor:openOrClose ? 0:1];
    CGPathRef endPath   = [self createCGPathWithRect:self.bounds radiusFactor:openOrClose ? 1:0];
    
    [CATransaction setCompletionBlock:^{
        maskLayer.path = endPath;
        CGPathRelease(endPath);
        if (finishBlock) {
            finishBlock();
        }
    }];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = duration;
    animation.fromValue = (__bridge id)startPath;
    animation.toValue = (__bridge id)endPath;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    
    [self.maskLayer addAnimation:animation forKey:@"animatePath"];
    [CATransaction commit];
    [CATransaction unlock];
}

@end
