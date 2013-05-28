//
//  IPDemoViewController.m
//  IPInstantLab
//
//  Created by Tobias Kräntzer on 28.05.13.
//  Copyright (c) 2013 nxtbgthng GmbH. All rights reserved.
//

#import "IPInstantLab.h"

#import "IPDemoViewController.h"

@implementation IPDemoViewController

- (IBAction)expose:(id)sender
{
    [IPInstantLab presentInstantLabWithImage:[UIImage imageNamed:@"test.jpg"]];
}

@end
