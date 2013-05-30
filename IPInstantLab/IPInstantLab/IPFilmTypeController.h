//
//  IPFilmTypeController.h
//  IPInstantLab
//
//  Created by Max Winde on 23.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const IPFilmTypeControllerFilmTypeDidChangeNotification;


@interface IPFilmTypeController : NSObject

+ (IPFilmTypeController *)sharedController;

@property (strong, nonatomic, readonly) NSArray *filmOptions;
@property (strong, nonatomic) NSString *selectedFilmIdentifier;
@property (strong, nonatomic) NSDictionary *selectedFilm;
@property (assign, nonatomic) double customExposureTime;
@property (assign, nonatomic) double selectedExposureTime;

@property (strong, nonatomic, readonly) NSString *customExposureTimeLabel;

@end
