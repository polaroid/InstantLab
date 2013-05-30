//
//  IPDemoViewController.m
//  IPInstantLab
//
//  Created by Tobias Kräntzer on 28.05.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import "IPInstantLab.h"

#import "IPDemoViewController.h"

@implementation IPDemoViewController

- (IBAction)cropAndExpose:(id)sender
{
    [IPInstantLab presentInstantLabWithImage:[UIImage imageNamed:@"test.jpg"]];
}

- (IBAction)expose:(id)sender
{
    [IPInstantLab presentInstantLabWithImage:[UIImage imageNamed:@"test.jpg"] skipCropping:YES];
}

@end
