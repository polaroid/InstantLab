//
//  NSLayoutConstraint+NXConstraintHelpers.m
//  NXKit
//
//  Created by Max Winde on 25.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import "NSLayoutConstraint+NXConstraintHelpers.h"

@implementation NSLayoutConstraint (NXConstraintHelpers)

+ (NSLayoutConstraint *)constraintWhere:(NXConstraintItemAttribute *)constraint1
                        shouldBeEqualTo:(NXConstraintItemAttribute *)constraint2;
{
    return [self constraintWhere:constraint1
               shouldBeRelatedBy:NSLayoutRelationEqual
                              to:constraint2];
}

+ (NSLayoutConstraint *)constraintWhere:(NXConstraintItemAttribute *)constraint1
             shouldBeGreaterOrEqualThen:(NXConstraintItemAttribute *)constraint2;
{
    return [self constraintWhere:constraint1
               shouldBeRelatedBy:NSLayoutRelationGreaterThanOrEqual
                              to:constraint2];
}

+ (NSLayoutConstraint *)constraintWhere:(NXConstraintItemAttribute *)constraint1
                shouldBeLessOrEqualThen:(NXConstraintItemAttribute *)constraint2;
{
    return [self constraintWhere:constraint1
               shouldBeRelatedBy:NSLayoutRelationLessThanOrEqual
                              to:constraint2];
}

+ (NSLayoutConstraint *)constraintWhere:(NXConstraintItemAttribute *)constraint1
                      shouldBeRelatedBy:(NSLayoutRelation)relation
                                     to:(NXConstraintItemAttribute *)constraint2;
{
    return [NSLayoutConstraint constraintWithItem:constraint1.item
                                        attribute:constraint1.attribute
                                        relatedBy:relation
                                           toItem:constraint2.item
                                        attribute:constraint2.attribute
                                       multiplier:constraint2.multiplier
                                         constant:constraint2.constant];
}

@end
