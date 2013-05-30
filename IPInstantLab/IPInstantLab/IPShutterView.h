//
//  IPShutterView.h
//  IPInstantLab
//
//  Created by Ullrich Schäfer on 24.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IPShutterCompletionBlock)();

@interface IPShutterView : UIView

@property (readonly, getter=isShut) BOOL shut;

- (void)closeShutterWithCompletionBlock:(IPShutterCompletionBlock)finishBlock;    // 0.05s
- (void)openShutterWithCompletionBlock:(IPShutterCompletionBlock)finishBlock; // 0.2s

@end
