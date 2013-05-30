//
//  IPCalibrateYOffsetViewController.m
//  IPInstantLab
//
//  Created by Ullrich Schäfer on 18.03.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <BlocksKit/BlocksKit.h>

#import "IPConstants.h"
#import "IPCalibrateYOffsetViewController.h"


@interface IPCalibrateYOffsetViewController ()
@property (strong) UIView *redView;
@property (strong) UILabel *label;
@end


@implementation IPCalibrateYOffsetViewController

#pragma mark Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(update) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}


#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Calibrate";

    __weak typeof(self) blockSelf = self;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 50)];
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textColor = [UIColor whiteColor];
    [self.view addSubview:self.label];

    self.redView = [[UIView alloc] initWithFrame:CGRectZero];
    self.redView.backgroundColor = [UIColor redColor];
    self.redView.autoresizingMask = UIViewAutoresizingNone;
    [self.view insertSubview:self.redView belowSubview:self.label];
    
    
    UISwipeGestureRecognizer *upRecognizer = [[UISwipeGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [blockSelf addOffset:-1];
    }];
    upRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:upRecognizer];
    
    UISwipeGestureRecognizer *downRecognizer = [[UISwipeGestureRecognizer alloc] initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [blockSelf addOffset:1];
    }];
    downRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:downRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateRedViewPosition];
    [self updateLabelText];
}

- (void)update;
{
    [self updateRedViewPosition];
    [self updateLabelText];
}

- (void)updateLabelText;
{
    NSInteger yOffset = [[NSUserDefaults standardUserDefaults] integerForKey:IPInstaLabDebugExposureXAdjustDefaultsKey];
    self.label.text = [NSString stringWithFormat:@"y offset: %d", yOffset];
}

- (void)updateRedViewPosition;
{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    CGFloat height = ceilf(width * IPAspectRatio);
    
    // yOffset from the top of the screen
    CGFloat y = IPAppIsRunningOnTallScreen() ? IPyOffsetTallScreen : IPyOffset;
    CGFloat yOffset = [[NSUserDefaults standardUserDefaults] floatForKey:IPInstaLabDebugExposureXAdjustDefaultsKey];
    
    CGRect viewFrame = [self.view.window convertRect:CGRectMake(0, y + yOffset, width, height)
                                              toView:self.view];
    self.redView.frame = viewFrame;
}

- (void)addOffset:(NSInteger)offset;
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger yOffset = [defaults integerForKey:IPInstaLabDebugExposureXAdjustDefaultsKey];
    yOffset += offset;
    [defaults setInteger:yOffset forKey:IPInstaLabDebugExposureXAdjustDefaultsKey];
    [defaults synchronize];
    
    [self updateLabelText];
    [self updateRedViewPosition];
}

@end
