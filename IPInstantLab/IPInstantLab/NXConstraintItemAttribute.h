//
//  NXConstraintItemAttribute.h
//  NXKit
//
//  Created by Max Winde on 24.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NXConstraintItemAttribute : NSObject

@property (assign) id item;
@property (assign) NSLayoutAttribute attribute;
@property (assign) CGFloat multiplier;
@property (assign) CGFloat constant;

+ (NXConstraintItemAttribute *)constraintItemAttributeForItem:(id)item
                                                withAttribute:(NSLayoutAttribute)attribute
                                                   multiplier:(CGFloat)multiplier
                                                     constant:(CGFloat)constant;

+ (NXConstraintItemAttribute *)constraintItemAttributeWithConstant:(CGFloat)constant;

@end
