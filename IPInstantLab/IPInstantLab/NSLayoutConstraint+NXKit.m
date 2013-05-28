//
//  NSLayoutConstraint+NXKit.m
//  NXExtensions
//
//  Created by Ullrich Schäfer on 05.04.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import "NSLayoutConstraint+NXKit.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_6_0 || __MAC_OS_X_VERSION_MIN_REQUIRED >= __MAC_10_7

@implementation NSLayoutConstraint (NXKit)

+ (NSArray *)nx_constraintsWithVisualFormats:(NSArray *)visualFormats
                                       views:(NSDictionary *)views;
{
    return [self nx_constraintsWithVisualFormats:visualFormats metrics:nil views:views];
}

+ (NSArray *)nx_constraintsWithVisualFormats:(NSArray *)visualFormats
                                     metrics:(NSDictionary *)metrics
                                       views:(NSDictionary *)views;
{
    NSMutableArray *constraints = [NSMutableArray array];
    for (NSString *visualFormat in visualFormats) {
        [constraints addObjectsFromArray:[self nx_constraintsWithVisualFormat:visualFormat
                                                                      metrics:metrics
                                                                        views:views]];
    }
    return constraints;
}

+ (NSArray *)nx_constraintsWithVisualFormat:(NSString *)visualFormat
                                      views:(NSDictionary *)views;
{
    return [self nx_constraintsWithVisualFormat:visualFormat metrics:nil views:views];
}

+ (NSArray *)nx_constraintsWithVisualFormat:(NSString *)visualFormat
                                    metrics:(NSDictionary *)metrics
                                      views:(NSDictionary *)views;
{
    return [NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:0 metrics:metrics views:views];
}

@end

#endif
