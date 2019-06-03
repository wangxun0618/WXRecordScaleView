//
//  WXTimeRulerView.h
//  WXRecordScaleView
//
//  Created by xun on 2019/5/23.
//  Copyright © 2019 Antler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXAxisShapeLayer.h"

NS_ASSUME_NONNULL_BEGIN



@interface WXTimeRulerView : UIControl

@property (nonatomic, assign) int currentTime;
@property (nonatomic, strong) WXAxisShapeLayer *rulerLayer;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) CGFloat rulerWidth;
@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, assign) CGFloat startScale;
@property (nonatomic, assign) BOOL isTouch;
@property (nonatomic, assign) CGFloat oldRulerWidth;

- (void)setSelectedRanges:(NSArray<NSDictionary *> *)ranges;

@end

NS_ASSUME_NONNULL_END
