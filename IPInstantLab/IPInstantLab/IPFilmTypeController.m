//
//  IPFilmTypeController.m
//  Impossible
//
//  Created by Max Winde on 23.04.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import <BlocksKit/BlocksKit.h>

#import "NSNotificationCenter+NXKit.h"
#import "UIDevice+NXKit.h"

#import "IPConstants.h"
#import "IPFilmTypeController.h"

NSString * const IPFilmTypeControllerFilmTypeDidChangeNotification = @"IPFilmTypeControllerFilmTypeDidChangeNotification";

@implementation IPFilmTypeController

static IPFilmTypeController *sharedFilmTypeController;

+ (IPFilmTypeController *)sharedController;
{
    if (sharedFilmTypeController == nil) {
        sharedFilmTypeController = [[IPFilmTypeController alloc] init];
    }
    
    return sharedFilmTypeController;
}

- (id)init;
{
    self = [super init];
    
    if (self) {
//        [[NSUserDefaults standardUserDefaults] registerDefaults:@{ IPSelectedInstaLabFilmDefaultsKey: self.filmOptions[0][IPSelectedInstaLabFilmIdentifierKey] }];
    }
    
    return self;
}

@synthesize filmOptions = _filmOptions;

- (NSArray *)filmOptions;
{
    if (_filmOptions == nil) {
        NSDictionary *filmDict = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"InstaLabFilms" withExtension:@"plist"]];
        NSString *deviceId = [[[[UIDevice currentDevice] nx_machine] componentsSeparatedByString:@","] objectAtIndex:0];
        NSArray *filmOptions = [filmDict valueForKey:deviceId];
        if (!filmOptions) {
            filmOptions = [filmDict valueForKey:@"default"];
        }
        _filmOptions = filmOptions;
        NSAssert(_filmOptions != nil, @"Film options could not be loaded from the main bundle. Are they in this target?!");
    }
    
    return _filmOptions;
}

- (NSString *)selectedFilmIdentifier;
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:IPSelectedInstaLabFilmDefaultsKey];
}

- (void)setSelectedFilmIdentifier:(NSString *)selectedFilmIdentifier;
{
    if (selectedFilmIdentifier) {
        self.customExposureTime = 0;
        [[NSUserDefaults standardUserDefaults] setObject:selectedFilmIdentifier
                                                  forKey:IPSelectedInstaLabFilmDefaultsKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:IPSelectedInstaLabFilmDefaultsKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] nx_postNotificationName:IPFilmTypeControllerFilmTypeDidChangeNotification
                                                           object:self
                                                         userInfo:nil
                                                            queue:[NSOperationQueue mainQueue]];
}

- (NSDictionary *)selectedFilm;
{
    NSDictionary *film = [self.filmOptions match:^BOOL(NSDictionary *film) {
        return [film[IPSelectedInstaLabFilmIdentifierKey] isEqualToString:self.selectedFilmIdentifier];
    }];
    
    if (film == nil && self.customExposureTime == 0) {
        film = self.filmOptions[0];
    }
    
    return film;
}

- (void)setSelectedFilm:(NSDictionary *)selectedFilm;
{
    self.selectedFilmIdentifier = selectedFilm[IPSelectedInstaLabFilmIdentifierKey];
}

- (double)customExposureTime;
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:IPInstaLabDebugCustomExposureTimeDefaultsKey] doubleValue];
}

- (double)selectedExposureTime;
{
    if (self.selectedFilm) {
        return [self.selectedFilm[IPSelectedInstaLabFilmExposureKey] doubleValue];
    } else {
        return self.customExposureTime;
    }
}

- (void)setCustomExposureTime:(double)customExposureTime;
{
    NSLog(@"customExposureTime: %f", customExposureTime);
    if (customExposureTime == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:IPInstaLabDebugCustomExposureTimeDefaultsKey];
    } else {
        self.selectedFilm = nil;
        [[NSUserDefaults standardUserDefaults] setObject:@(customExposureTime) forKey:IPInstaLabDebugCustomExposureTimeDefaultsKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[NSNotificationCenter defaultCenter] nx_postNotificationName:IPFilmTypeControllerFilmTypeDidChangeNotification
                                                           object:self
                                                         userInfo:nil
                                                            queue:[NSOperationQueue mainQueue]];
}

- (NSString *)customExposureTimeLabel;
{
    return NSLocalizedString(@"Custom", @"custom exposure time label");
}

@end
