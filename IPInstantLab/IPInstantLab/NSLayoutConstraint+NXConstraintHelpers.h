//
//  NSLayoutConstraint+NXConstraintHelpers.h
//  NXKit
//
//  Created by Max Winde on 25.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NXConstraintItemAttribute.h"

@interface NSLayoutConstraint (NXConstraintHelpers)

+ (NSLayoutConstraint *)constraintWhere:(NXConstraintItemAttribute *)constraint1 shouldBeEqualTo:(NXConstraintItemAttribute *)constraint2;
+ (NSLayoutConstraint *)constraintWhere:(NXConstraintItemAttribute *)constraint1 shouldBeLessOrEqualThen:(NXConstraintItemAttribute *)constraint2;
+ (NSLayoutConstraint *)constraintWhere:(NXConstraintItemAttribute *)constraint1 shouldBeGreaterOrEqualThen:(NXConstraintItemAttribute *)constraint2;
+ (NSLayoutConstraint *)constraintWhere:(NXConstraintItemAttribute *)constraint1
                      shouldBeRelatedBy:(NSLayoutRelation)relation
                                     to:(NXConstraintItemAttribute *)constraint2;

@end
