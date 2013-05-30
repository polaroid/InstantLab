//
//  UIView+NXKit.m
//
//  Created by Ullrich Schäfer on 28.04.09.
//  Copyright 2009 Impossible GmbH. All rights reserved.
//

#import "NSLayoutConstraint+NXKit.h"

#import "UIView+NXKit.h"


@implementation UIView (NXKit)
- (void)nx_resignFirstResponderOfAllSubviews;
{
	[self resignFirstResponder];
	for (UIView *subView in self.subviews) {
		[subView nx_resignFirstResponderOfAllSubviews];
	}
}

- (UIView *)nx_firstResponderFromSubviews;
{
	if ([self isFirstResponder])
		return self;
	for (UIView *subView in self.subviews) {
		UIView *childFirstResponder = [subView nx_firstResponderFromSubviews];
		if (childFirstResponder)
			return childFirstResponder;
	}
	return nil;
}

- (UIScrollView *)nx_enclosingScrollView;
{
	UIView *superView = self.superview;
	if (superView) {
		if ([superView isKindOfClass:[UIScrollView class]]) {
			return (UIScrollView *)superView;
		} else {
			return superView.nx_enclosingScrollView;
		}
	}
	return nil;
}

- (BOOL)nx_isInSuperViewOfKind:(Class)aClass
{
    UIView *superView = self.superview;
    if ([superView isKindOfClass:aClass]) {
        return YES;
    }
    return [superView nx_isInSuperViewOfKind:aClass];
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0

#pragma mark Auto Layout

- (void)nx_addVisualConstraint:(NSString *)visualConstraint
                         views:(NSDictionary *)views;
{
    [self nx_addVisualConstraint:visualConstraint metrics:nil views:views];
}

- (void)nx_addVisualConstraint:(NSString *)visualConstraint
                       metrics:(NSDictionary *)metrics
                         views:(NSDictionary *)views;
{
    [self addConstraints:[NSLayoutConstraint nx_constraintsWithVisualFormat:visualConstraint
                                                                    metrics:metrics
                                                                      views:views]];
}

- (void)nx_addVisualConstraints:(NSArray *)visualConstraints
                          views:(NSDictionary *)views;
{
    [self nx_addVisualConstraints:visualConstraints metrics:nil views:views];
}

- (void)nx_addVisualConstraints:(NSArray *)visualConstraints
                        metrics:(NSDictionary *)metrics
                          views:(NSDictionary *)views;
{
    [self addConstraints:[NSLayoutConstraint nx_constraintsWithVisualFormats:visualConstraints
                                                                     metrics:metrics
                                                                       views:views]];
}


- (void)nx_addConstraintToCenterViewHorizontally:(UIView *)view;
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1.0
                                                      constant:0.0]];
}

- (void)nx_addConstraintToCenterViewVertically:(UIView *)view;
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.0]];
}


- (void)nx_addConstraintForSameWidth:(UIView *)view;
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:0.0]];
}

- (void)nx_addConstraintForSameHeight:(UIView *)view;
{
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                      constant:0.0]];
}

#endif


#pragma mark Animation

+ (void)nx_animateWithDuration:(NSTimeInterval)duration
                    animations:(void (^)(void))animations
                 skipAnimation:(BOOL)skipAnimation;
{
    if (!skipAnimation) {
        [[self class] animateWithDuration:duration animations:animations];
    } else {
        animations();
    }
}

+ (void)nx_animateWithDuration:(NSTimeInterval)duration
                    animations:(void (^)(void))animations
                    completion:(void (^)(BOOL))completion
                 skipAnimation:(BOOL)skipAnimation;
{
    if (!skipAnimation) {
        [[self class] animateWithDuration:duration animations:animations completion:completion];
    } else {
        animations();
        completion(YES);
    }
}

+ (void)nx_animateWithDuration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
                       options:(UIViewAnimationOptions)options
                    animations:(void (^)(void))animations
                    completion:(void (^)(BOOL))completion
                 skipAnimation:(BOOL)skipAnimation;
{
    if (!skipAnimation) {
        [[self class] animateWithDuration:duration delay:delay options:options animations:animations completion:completion];
    } else {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * delay);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            animations();
            completion(YES);
        });
    }
}


@end
