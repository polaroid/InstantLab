//
//  UIDevice+NXKit.h
//  NXKit
//
//  Created by Ullrich Schäfer on 07.12.10.
//  Copyright 2010 nxtbgthng GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface UIDevice (NXKit)
- (NSString *)nx_sysctlValueForName:(NSString *)name;

@property (nonatomic, retain, readonly) NSString *nx_machine;
@property (nonatomic, retain, readonly) NSString *nx_formatted_machine;

/* 
 *  @return The processor generation of the device.
 *
 *  1 = Classic/3G Class
 *  2 = 3GS Class
 *  3 = A4
 *  4 = A5 (Dual Core)
 *  NSUIntegerMax = Simulator
 */
@property (nonatomic, assign, readonly) NSUInteger nx_generation;

@end
