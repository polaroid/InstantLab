//
//  IPNavigationController.m
//  Impossible
//
//  Created by Ullrich Schäfer on 25.03.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import "IPBarButtonItem.h"
#import "IPNavigationController.h"


@implementation IPNavigationController

#pragma mark Lifecycle

- (id)initWithRootViewController:(UIViewController *)rootViewController;
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.delegate = self;
    }
    return self;
}

- (void)viewDidLoad;
{
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationBar.clipsToBounds = YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated;
{
    viewController.title = [viewController.title uppercaseString];
    
    if (self.viewControllers.count > 1 &&
        [viewController.navigationItem.leftBarButtonItem isKindOfClass:[IPBarButtonItem class]] == NO) {
        
        __weak typeof(self) blockSelf = self;
        viewController.navigationItem.leftBarButtonItem = [IPBarButtonItem barButtonItemForPosition:IPBarButtonItemPositionLeft
                                                                                          withImage:[UIImage imageNamed:@"instantlab_icon-back_inactive"]
                                                                                            handler:^(id sender) {
                                                                                                [blockSelf popViewControllerAnimated:YES];
                                                                                            }];
    }
}

@end
