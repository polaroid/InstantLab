//
//  IPAppDelegate.m
//  IPInstantLab
//
//  Created by Tobias Kräntzer on 27.05.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//


#import "IPAppDelegate.h"

@implementation IPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UIStoryboard storyboardWithName:@"Storyboard" bundle:nil] instantiateInitialViewController];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
