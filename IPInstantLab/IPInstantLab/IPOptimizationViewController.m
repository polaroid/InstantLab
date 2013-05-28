//
//  IPFilterViewController.m
//  Impossible
//
//  Created by Ullrich Schäfer on 13.03.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <WCAlertView/WCAlertView.h>

#import "UIView+NXKit.h"
#import "NXLayoutConstraintHelpers.h"

#import "IPConstants.h"
#import "IPFilmTypeController.h"
#import "UIView+ImpossibleProject.h"
#import "UIView+Constraints.h"
#import "UIFont+ImpossibleProject.h"
#import "UIColor+ImpossibleProject.h"

#import "IPPhotoFrameView.h"
#import "IPBarButtonItem.h"
#import "IPCalibrateYOffsetViewController.h"
#import "IPExposureViewController.h"
#import "IPExposureButtonAreaView.h"
#import "IPButton.h"
#import "IPOptimizationViewController.h"


@interface IPOptimizationViewController ()

@property (nonatomic, strong) UIView *advancedSettingsView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *imageProcessed;

@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (strong) IPPhotoFrameView *photoFrameView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *controlContainer;

@property (nonatomic, strong) IPButton *filmSelectionButton;
@property (strong) UIView *filmTypeDisplayView;
@property (nonatomic, strong) IBOutlet UILabel *filmTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel *exposureTimeLabel;

@property (nonatomic, strong) UIButton *continueButton;

@property (nonatomic, strong) IBOutlet UISlider *contrastSlider;
@property (nonatomic, strong) IBOutlet UISlider *gammaSlider;
@property (nonatomic, strong) IBOutlet UISlider *hueSlider;

@property (nonatomic, strong) NSLayoutConstraint *advancedSettingsViewVerticalPosition;

@property (nonatomic, strong) NSNumberFormatter *decimalFormatter;

@property (strong, nonatomic) UITableView *filmSelectorTable;
@property (strong) NSLayoutConstraint *filmSelectorTableVerticalPosition;

@property (assign, nonatomic) BOOL filmSelectorTableHidden;
@property (assign, nonatomic) BOOL advancedSettingsViewHidden;

@property UITapGestureRecognizer *calibrateRecognizer;

@property NSOperationQueue *processingQueue;
@property BOOL opetationPending;

- (void)updateImageView;

- (IBAction)reset:(id)sender;
- (IBAction)processImage:(id)sender forEvent:(UIEvent *)event;

- (void)setFilmSelectorTableHidden:(BOOL)filmSelectorTableHidden
                          animated:(BOOL)animated
                        completion:(void (^)(BOOL finished))completion;
- (void)setAdvancedSettingsViewHidden:(BOOL)advancedSettingsViewHidden
                             animated:(BOOL)animated
                           completion:(void (^)(BOOL finished))completion;

@end


@implementation IPOptimizationViewController

#pragma mark Lifecycle

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _processingQueue  = [[NSOperationQueue alloc] init];
        
        [_processingQueue addObserver:self
                           forKeyPath:@"operationCount"
                              options:NSKeyValueObservingOptionNew
                              context:NULL];
        
        _decimalFormatter = [[NSNumberFormatter alloc] init];
        _decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
        _decimalFormatter.usesGroupingSeparator = NO;

        self.image = image;
        self.title = NSLocalizedString(@"Choose Film", @"Optimization View Controller title");
        
        self.navigationItem.rightBarButtonItem = [IPBarButtonItem barButtonItemForPosition:IPBarButtonItemPositionRight
                                                                                 withImage:[UIImage imageNamed:@"instantlab_icon-advanced_inactive"]
                                                                                  target:self
                                                                                selector:@selector(toggleAdvancedSettingsView:)];
    }
    return self;
}

- (void)dealloc;
{
    [_processingQueue removeObserver:self forKeyPath:@"operationCount"];
}

#pragma mark Accessors

- (void)setImageProcessed:(UIImage *)imageProcessed
{
    _imageProcessed = imageProcessed;
    [self updateImageView];
}

- (IPButton *)filmSelectionButton;
{
    if (_filmSelectionButton == nil) {
        _filmSelectionButton = [IPButton button];
        _filmSelectionButton.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.filmTypeDisplayView = [[NSBundle mainBundle] loadNibNamed:@"FilmTypeDisplay" owner:self options:nil][0];
        self.filmTypeDisplayView.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.filmTypeDisplayView contraintFromHeight];
        [self.filmTypeDisplayView contraintFromWidth];

        [_filmSelectionButton addConstraint:[NSLayoutConstraint constraintWithItem:self.filmTypeDisplayView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_filmSelectionButton
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0
                                                                          constant:0.0]];
        [_filmSelectionButton addConstraint:[NSLayoutConstraint constraintWithItem:self.filmTypeDisplayView
                                                                         attribute:NSLayoutAttributeCenterY
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:_filmSelectionButton
                                                                         attribute:NSLayoutAttributeCenterY
                                                                        multiplier:1.0
                                                                          constant:0.0]];

        [_filmSelectionButton addSubview:self.filmTypeDisplayView];
        
        [_filmSelectionButton addTarget:self
                                 action:@selector(toggleFilmSelectorTable:)
                       forControlEvents:UIControlEventTouchUpInside];
        
        self.filmTypeLabel.font = [UIFont ip_boldFontOfSize:14.0];
        self.exposureTimeLabel.font = [UIFont ip_boldFontOfSize:14.0];
    }
    
    return _filmSelectionButton;
}

#pragma mark UIViewController

- (void)viewWillAppear:(BOOL)animated;
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateFilmTypeLabel:)
                                                 name:IPFilmTypeControllerFilmTypeDidChangeNotification
                                               object:nil];
    [self updateFilmTypeLabel:nil];
    
    [self.navigationController.navigationBar addGestureRecognizer:self.calibrateRecognizer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:IPFilmPickerWasShownDefaultsKey] == NO) {
        [self setFilmSelectorTableHidden:NO animated:YES completion:^(BOOL finished) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:IPFilmPickerWasShownDefaultsKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IPFilmTypeControllerFilmTypeDidChangeNotification
                                                  object:nil];
    
    [self.navigationController.navigationBar removeGestureRecognizer:self.calibrateRecognizer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak typeof(self) blockSelf = self;
    
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    self.calibrateRecognizer = [UITapGestureRecognizer recognizerWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [blockSelf.navigationController pushViewController:[[IPCalibrateYOffsetViewController alloc] initWithNibName:nil bundle:nil]
                                                  animated:YES];
    }];
    self.calibrateRecognizer.numberOfTapsRequired = 2;

    self.photoFrameView = [[IPPhotoFrameView alloc] initWithStyle:IPPhotoViewStyleOpaqueBar];
    self.photoFrameView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.photoFrameView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.photoFrameView.contentView = self.imageView;

//    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//    self.spinner.hidesWhenStopped = YES;
//    [self.spinner stopAnimating];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
    
    self.advancedSettingsView = [[NSBundle mainBundle] loadNibNamed:@"ImageSettingsPanel" owner:self options:nil][0];
    [self.advancedSettingsView contraintFromWidth];
    [self.advancedSettingsView contraintFromHeight];
    [self.advancedSettingsView ip_fixLabelFonts];
    self.advancedSettingsView.translatesAutoresizingMaskIntoConstraints = NO;
    self.advancedSettingsView.alpha = 0.0;
    [self.view addSubview:self.advancedSettingsView];
    
    self.controlContainer = [[IPExposureButtonAreaView alloc] initWithFrame:self.view.bounds];
    self.controlContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.controlContainer];
    
    [self.controlContainer addSubview:self.filmSelectionButton];
    
    [self setupFilmSelectorTable];
    
    self.continueButton = [IPButton button];
    self.continueButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.continueButton setImage:[UIImage imageNamed:@"instantlab_icon-accept_inactive"]
                                 forState:UIControlStateNormal];
    [self.continueButton addTarget:self
                                    action:@selector(next:)
                          forControlEvents:UIControlEventTouchUpInside];
    [self.controlContainer addSubview:self.continueButton];
    
    
    [self updateImageView];
    
    

    // layout main views
    [self.view nx_addVisualConstraints:(@[
                                        @"H:|[photoFrameView]|",
                                        @"H:|[buttonContainer]|",
                                        @"V:|[photoFrameView][buttonContainer]|"])
                                 views:(@{
                                        @"photoFrameView" : self.photoFrameView,
                                        @"buttonContainer" : self.controlContainer})];
    
    // layout buttons
    [self.view nx_addVisualConstraints:(@[
                                        @"H:|[filmSelectionButton][continueButton]|",
                                        @"V:|[filmSelectionButton]|",
                                        @"V:|[continueButton]|"])
                                 views:(@{
                                        @"filmSelectionButton": self.filmSelectionButton,
                                        @"continueButton": self.continueButton})];
    
    [self.continueButton addConstraintWhere:[self.continueButton constraintItemAttribute:NSLayoutAttributeWidth]
                            shouldBeEqualTo:[self.continueButton constraintItemAttribute:NSLayoutAttributeHeight]];
    

    // advanced settings
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[advancedSettings]|"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:0
                                                                        views:@{@"advancedSettings": self.advancedSettingsView}]];
    
    self.advancedSettingsViewHidden = YES;
    
    [@[self.contrastSlider, self.gammaSlider, self.hueSlider] each:^(UISlider *slider) {
        slider.minimumValue = -1.0;
        slider.maximumValue = 1.0;
        slider.value = 0.0;
        slider.continuous = YES;
        [slider addTarget:self action:@selector(processImage:forEvent:) forControlEvents:UIControlEventValueChanged | UIControlEventTouchDown];
    }];

    [self processImage:nil forEvent:nil];
}

#pragma mark IPExposureFlowViewController

- (CGRect)continueImageViewFrame;
{
    return self.imageView.frame;
}

- (UIImage *)continueImage;
{
    if (self.imageProcessed) return self.imageProcessed;

    return self.image;
}


#pragma mark UITableViewDataSource, UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [IPFilmTypeController sharedController].filmOptions.count;
    } else if (section == 1) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"instantlab_screen4c_film-background_inactive"]];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"instantlab_screen4c_film-background_active"]];
        cell.textLabel.backgroundColor = cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = cell.detailTextLabel.font = [UIFont ip_boldFontOfSize:18.0];
    }

    NSString *label = nil;
    double exposureTimeInSeconds = 0;
    BOOL selected = NO;
    
    if (indexPath.section == 0) {
        NSDictionary *film = [IPFilmTypeController sharedController].filmOptions[indexPath.row];
        
        label = film[IPSelectedInstaLabFilmLocalizedNameKey];
        exposureTimeInSeconds = [film[IPSelectedInstaLabFilmExposureKey] doubleValue];
        
        selected = ([IPFilmTypeController sharedController].selectedFilm == film);
        
    } else if (indexPath.section == 1) {
        label = NSLocalizedString(@"Custom", @"Custom exposure time menu entry");

        exposureTimeInSeconds = [IPFilmTypeController sharedController].customExposureTime;
    }
    
    cell.textLabel.text = label;
    if (exposureTimeInSeconds == 0) {
        cell.detailTextLabel.text = nil;
    } else {
        NSString *seconds = [self.decimalFormatter stringFromNumber:@(exposureTimeInSeconds * 1000.0)];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ms", seconds];
    }
    
    if (selected) {
        cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor ip_selectedTextColor];
    } else {
        cell.textLabel.textColor = cell.detailTextLabel.textColor = [UIColor ip_textColor];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSDictionary *film = [IPFilmTypeController sharedController].filmOptions[indexPath.row];
        
        // remove custom exposure time on selecting a real exposure time
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:IPInstaLabDebugCustomExposureTimeDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults] setObject:film[IPSelectedInstaLabFilmIdentifierKey]
                                                  forKey:IPSelectedInstaLabFilmDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [IPFilmTypeController sharedController].selectedFilm = film;
        
        [self setFilmSelectorTableHidden:YES animated:YES completion:nil];
        
        [tableView reloadData];
        
    } else if (indexPath.section == 1) {
        
        UIAlertView *alertView = [[WCAlertView alloc] initWithTitle:NSLocalizedString(@"Custom Exposure Time", nil)
                                                            message:NSLocalizedString(@"Input the exposure time in miliseconds", nil)
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                                  otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *inputField = [alertView textFieldAtIndex:0];
        inputField.keyboardType = UIKeyboardTypeNumberPad;
        
        if ([IPFilmTypeController sharedController].customExposureTime) {
            inputField.text = [self.decimalFormatter stringFromNumber:@([IPFilmTypeController sharedController].customExposureTime * 1000.0)];
        }
        [alertView show];
        
        [tableView reloadData];
    }
}


#pragma mark UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (buttonIndex == alertView.cancelButtonIndex) return;
    
    NSString *text = [[alertView textFieldAtIndex:0] text];
    NSNumberFormatter *decimalFormater = [[NSNumberFormatter alloc] init];
    decimalFormater.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *milliSeconds = [decimalFormater numberFromString:text];
    
    if (!milliSeconds) {
        double delayInSeconds = .5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [[[WCAlertView alloc] initWithTitle:NSLocalizedString(@"Invalid Exposure Time", nil)
                                        message:[NSString stringWithFormat:NSLocalizedString(@"%@ is not a valid exposure time", nil), text]
                                       delegate:nil
                              cancelButtonTitle:NSLocalizedString(@"Dismiss", nil)
                              otherButtonTitles: nil] show];
        });
        
        return;
    }
    
    [IPFilmTypeController sharedController].customExposureTime = milliSeconds.doubleValue / 1000.0;
    
    [self setFilmSelectorTableHidden:YES animated:YES completion:nil];
}


#pragma mark Helper

- (void)setupFilmSelectorTable;
{
    self.filmSelectorTable = [[UITableView alloc] init];
    self.filmSelectorTable.translatesAutoresizingMaskIntoConstraints = NO;
    self.filmSelectorTable.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.filmSelectorTable.dataSource = self;
    self.filmSelectorTable.delegate = self;
    self.filmSelectorTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.filmSelectorTable.scrollEnabled = NO;
    
    [self.view insertSubview:self.filmSelectorTable belowSubview:self.controlContainer];
    
    NSDictionary *views = @{ @"filmSelectorTable": self.filmSelectorTable };
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.filmSelectorTable
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.filmTypeDisplayView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[filmSelectorTable(==188)]"
                                                                      options:0
                                                                      metrics:nil
                                                                        views:views]];

    [self.filmSelectorTable addConstraint:[NSLayoutConstraint constraintWithItem:self.filmSelectorTable
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:nil
                                                                       attribute:NSLayoutAttributeHeight
                                                                      multiplier:1.0
                                                                        constant:132.0]];

    self.filmSelectorTableHidden = YES;
}

- (void)toggleAdvancedSettingsView:(id)sender;
{
    [self setAdvancedSettingsViewHidden:!self.advancedSettingsViewHidden
                               animated:YES
                             completion:nil];
}

- (void)setAdvancedSettingsViewHidden:(BOOL)advancedSettingsViewHidden;
{
    [self setAdvancedSettingsViewHidden:advancedSettingsViewHidden
                               animated:NO
                             completion:nil];
}

- (void)setAdvancedSettingsViewHidden:(BOOL)advancedSettingsViewHidden animated:(BOOL)animated completion:(void (^)(BOOL))completion;
{
    if (advancedSettingsViewHidden == _advancedSettingsViewHidden) return;
    
    if (!advancedSettingsViewHidden && !self.filmSelectorTableHidden) {
        __weak typeof(self) blockSelf = self;
        [self setFilmSelectorTableHidden:YES
                                animated:animated
                              completion:^(BOOL finished) {
                                  [blockSelf setAdvancedSettingsViewHidden:advancedSettingsViewHidden
                                                                  animated:animated
                                                                completion:nil];
                              }];
        return;
    }
    
    _advancedSettingsViewHidden = advancedSettingsViewHidden;
    
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:(animated ? 0.2 : 0.0)
                     animations:^{
                         [self.view removeConstraint:self.advancedSettingsViewVerticalPosition];
                         
                         self.advancedSettingsViewVerticalPosition =
                              [NSLayoutConstraint constraintWhere:[self.advancedSettingsView constraintItemAttribute:(advancedSettingsViewHidden ? NSLayoutAttributeBottom : NSLayoutAttributeTop)]
                                                  shouldBeEqualTo:[self.photoFrameView constraintItemAttribute:NSLayoutAttributeTop]];
                         [self.view addConstraint:self.advancedSettingsViewVerticalPosition];
                         self.advancedSettingsView.alpha = (advancedSettingsViewHidden ? 0.0 : 1.0);
                         [self.view layoutIfNeeded];
                     } completion:^(BOOL finished) {
                         if (completion) {
                             completion(finished);
                         }
                     }];
}

- (void)toggleFilmSelectorTable:(id)sender;
{
    [self setFilmSelectorTableHidden:!self.filmSelectorTableHidden
                            animated:YES
                          completion:nil];
}

- (void)setFilmSelectorTableHidden:(BOOL)filmSelectorTableHidden;
{
    [self setFilmSelectorTableHidden:filmSelectorTableHidden
                            animated:NO
                          completion:nil];
}

- (void)setFilmSelectorTableHidden:(BOOL)filmSelectorTableHidden
                          animated:(BOOL)animated
                        completion:(void (^)(BOOL))completion;
{
    if (_filmSelectorTableHidden == filmSelectorTableHidden) return;
    
    if (!filmSelectorTableHidden && !self.advancedSettingsViewHidden) {
        __weak IPOptimizationViewController *blockSelf = self;
        [self setAdvancedSettingsViewHidden:YES
                                   animated:animated
                                 completion:^(BOOL finished) {
                                     [blockSelf setFilmSelectorTableHidden:filmSelectorTableHidden
                                                                  animated:animated
                                                                completion:nil];
                                 }];
        return;
    }
    
    _filmSelectorTableHidden = filmSelectorTableHidden;
    
    [self.view layoutIfNeeded];

    [UIView animateWithDuration:(animated ? 0.2 : 0.0)
                     animations:^{
                         [self.view removeConstraint:self.filmSelectorTableVerticalPosition];
                         self.filmSelectorTableVerticalPosition = [NSLayoutConstraint constraintWithItem:self.filmSelectorTable
                                                                                               attribute:(filmSelectorTableHidden ? NSLayoutAttributeTop : NSLayoutAttributeBottom)
                                                                                               relatedBy:NSLayoutRelationEqual
                                                                                                  toItem:self.controlContainer
                                                                                               attribute:NSLayoutAttributeTop
                                                                                              multiplier:1.0
                                                                                                constant:0.0];
                         [self.view addConstraint:self.filmSelectorTableVerticalPosition];
                         [self.view layoutIfNeeded];
                         self.filmSelectorTable.alpha = (filmSelectorTableHidden ? 0.0 : 1.0);
                     } completion:^(BOOL finished) {
                         if (completion) {
                             completion(finished);
                         }
                     }];
}

- (void)reset:(id)sender;
{
    self.contrastSlider.value = 0.0;
    self.gammaSlider.value = 0.0;
    self.hueSlider.value = 0.0;
    self.imageProcessed = nil;
}

- (void)updateImageView
{
    self.imageView.image = self.imageProcessed ?: self.image;
}

- (IBAction)processImage:(UISlider *)sender forEvent:(UIEvent *)event;
{
    [self processImage];
}

- (void)processImage;
{
    // remove all operations that have not been started
    [self.processingQueue cancelAllOperations];
    
    // only put on operation onto the queue at a time
    if (self.processingQueue.operationCount > 0) {
        self.opetationPending = YES;
        return;
    }
        
    float contrastAdjust = self.contrastSlider.value;
    float gammaAdjust = self.gammaSlider.value;
    float hueAdjust = self.hueSlider.value;
    
    // start processing
    [self.processingQueue addOperationWithBlock:^{
        
        CIContext *context = [CIContext contextWithOptions:nil];
        
        CIImage *image = [[CIImage alloc] initWithImage:self.image];
        
        NSMutableArray *filters = [NSMutableArray array];
        // disabling auto correct. uncomment the following line to reenable it
        // [filters addObjectsFromArray:[image autoAdjustmentFiltersWithOptions:@{kCIImageAutoAdjustEnhance:@(YES)}]];
        [filters addObject:[self contrastFilter:contrastAdjust]];
        [filters addObject:[self gammaFilter:gammaAdjust]];
        [filters addObject:[self hueFilter:hueAdjust]];
        
        for (CIFilter *filter in filters){
            [filter setValue:image forKey:kCIInputImageKey];
            image = filter.outputImage;
        }
        
        CGImageRef cgImage = [context createCGImage:image
                                           fromRect:image.extent];
        UIImage *resultUIImage = [UIImage imageWithCGImage:cgImage];
        CGImageRelease(cgImage);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageProcessed = resultUIImage;
            [self updateImageView];
        });
    }];

}

- (void)updateFilmTypeLabel:(NSNotification *)notification;
{
    NSDictionary *selectedFilm = [IPFilmTypeController sharedController].selectedFilm;
    NSString *label;
    if (selectedFilm != nil) {
        label = selectedFilm[IPSelectedInstaLabFilmLocalizedNameKey];
    } else {
        label = [IPFilmTypeController sharedController].customExposureTimeLabel;
    }
    
    self.filmTypeLabel.text = label;
    NSString *seconds = [self.decimalFormatter stringFromNumber:@([IPFilmTypeController sharedController].selectedExposureTime * 1000.0)];
    self.exposureTimeLabel.text = [NSString stringWithFormat:@"%@ ms", seconds];
    
    [self.filmSelectorTable reloadData];
}

#pragma mark Actions

- (IBAction)next:(id)sender;
{
    UIImage *image = self.imageProcessed;
    if (!image) image = self.image;
    
    IPExposureViewController *exposureViewController = [[IPExposureViewController alloc] initWithImage:image
                                                                                          exposureTime:[IPFilmTypeController sharedController].selectedExposureTime
                                                                                        filmIdentifier:[IPFilmTypeController sharedController].selectedFilmIdentifier];
    [self.navigationController pushViewController:exposureViewController animated:YES];
}

#pragma mark Filters
// all input adjustments are on a scale of -1 to +1

- (CIFilter *)contrastFilter:(float)contrastAdjust;
{
    contrastAdjust = (1 + contrastAdjust);
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setDefaults];
    [filter setValue:@(contrastAdjust) forKey:@"inputContrast"];
    return  filter;
}

- (CIFilter *)gammaFilter:(float)gammaAdjust;
{
    // min is 0
    float gammaNormal = 1.0;
    float gammaMax = 5;
    float gammaMultiplicator = gammaNormal;
    if (gammaAdjust > 0) {
        gammaMultiplicator = (gammaMax / gammaNormal) - 1 - gammaNormal;
    }
    
    gammaAdjust = gammaNormal + (gammaAdjust * gammaMultiplicator);
    CIFilter *filter = [CIFilter filterWithName:@"CIGammaAdjust"];
    [filter setDefaults];
    [filter setValue:@(gammaAdjust) forKey:@"inputPower"];
    return  filter;
}

- (CIFilter *)hueFilter:(float)hueAdjust;
{
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"];
    [filter setDefaults];
    [filter setValue:@(M_PI * hueAdjust) forKey:@"inputAngle"];
    return filter;
}

#pragma mark KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
{
    if (object == self.processingQueue && self.isViewLoaded) {
        NSNumber *newValue = change[NSKeyValueChangeNewKey];
        double delayInSeconds = 0.2;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            if (newValue.integerValue == 0) {
                if (self.opetationPending) {
                    self.opetationPending = NO;
                    [self processImage];
                }
                [self.spinner stopAnimating];
            } else {
                [self.spinner startAnimating];
            }
        });
    }
}

@end
