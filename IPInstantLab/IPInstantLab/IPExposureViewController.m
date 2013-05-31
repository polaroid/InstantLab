//
//  IPExposureViewController.m
//  IPInstantLab
//
//  Created by Ullrich Schäfer on 15.03.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <WCAlertView/WCAlertView.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreMotion/CoreMotion.h>
#import "UIView+NXKit.h"
#import "UIView+Constraints.h"

#import "NXLayoutConstraintHelpers.h"
#import "IPConstants.h"
#import "UIColor+ImpossibleProject.h"
#import "UIFont+ImpossibleProject.h"
#import "UIView+ImpossibleProject.h"

#import "IPButton.h"

#import "IPExposureCompletedViewController.h"

#import "IPExposureViewController.h"

/*
              /¯\
              \_/     _________
               |     |         |
         ______v_____v_        | Orientation change to not face down
        | Instructions |-------
         ¯¯¯¯¯¯|¯¯¯¯¯¯¯
     -faceDown |  Orientation change to face fown
   ____________v_____________________________________
 |¯¯¯¯¯¯¯¯¯¯¯¯¯|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯||
 |        _____v_____                               ||
 |       | Face Down |                              ||
 |        ¯¯¯¯¯|¯¯¯¯¯                               ||
 |  -preExpose |  Timer (IPPreExposeDelay)          ||
 |   __________|_________                           ||
 |  | Waiting for Expose |                          ||
 |   ¯¯¯¯¯¯¯¯¯¯|¯¯¯¯¯¯¯¯¯                           ||
 |     -expose |  Timer (IPExposeDelay)             ||
 |         ____v___                                 ||
 |        | Expose |                                ||______________
 |         ¯¯¯¯|¯¯¯                                 ||              |
 | -exposeDone |  Timer (expose Time)               ||              |
 |_____________|____________________________________|'              |
           ____v____                                                |
          | Waiting |                                               |
           ¯¯¯¯|¯¯¯¯                                                |
       -faceUp |  Orientation change to not face down       -faceUp | Orientation change to not face down
            ___v__                                             _____v____
           | Done |                                           | Canceled |
            ¯¯¯|¯¯                                             ¯¯¯¯¯|¯¯¯¯
               v                                                    v
              /¯\___________________________________________________|
              \_/
 */


typedef NS_ENUM(NSInteger, IPExposureState) {
    IPExposureStateInstructions,
    IPExposureStateFaceDown,
    IPExposureStateWaitForExpose,
    IPExposureStateExpose,
    IPExposureStateWaiting, // let the user close the shutter and pick up the phone
    IPExposureStateDone,
    IPExposureStateCanceled
};

@interface IPExposureViewController ()
@property (strong) UIImage *image;
@property (assign) NSTimeInterval exposureTime;
@property (strong) NSString *filmIdentifier;

@property (strong) MPMoviePlayerController *moviePlayer;
@property (strong) UIImageView *instructionImageView;
@property (strong) IPButton *instructionPlayAgainButton;

@property (strong) UIView *blackView;
@property (strong) UIImageView *imageView;

@property (assign, nonatomic) IPExposureState state;

@property (strong) AVCaptureSession *avTorchSession;

@property (readonly) float originalScreenBrightness;

@property (strong) CMMotionManager *motionManager;
@property (assign) BOOL isFaceDown;

@property (strong) AVAudioPlayer *shutterPlayer;
@property (strong) AVAudioPlayer *beepPlayer;

@property (assign) BOOL isFlashOn;

- (void)updateWithAttitude:(CMAttitude *)attitude;

// state transitions
- (void)faceDown;
- (void)expose;
- (void)exposeDone;
- (void)faceUp;

- (void)toggleFlash:(BOOL)onOff fullBrightness:(BOOL)fullBrightness;

- (void)cancel;
- (void)done;
@end


@implementation IPExposureViewController

#pragma mark Lifecycle

- (id)initWithImage:(UIImage *)image exposureTime:(NSTimeInterval)exposureTimeInterval filmIdentifier:(NSString *)filmIdentifier;
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        NSAssert(exposureTimeInterval > 0.0, @"Exposure time cannot be <= 0.0 seconds");
        _exposureTime = exposureTimeInterval;
        _filmIdentifier = filmIdentifier;
        _originalScreenBrightness = [UIScreen mainScreen].brightness;
        self.image = image;
        self.state = IPExposureStateInstructions;
        self.title = NSLocalizedString(@"Expose", @"view controller nav bar title");
        
        _motionManager = [[CMMotionManager alloc] init];
        self.motionManager.deviceMotionUpdateInterval = 0.1;
        _isFaceDown = NO;
        
        // shutter audio player
        NSError *err;
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:&err];
        [session setActive:YES error:&err];
        
        // http://www.soundjay.com/camera-sound-effect.html
        NSString *shutterPath = [[NSBundle mainBundle] pathForResource:@"camera-shutter-click-08" ofType:@"wav"];
        self.shutterPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:shutterPath] error:&err];
        [self.shutterPlayer prepareToPlay];
        
        // http://www.soundjay.com/beep-sounds-1.html
        NSString *beepPath = [[NSBundle mainBundle] pathForResource:@"beep-7" ofType:@"wav"];
        self.beepPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:beepPath] error:&err];
        self.beepPlayer.volume = 0.4;
        [self.beepPlayer prepareToPlay];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillBecomeInactive:)
                                                     name:UIApplicationWillResignActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [self.motionManager stopDeviceMotionUpdates];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor ip_backgroundColor];
    
    NSURL *movieURL = [[NSBundle mainBundle] URLForResource:@"ExposureInstructionVideo" withExtension:@"mp4"];
    self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
    self.moviePlayer.view.hidden = YES;
    self.moviePlayer.allowsAirPlay = NO;
    self.moviePlayer.shouldAutoplay = NO;
    self.moviePlayer.controlStyle = MPMovieControlStyleNone;
    self.moviePlayer.repeatMode = MPMovieRepeatModeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:MPMoviePlayerLoadStateDidChangeNotification
                                               object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayerStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.moviePlayer];
    
    [self.moviePlayer prepareToPlay];
    
    self.moviePlayer.view.userInteractionEnabled = NO;
    self.moviePlayer.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.moviePlayer.view];
    
    self.moviePlayer.backgroundView.backgroundColor = [UIColor ip_backgroundColor]; // needs to be called after self.moviePlayer.view was called, else backgroundView is nil
    
    self.instructionImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"instantlab_screen-animation"]];
    self.instructionImageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.instructionImageView.backgroundColor = [UIColor ip_backgroundColor];
    [self.view insertSubview:self.instructionImageView belowSubview:self.moviePlayer.view];
    
    self.instructionPlayAgainButton = [IPButton button];
    self.instructionPlayAgainButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.instructionPlayAgainButton setTitle:NSLocalizedString(@"WATCH TUTORIAL", nil)
                                     forState:UIControlStateNormal];
    [self.instructionPlayAgainButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:self.instructionPlayAgainButton belowSubview:self.moviePlayer.view];
    
    
    // layout
    
    [self.view nx_addConstraintToCenterViewHorizontally:self.moviePlayer.view];
    [self.view nx_addVisualConstraints:(@[
                                        @"H:[video(320)]",
                                        @"V:[video(480)]"])
                                 views:(@{@"video":self.moviePlayer.view})];
    [self.view nx_addVisualConstraint:(IPAppIsRunningOnTallScreen() ? @"V:[image]-(25)-[button]" : @"V:[image][button]")
                                views:(@{
                                       @"button": self.instructionPlayAgainButton,
                                       @"image": self.instructionImageView})];

    
    
    [self.view nx_addConstraintToCenterViewHorizontally:self.instructionImageView];
    [self.view nx_addConstraintToCenterViewVertically:self.instructionImageView];
    [self.view nx_addConstraintForSameWidth:self.instructionImageView];
    
    [self.view nx_addConstraintToCenterViewHorizontally:self.instructionPlayAgainButton];
    [self.view nx_addVisualConstraints:(@[@"V:[button(30)]-|",
                                        @"H:[button(200)]"])
                                 views:(@{@"button":self.instructionPlayAgainButton})];
    
    
    
    self.blackView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.blackView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.blackView.backgroundColor = [UIColor blackColor];
    self.blackView.hidden = YES;
    [self.view addSubview:self.blackView];
    
    CGFloat yOffset = IPAppIsRunningOnTallScreen() ? IPyOffsetTallScreen : IPyOffset;
    yOffset -= 20; // status bar adjustment
    yOffset += [[NSUserDefaults standardUserDefaults] floatForKey:IPInstaLabDebugExposureXAdjustDefaultsKey];
    
    self.imageView = [[UIImageView alloc] initWithImage:self.image];
    self.imageView.frame = CGRectMake(0, yOffset, 320, ceilf(320 * IPAspectRatio));
    self.imageView.autoresizingMask = UIViewAutoresizingNone;
    self.imageView.clipsToBounds = YES;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.hidden = YES;
    self.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [self.blackView addSubview:self.imageView];
    
    
    [self updateViewConstraints];
}

- (void)viewDidAppear:(BOOL)animated;
{
    [super viewDidAppear:animated];
    __weak typeof(self) blockSelf = self;
    
    self.state = IPExposureStateInstructions;
    
    [self.motionManager startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init]
                                            withHandler:^(CMDeviceMotion *motion, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [blockSelf updateWithAttitude:motion.attitude];
                                                });
                                            }];
}

- (void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    
    [self.motionManager stopDeviceMotionUpdates];
    [[UIScreen mainScreen] setBrightness:self.originalScreenBrightness];
}


#pragma mark Video Playback

- (void)loadStateDidChange:(NSNotification *)notification;
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IPInstaLabExposureInstructionVideoWasShownDefaultsKey] == NO) {
        [self playVideo:nil];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IPInstaLabExposureInstructionVideoWasShownDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (void)moviePlayerStateDidChange:(NSNotification *)notification;
{
    MPMoviePlayerController *moviePlayer = self.moviePlayer;
    if (moviePlayer.playbackState == MPMoviePlaybackStatePaused) {
        self.moviePlayer.view.hidden = YES;
        self.instructionPlayAgainButton.userInteractionEnabled = YES;
    }
}


#pragma mark Rotation


// perfect face down when
// pitch = 0
// roll = M_PI_2
- (void)updateWithAttitude:(CMAttitude *)attitude
{
    BOOL wasFaceDown = self.isFaceDown;
    
    NSInteger pitch = (180/M_PI) * attitude.pitch;
    NSInteger roll  = (180/M_PI) * attitude.roll;
    
    // move the values to the positive scale
    pitch = (pitch + 360) % 360;
    roll = (roll + 360) % 360;
    
    CGFloat tollerance = 30;
    if ((pitch < tollerance || pitch > (360 - tollerance)) &&
        (roll > (180 - tollerance) && roll < (180 + tollerance))) {
        self.isFaceDown = YES;
    } else {
        self.isFaceDown = NO;
    }
    
    if (self.isFaceDown && !wasFaceDown) {
        [self faceDown];
    } else if (!self.isFaceDown && wasFaceDown) {
        [self faceUp];
    }
}


#pragma mark Transitions

- (void)setState:(IPExposureState)state;
{
    if (state == _state) return;
    
    _state = state;
    
    NSLog(@"state: %i", state);
}

- (void)faceDown;
{
    if (self.state != IPExposureStateInstructions) return;
    
    self.state = IPExposureStateFaceDown;
    
    double delayInSeconds = IPPreExposeDelay;
    [self performSelector:@selector(preExpose) withObject:nil afterDelay:delayInSeconds];
    
    // hide UI
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBarHidden = YES;
    self.blackView.hidden = NO;
    [self.view addSubview:self.blackView]; // make sure it's on top
    self.imageView.hidden = YES; // just to be sure
    [[UIScreen mainScreen] setBrightness:0.0];
}

- (void)preExpose;
{
    self.state = IPExposureStateWaitForExpose;
    
    double delayInSeconds = IPExposeDelay;
    [self performSelector:@selector(expose) withObject:nil afterDelay:delayInSeconds];
    
    [self toggleFlash:YES fullBrightness:NO];
}

- (void)expose;
{
    self.state = IPExposureStateExpose;
    
    [self performSelector:@selector(exposeDone) withObject:nil afterDelay:self.exposureTime];
    
    // show Image
    self.imageView.hidden = NO;
    [[UIScreen mainScreen] setBrightness:1.0];
    [self toggleFlash:YES fullBrightness:NO];
}

- (void)exposeDone;
{
    self.state = IPExposureStateWaiting;
    
    // hide Image
    self.imageView.hidden = YES;
    [[UIScreen mainScreen] setBrightness:0.0];
    
    // flash the flash
    [self toggleFlash:NO fullBrightness:YES];
    [self toggleFlash:YES fullBrightness:YES];
    
    [self.shutterPlayer play];
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self toggleFlash:NO fullBrightness:NO];
    });
}

- (void)faceUp;
{
    if (self.state == IPExposureStateInstructions) return;
    
    if (self.state == IPExposureStateWaiting) {
        [self faceUpDone];
    } else if (self.state != IPExposureStateCanceled) {
        [self faceUpCancel];
    }
    
    // show UI again
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBarHidden = NO;
    self.blackView.hidden = YES;
    self.imageView.hidden = YES;
    
    // always reset flash & brightness
    [self toggleFlash:NO fullBrightness:NO];
    [[UIScreen mainScreen] setBrightness:self.originalScreenBrightness];
    
    // and always cancel all scheduled transitions
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(preExpose)  object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(expose)     object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(exposeDone) object:nil];
}

- (void)faceUpDone;
{
    self.state = IPExposureStateDone;
    [self done];
}

- (void)faceUpCancel;
{
    self.state = IPExposureStateCanceled;
    [self cancel];
}

- (void)done;
{
    IPExposureCompletedViewController *viewController = [[IPExposureCompletedViewController alloc] initWithFilmIdentifier:self.filmIdentifier];
    [self.navigationController pushViewController:viewController animated:NO];
}

- (void)cancel;
{
    // go straight to the beginning
    [WCAlertView showAlertWithTitle:NSLocalizedString(@"Canceled", nil)
                            message:NSLocalizedString(@"The exposure process was canceled", nil)
                 customizationBlock:nil
                    completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        self.state = IPExposureStateInstructions;
                    }
                  cancelButtonTitle:NSLocalizedString(@"Try again", nil)
                  otherButtonTitles:nil];
}


#pragma mark Helper

- (void)toggleFlash:(BOOL)onOff fullBrightness:(BOOL)fullBrightness;
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    if ([device hasTorch] == YES)
    {
        BOOL torchIsOn = (device.torchMode == AVCaptureTorchModeOn);
        
        if (torchIsOn == onOff) return; // no changes
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        [device lockForConfiguration:nil]; //you must lock before setting torch mode
        NSError *error = nil;
        if (onOff) {
            [device setTorchModeOnWithLevel:(fullBrightness ? AVCaptureMaxAvailableTorchLevel : 0.01)
                                      error:&error];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        if (error) {
            NSLog(@"Set Toch Mode Error: %@", [error localizedDescription]);
        }
        [device unlockForConfiguration];
    } else {
        if (self.isFlashOn == NO &&
            onOff == YES &&
            fullBrightness == NO) {
            
            [self.beepPlayer play];
        }
    }
    
    self.isFlashOn = onOff;
}


#pragma mark Notifications

- (void)applicationDidBecomeActive:(NSNotification *)notification;
{
    if (self.state == IPExposureStateInstructions) {
        [self.moviePlayer play];
    }
    _originalScreenBrightness = UIScreen.mainScreen.brightness;
}

- (void)applicationWillBecomeInactive:(NSNotification *)notification;
{
    UIScreen.mainScreen.brightness = self.originalScreenBrightness;
}

#pragma mark Actions

- (IBAction)playVideo:(id)sender
{
    if (self.moviePlayer.isPreparedToPlay) {
        self.moviePlayer.view.hidden = NO;
        self.instructionPlayAgainButton.userInteractionEnabled = NO;
        self.moviePlayer.currentPlaybackTime = 0;
        [self.moviePlayer play];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:IPInstaLabExposureInstructionVideoWasShownDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.moviePlayer prepareToPlay];
    }
    
}

@end
