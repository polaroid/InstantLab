//
//  NSNotificationCenter+NXKit.h
//  NXKit
//
//  Created by Ullrich Schäfer on 12.04.11.
//  Copyright 2011 Impossible GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSNotificationCenter (NXKit)

// All methods support an optional queue parameter.
// The notification will be posted on the queue. 
// If queue is nil it will be posted on the current queue.
// Be a bit carefull though, if the queue exits/is canceled 
// before the  notification is posted it will never get 
// posted.

+ (void)nx_postCoalescedNotificationName:(NSString *)notificationName
                                  object:(id)object
                                userInfo:(NSDictionary *)userinfo
                            coalesceMask:(NSUInteger)mask
                                   queue:(NSOperationQueue *)queue;

+ (void)nx_postCoalescedNotificationName:(NSString *)notificationName
                                  object:(id)object
                                userInfo:(NSDictionary *)userinfo
                            coalesceMask:(NSUInteger)mask;

+ (void)nx_postCoalescedNotificationName:(NSString *)notificationName
                                  object:(id)object
                                userInfo:(NSDictionary *)userinfo
                                   queue:(NSOperationQueue *)queue;

+ (void)nx_postCoalescedNotificationName:(NSString *)notificationName
                                  object:(id)object
                                userInfo:(NSDictionary *)userinfo;

+ (void)nx_postCoalescedNotificationName:(NSString *)notificationName
                                  object:(id)object
                                   queue:(NSOperationQueue *)queue;

+ (void)nx_postCoalescedNotificationName:(NSString *)notificationName
                                  object:(id)object;


+ (void)nx_postImidiateNotificationName:(NSString *)notificationName
                                 object:(id)notificationSender
                               userInfo:(NSDictionary *)userInfo
								  queue:(NSOperationQueue *)queue;

+ (void)nx_postImidiateNotificationName:(NSString *)notificationName
                                 object:(id)notificationSender
                               userInfo:(NSDictionary *)userInfo;


+ (void)nx_postImidiateNotificationName:(NSString *)notificationName
                                 object:(id)notificationSender
								  queue:(NSOperationQueue *)queue;

+ (void)nx_postImidiateNotificationName:(NSString *)notificationName
                                 object:(id)notificationSender;

- (void)nx_postNotification:(NSNotification *)notification
                      queue:(NSOperationQueue *)queue;

- (void)nx_postNotificationName:(NSString *)notificationName
                          queue:(NSOperationQueue *)queue;

- (void)nx_postNotificationName:(NSString *)notificationName
                         object:(id)notificationSender
                          queue:(NSOperationQueue *)queue;

- (void)nx_postNotificationName:(NSString *)notificationName
                         object:(id)notificationSender
                       userInfo:(NSDictionary *)userInfo
                          queue:(NSOperationQueue *)queue;

@end
