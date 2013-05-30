//
//  IPPhotoView.h
//  IPInstantLab
//
//  Created by Max Winde on 24.04.13.
//  Copyright (c) 2013 Impossible GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    IPPhotoViewStyleNoBar,
    IPPhotoViewStyleTransparentBar,
    IPPhotoViewStyleOpaqueBar
} IPPhotoViewStyle;


@interface IPPhotoFrameView : UIView

- (id)initWithStyle:(IPPhotoViewStyle)style;

@property (assign, nonatomic) IPPhotoViewStyle style;
@property (strong, nonatomic) UIView *contentView;

@property (nonatomic, readonly) CGFloat barHeight;

@end
