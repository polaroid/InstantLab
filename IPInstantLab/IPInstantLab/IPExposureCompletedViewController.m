//
//  IPExposureCompletedViewController.m
//  Impossible
//
//  Created by Max Winde on 30.04.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import "UIView+NXKit.h"

#import "UIColor+ImpossibleProject.h"
#import "IPExposureButtonAreaView.h"
#import "IPButton.h"
#import "IPBarButtonItem.h"

#import "IPExposureCompletedViewController.h"

@interface IPExposureCompletedViewController ()

@property (strong, readonly) NSString *filmIdentifier;

@property (strong) UIImageView *imageView;
@property (strong) IPExposureButtonAreaView *controllAreaView;
@property (strong) IPButton *sameImageButton;
@property (strong) IPButton *restartButton;

@end

@implementation IPExposureCompletedViewController

- (id)initWithFilmIdentifier:(NSString *)filmIdentifier;
{
    self = [super init];
    
    if (self) {
        _filmIdentifier = filmIdentifier;
        self.title = NSLocalizedString(@"Done!", @"Exposure Process completed view controller title");
    }
    
    return self;
}

- (void)viewDidLoad;
{
    NSString *imageName = [NSString stringWithFormat:@"instantlab_screen6_clock-%@", (self.filmIdentifier ? self.filmIdentifier : @"custom")];
    self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self.imageView.contentMode = UIViewContentModeCenter;
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.imageView];
    
    self.controllAreaView = [[IPExposureButtonAreaView alloc] init];
    self.controllAreaView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.controllAreaView];
    
    __weak typeof(self) blockSelf = self;
    
    self.sameImageButton = [IPButton button];
    [self.sameImageButton addEventHandler:^(id sender) {
        [blockSelf.navigationController popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.sameImageButton setTitle:NSLocalizedString(@"Same image", @"Expose with same image button title")
                          forState:UIControlStateNormal];
    [self.sameImageButton setImage:[UIImage imageNamed:@"instantlab_icon-sameimage_inactive"]
                          forState:UIControlStateNormal];
    self.sameImageButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.controllAreaView addSubview:self.sameImageButton];
    
    self.restartButton = [IPButton button];
    [self.restartButton addEventHandler:^(id sender) {
        [blockSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    [self.restartButton setTitle:NSLocalizedString(@"Close", @"close the instant lab")
                        forState:UIControlStateNormal];
    [self.restartButton setImage:[UIImage imageNamed:@"instantlab_icon-close_inactive"]
                        forState:UIControlStateNormal];
    self.restartButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.controllAreaView addSubview:self.restartButton];
    
    self.navigationItem.leftBarButtonItem = [IPBarButtonItem barButtonItemForPosition:IPBarButtonItemPositionLeft
                                                                            withImage:[UIImage imageNamed:@"instantlab_icon-back_inactive"]
                                                                              handler:^(id sender) {
                                                                                  NSArray *viewControllers = blockSelf.navigationController.viewControllers;
                                                                                  UIViewController *controller = [viewControllers objectAtIndex:viewControllers.count - 3];
                                                                                  [blockSelf.navigationController popToViewController:controller animated:YES];
                                                                              }];
    
    [self.view nx_addVisualConstraints:(@[
                                        @"V:|[imageView][controllAreaView]|",
                                        @"H:|[imageView]|",
                                        @"H:|[controllAreaView]|",
                                        @"H:|[sameImageButton][restartButton(==sameImageButton)]|",
                                        @"V:|[sameImageButton]|",
                                        @"V:|[restartButton]|"
                                        ])
                                 views:(@{
                                        @"imageView": self.imageView,
                                        @"controllAreaView": self.controllAreaView,
                                        @"sameImageButton": self.sameImageButton,
                                        @"restartButton": self.restartButton
                                        })];
}

@end
