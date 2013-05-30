//
//  UIView+NXConstraintHelpers.h
//  NXKit
//
//  Created by Max Winde on 24.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXConstraintItemAttribute.h"

@interface UIView (NXConstraintHelpers)

- (NXConstraintItemAttribute *)constraintItemAttribute:(NSLayoutAttribute)attribute;
- (NXConstraintItemAttribute *)constraintItemAttribute:(NSLayoutAttribute)attribute
                                        withMultiplier:(CGFloat)multiplier;
- (NXConstraintItemAttribute *)constraintItemAttribute:(NSLayoutAttribute)attribute
                                          withConstant:(CGFloat)constant;
- (NXConstraintItemAttribute *)constraintItemAttribute:(NSLayoutAttribute)attribute
                                        withMultiplier:(CGFloat)multiplier
                                              constant:(CGFloat)constant;

- (void)addConstraintWhere:(NXConstraintItemAttribute *)constraint1 shouldBeEqualTo:(NXConstraintItemAttribute *)constraint2;
- (void)addConstraintWhere:(NXConstraintItemAttribute *)constraint1 shouldBeLessOrEqualThen:(NXConstraintItemAttribute *)constraint2;
- (void)addConstraintWhere:(NXConstraintItemAttribute *)constraint1 shouldBeGreaterOrEqualThen:(NXConstraintItemAttribute *)constraint2;
- (void)addConstraintWhere:(NXConstraintItemAttribute *)constraint1
           shouldBeRelatedBy:(NSLayoutRelation)relation
                        to:(NXConstraintItemAttribute *)constraint2;
@end
