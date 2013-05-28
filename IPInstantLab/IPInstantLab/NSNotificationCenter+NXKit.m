//
//  NSNotificationCenter+NXKit.m
//  NXKit
//
//  Created by Ullrich Schäfer on 12.04.11.
//  Copyright 2011 nxtbgthng GmbH. All rights reserved.
//

#import "NSNotificationCenter+NXKit.h"


@implementation NSNotificationCenter (NXKit)


+ (void)nx_invokeOnQueue:(NSOperationQueue *)queue block:(void (^)(void))block;
{
    if (queue &&
        ([[NSOperationQueue currentQueue] isEqual:queue] == NO)) {
        [queue addOperationWithBlock:block];
    } else {
        block();
    }
}


+ (void)nx_postCoalescedNotificationName:(NSString *)notificationName
                                  object:(id)object
                                userInfo:(NSDictionary *)userinfo
                            coalesceMask:(NSUInteger)mask
                                   queue:(NSOperationQueue *)queue;
{
    void(^postNotificationBlock)() = ^{
        NSNotification *notification = [NSNotification notificationWithName:notificationName
                                                                     object:object
                                                                   userInfo:userinfo];
        [[NSNotificationQueue defaultQueue] enqueueNotification:notification
                                                   postingStyle:NSPostASAP
                                                   coalesceMask:mask
                                                       forModes:nil];
    };
    
    [self nx_invokeOnQueue:queue block:postNotificationBlock];
}

+ (void)nx_postCoalescedNotificationName:(NSString *)notificationName
                                  object:(id)object
                                userInfo:(NSDictionary *)userinfo
                            coalesceMask:(NSUInteger)mask;
{
    [self nx_postCoalescedNotificationName:notificationName object:object userInfo:userinfo coalesceMask:mask queue:nil];
}


+ (void)nx_postCoalescedNotificationName:(NSString *)notificationName
                                  object:(id)object
                                userInfo:(NSDictionary *)userinfo
                                   queue:(NSOperationQueue *)queue;
{
    [self nx_postCoalescedNotificationName:notificationName
                                    object:object
                                  userInfo:userinfo
                              coalesceMask:(NSNotificationCoalescingOnName | NSNotificationCoalescingOnSender)
                                     queue:queue];
}

+ (void)nx_postCoalescedNotificationName:(NSString *)notificationName object:(id)object userInfo:(NSDictionary *)userinfo;
{
    [self nx_postCoalescedNotificationName:notificationName object:object userInfo:userinfo queue:nil];
}

+ (void)nx_postCoalescedNotificationName:(NSString *)notificationName
                                  object:(id)object
                                   queue:(NSOperationQueue *)queue;
{
    [self nx_postCoalescedNotificationName:notificationName object:object userInfo:nil queue:queue];
}

+ (void)nx_postCoalescedNotificationName:(NSString *)notificationName object:(id)object;
{
    [self nx_postCoalescedNotificationName:notificationName object:object userInfo:nil queue:nil];
}

+ (void)nx_postImidiateNotificationName:(NSString *)notificationName
                                 object:(id)notificationSender
                               userInfo:(NSDictionary *)userInfo
								  queue:(NSOperationQueue *)queue;
{
    void(^postNotificationBlock)() = ^{
        NSNotification *aNotification = [NSNotification notificationWithName:notificationName
                                                                      object:notificationSender
                                                                    userInfo:userInfo];
        
        [[NSNotificationQueue defaultQueue] enqueueNotification:aNotification postingStyle:NSPostNow];
    };
    
    [self nx_invokeOnQueue:queue block:postNotificationBlock];
}

+ (void)nx_postImidiateNotificationName:(NSString *)notificationName
                                 object:(id)notificationSender
                               userInfo:(NSDictionary *)userInfo;

{
    [self nx_postImidiateNotificationName:notificationName object:notificationSender userInfo:userInfo queue:nil];
}

+ (void)nx_postImidiateNotificationName:(NSString *)notificationName
                                 object:(id)notificationSender
								  queue:(NSOperationQueue *)queue;
{
    void(^postNotificationBlock)() = ^{
        [NSNotificationCenter nx_postImidiateNotificationName:notificationName object:notificationSender userInfo:nil];
    };
    
    [self nx_invokeOnQueue:queue block:postNotificationBlock];
}

+ (void)nx_postImidiateNotificationName:(NSString *)notificationName
                                 object:(id)notificationSender;
{
    [self nx_postImidiateNotificationName:notificationName object:notificationSender queue:nil];
}

- (void)nx_postNotification:(NSNotification *)notification
                      queue:(NSOperationQueue *)queue;
{
    void(^postNotificationBlock)() = ^{
        [self postNotification:notification];
    };
    
    [[self class] nx_invokeOnQueue:queue block:postNotificationBlock];
}

- (void)nx_postNotificationName:(NSString *)notificationName
                       queue:(NSOperationQueue *)queue;
{
    [self nx_postNotification:[NSNotification notificationWithName:notificationName object:nil userInfo:nil]
                        queue:queue];
}

- (void)nx_postNotificationName:(NSString *)notificationName
                         object:(id)notificationSender
                          queue:(NSOperationQueue *)queue;
{
    [self nx_postNotification:[NSNotification notificationWithName:notificationName object:notificationSender userInfo:nil]
                        queue:queue];
}

- (void)nx_postNotificationName:(NSString *)notificationName
                         object:(id)notificationSender
                       userInfo:(NSDictionary *)userInfo
                          queue:(NSOperationQueue *)queue;
{
    [self nx_postNotification:[NSNotification notificationWithName:notificationName object:notificationSender userInfo:userInfo]
                        queue:queue];
}

@end
