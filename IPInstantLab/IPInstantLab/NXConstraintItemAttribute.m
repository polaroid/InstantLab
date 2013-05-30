//
//  NXConstraintItemAttribute.m
//  NXKit
//
//  Created by Max Winde on 24.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import "NXConstraintItemAttribute.h"

@implementation NXConstraintItemAttribute

+ (NXConstraintItemAttribute *)constraintItemAttributeForItem:(id)item
                                                withAttribute:(NSLayoutAttribute)attribute
                                                   multiplier:(CGFloat)multiplier
                                                     constant:(CGFloat)constant;
{
    NXConstraintItemAttribute *itemAttribute = [[NXConstraintItemAttribute alloc] init];
    itemAttribute.item = item;
    itemAttribute.attribute = attribute;
    itemAttribute.multiplier = multiplier;
    itemAttribute.constant = constant;
    
    return itemAttribute;
}

+ (NXConstraintItemAttribute *)constraintItemAttributeWithConstant:(CGFloat)constant;
{
    return [self constraintItemAttributeForItem:nil
                                  withAttribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0
                                       constant:constant];
}

@end
