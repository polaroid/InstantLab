//
//  UIDevice+NXKit.m
//  NXKit
//
//  Created by Ullrich Schäfer on 07.12.10.
//  Copyright 2010 Impossible GmbH. All rights reserved.
//

#import <sys/types.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>

#import "UIDevice+NXKit.h"


@implementation UIDevice (NXKit)

- (NSString *)nx_sysctlValueForName:(NSString *)name;
{
	size_t size;
	const char* cName = [name UTF8String];
    if (sysctlbyname(cName, NULL, &size, NULL, 0) != noErr) return nil;
	
	NSString *value = nil;
    char *cValue = malloc(size);
    if (sysctlbyname(cName, cValue, &size, NULL, 0) == noErr) {
		value = [NSString stringWithCString:cValue encoding:NSUTF8StringEncoding];
	}
    free(cValue);
    return value;
}

- (NSString *)nx_machine;
{
	return [self nx_sysctlValueForName:@"hw.machine"];
}


/*
 * Source: http://www.everymac.com/systems/apple/
 * Source: Mactracker https://itunes.apple.com/de/app/mactracker/id430255202?mt=12
 * 
 */
- (NSString *)nx_formatted_machine;
{
	NSString *machine = [self nx_sysctlValueForName:@"hw.machine"];
    
    // iPhone
	if ([machine caseInsensitiveCompare:@"iPhone1,1"] == NSOrderedSame)       return @"iPhone 1G";
    else if ([machine caseInsensitiveCompare:@"iPhone1,2"]  == NSOrderedSame) return @"iPhone 3G";
    else if ([machine caseInsensitiveCompare:@"iPhone1,2*"] == NSOrderedSame) return @"iPhone 3G NoWiFi";
    else if ([machine caseInsensitiveCompare:@"iPhone2,1"]  == NSOrderedSame) return @"iPhone 3GS";
    else if ([machine caseInsensitiveCompare:@"iPhone2,1*"] == NSOrderedSame) return @"iPhone 3GS NoWiFi";
    else if ([machine caseInsensitiveCompare:@"iPhone3,1"]  == NSOrderedSame) return @"iPhone 4";
    else if ([machine caseInsensitiveCompare:@"iPhone3,3"]  == NSOrderedSame) return @"iPhone 4 (CDMA)";
    else if ([machine caseInsensitiveCompare:@"iPhone4,1"]  == NSOrderedSame) return @"iPhone 4S";
    else if ([machine caseInsensitiveCompare:@"iPhone5,1"]  == NSOrderedSame) return @"iPhone 5 (GSM)";
    else if ([machine caseInsensitiveCompare:@"iPhone5,2"]  == NSOrderedSame) return @"iPhone 5";
    
    // iPod
    else if ([machine caseInsensitiveCompare:@"iPod1,1"] == NSOrderedSame)    return @"iPod Touch 1G";
    else if ([machine caseInsensitiveCompare:@"iPod2,1"] == NSOrderedSame)    return @"iPod Touch 2G";
    else if ([machine caseInsensitiveCompare:@"iPod3,1"] == NSOrderedSame)    return @"iPod Touch 3G";
    else if ([machine caseInsensitiveCompare:@"iPod4,1"] == NSOrderedSame)    return @"iPod Touch 4G";
    else if ([machine caseInsensitiveCompare:@"iPod5,1"] == NSOrderedSame)    return @"iPod Touch 5G";
    else if ([machine caseInsensitiveCompare:@"iPad1,1"] == NSOrderedSame)    return @"iPad";
    
    // iPad
    else if ([machine caseInsensitiveCompare:@"iPad2,1"] == NSOrderedSame)    return @"iPad 2 WiFi";
    else if ([machine caseInsensitiveCompare:@"iPad2,2"] == NSOrderedSame)    return @"iPad 2 GSM";
    else if ([machine caseInsensitiveCompare:@"iPad2,3"] == NSOrderedSame)    return @"iPad 2 CDMA";
    else if ([machine caseInsensitiveCompare:@"iPad2,4"] == NSOrderedSame)    return @"iPad 2 WiFi";
    else if ([machine caseInsensitiveCompare:@"iPad2,5"] == NSOrderedSame)    return @"iPad Mini WiFi";
    else if ([machine caseInsensitiveCompare:@"iPad2,6"] == NSOrderedSame)    return @"iPad Mini GSM";
    else if ([machine caseInsensitiveCompare:@"iPad2,7"] == NSOrderedSame)    return @"iPad Mini CDMA";
    else if ([machine caseInsensitiveCompare:@"iPad3,1"] == NSOrderedSame)    return @"iPad 3 WiFi";
    else if ([machine caseInsensitiveCompare:@"iPad3,2"] == NSOrderedSame)    return @"iPad 3 GSM";
    else if ([machine caseInsensitiveCompare:@"iPad3,3"] == NSOrderedSame)    return @"iPad 3 CDMA";
    else if ([machine caseInsensitiveCompare:@"iPad3,4"] == NSOrderedSame)    return @"iPad 4 WiFi";
    else if ([machine caseInsensitiveCompare:@"iPad3,5"] == NSOrderedSame)    return @"iPad 4 GSM";
    else if ([machine caseInsensitiveCompare:@"iPad3,6"] == NSOrderedSame)    return @"iPad 4 CDMA";
    
    // Simulator
    else if ([machine caseInsensitiveCompare:@"i386"]    == NSOrderedSame)    return @"Simulator";
    else if ([machine caseInsensitiveCompare:@"x86_64"]  == NSOrderedSame)    return @"Simulator";
    
    return [NSString stringWithFormat: @"[%@]", machine];
}

- (NSUInteger)nx_generation;
{
	NSString *machine = [self nx_machine];
    
	if ([machine caseInsensitiveCompare:@"iPhone1,1"] == NSOrderedSame
		|| [machine caseInsensitiveCompare:@"iPhone1,2*"] == NSOrderedSame
		|| [machine caseInsensitiveCompare:@"iPhone1,2"] == NSOrderedSame
		|| [machine caseInsensitiveCompare:@"iPod1,1"] == NSOrderedSame
		|| [machine caseInsensitiveCompare:@"iPod2,1"] == NSOrderedSame) {
		return 1;
	} else if ([machine caseInsensitiveCompare:@"iPhone2,1"] == NSOrderedSame
               || [machine caseInsensitiveCompare:@"iPhone2,1*"] == NSOrderedSame
			   || [machine caseInsensitiveCompare:@"iPod3,1"] == NSOrderedSame) {
		return 2;
	} else if ([machine caseInsensitiveCompare:@"iPhone3,1"] == NSOrderedSame
			   || [machine caseInsensitiveCompare:@"iPod4,1"] == NSOrderedSame
			   || [machine caseInsensitiveCompare:@"iPad1,1"] == NSOrderedSame) {
		return 3;
	} else if ([machine caseInsensitiveCompare:@"iPhone4,1"] == NSOrderedSame
               || [machine caseInsensitiveCompare:@"iPad2,1"] == NSOrderedSame
               || [machine caseInsensitiveCompare:@"iPad2,2"] == NSOrderedSame
               || [machine caseInsensitiveCompare:@"iPad2,3"] == NSOrderedSame) {
        return 4;
    }
	
	return NSUIntegerMax;
}

@end
