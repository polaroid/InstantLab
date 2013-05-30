//
//  UIView+NXConstraintHelpers.m
//  NXKit
//
//  Created by Max Winde on 24.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import "NSLayoutConstraint+NXConstraintHelpers.h"
#import "UIView+NXConstraintHelpers.h"

@implementation UIView (NXConstraintHelpers)

- (NXConstraintItemAttribute *)constraintItemAttribute:(NSLayoutAttribute)attribute;
{
    return [self constraintItemAttribute:attribute withMultiplier:1.0 constant:0.0];
}

- (NXConstraintItemAttribute *)constraintItemAttribute:(NSLayoutAttribute)attribute withMultiplier:(CGFloat)multiplier;
{
    return [self constraintItemAttribute:attribute withMultiplier:multiplier constant:0.0];
}

- (NXConstraintItemAttribute *)constraintItemAttribute:(NSLayoutAttribute)attribute withConstant:(CGFloat)constant;
{
    return [self constraintItemAttribute:attribute withMultiplier:1.0 constant:constant];
}

- (NXConstraintItemAttribute *)constraintItemAttribute:(NSLayoutAttribute)attribute withMultiplier:(CGFloat)multiplier constant:(CGFloat)constant;
{
    return [NXConstraintItemAttribute constraintItemAttributeForItem:self
                                                       withAttribute:attribute
                                                          multiplier:multiplier
                                                            constant:constant];
}


- (void)addConstraintWhere:(NXConstraintItemAttribute *)constraint1 shouldBeEqualTo:(NXConstraintItemAttribute *)constraint2;
{
    [self addConstraintWhere:constraint1 shouldBeRelatedBy:NSLayoutRelationEqual to:constraint2];
}

- (void)addConstraintWhere:(NXConstraintItemAttribute *)constraint1 shouldBeLessOrEqualThen:(NXConstraintItemAttribute *)constraint2;
{
    [self addConstraintWhere:constraint1 shouldBeRelatedBy:NSLayoutRelationLessThanOrEqual to:constraint2];
}

- (void)addConstraintWhere:(NXConstraintItemAttribute *)constraint1 shouldBeGreaterOrEqualThen:(NXConstraintItemAttribute *)constraint2;
{
    [self addConstraintWhere:constraint1 shouldBeRelatedBy:NSLayoutRelationGreaterThanOrEqual to:constraint2];
}

- (void)addConstraintWhere:(NXConstraintItemAttribute *)constraint1
           shouldBeRelatedBy:(NSLayoutRelation)relation
                        to:(NXConstraintItemAttribute *)constraint2;
{
    [self addConstraint:[NSLayoutConstraint constraintWhere:constraint1
                                          shouldBeRelatedBy:relation
                                                         to:constraint2]];
}

@end
