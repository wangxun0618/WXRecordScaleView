//
//  WXScaleTimeView.h
//  WXRecordScaleView
//
//  Created by xun on 2017/8/24.
//  Copyright © 2017年 Antler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WXScaleTimeView : UIView <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat        maxGap;//两个刻度之间最大间距

@property (nonatomic, assign) CGFloat        minGap;//两个刻度之间最小间距

@property (nonatomic, assign) NSTimeInterval timeInterval;//时间间隔 单位：min

@property (nonatomic, copy  ) NSArray        *recordTimes;//录像片段数组

@property (nonatomic, strong) void(^currentVlaueBlock)(double value);

- (instancetype)initWithFrame:(CGRect)frame timeInterval:(NSTimeInterval)timeInterval;

- (void)scrollViewCurrentValueBlock:(void(^)(double value))valueBlock; //单位：s


@end
