//
//  UIView+NXKit.h
//
//  Created by Ullrich Schäfer on 28.04.09.
//  Copyright 2009 nxtbgthng GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIView (NXKit)
- (void)nx_resignFirstResponderOfAllSubviews;
- (UIView *)nx_firstResponderFromSubviews;

- (UIScrollView *)nx_enclosingScrollView;

- (BOOL)nx_isInSuperViewOfKind:(Class)aClass;

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0

#pragma mark Auto Layout

- (void)nx_addVisualConstraint:(NSString *)visualConstraint
                         views:(NSDictionary *)views;

- (void)nx_addVisualConstraint:(NSString *)visualConstraint
                       metrics:(NSDictionary *)metrics
                         views:(NSDictionary *)views;

- (void)nx_addVisualConstraints:(NSArray *)visualConstraints
                          views:(NSDictionary *)views;

- (void)nx_addVisualConstraints:(NSArray *)visualConstraints
                        metrics:(NSDictionary *)metrics
                          views:(NSDictionary *)views;

- (void)nx_addConstraintToCenterViewHorizontally:(UIView *)view;
- (void)nx_addConstraintToCenterViewVertically:(UIView *)view;
- (void)nx_addConstraintForSameWidth:(UIView *)view;
- (void)nx_addConstraintForSameHeight:(UIView *)view;

#endif

#pragma mark Animations

+ (void)nx_animateWithDuration:(NSTimeInterval)duration
                    animations:(void (^)(void))animations
                 skipAnimation:(BOOL)skipAnimation;

+ (void)nx_animateWithDuration:(NSTimeInterval)duration
                    animations:(void (^)(void))animations
                    completion:(void (^)(BOOL))completion
                 skipAnimation:(BOOL)skipAnimation;

+ (void)nx_animateWithDuration:(NSTimeInterval)duration
                         delay:(NSTimeInterval)delay
                       options:(UIViewAnimationOptions)options
                    animations:(void (^)(void))animations
                    completion:(void (^)(BOOL))completion
                 skipAnimation:(BOOL)skipAnimation;

@end
