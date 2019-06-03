//
//  WXAxisShapeLayer.h
//  WXRecordScaleView
//
//  Created by xun on 2019/5/23.
//  Copyright © 2019 Antler. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

// 侧边多出部分宽度 默认 30.0
#define sideOffset 30.0
// 刻度尺最大宽度 默认 10800.0
#define rulerMaxWidth 10800.0

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    WXRulerFrequencyTypeHour = 3600,  //小时标记频率3600秒
    WXRulerFrequencyTypeMinute10 = 600, //10分钟标记频率
    WXRulerFrequencyTypeMinute2 = 120, //2分钟标记评率
} WXRulerFrequencyType;

@interface WXTimeRulerMark : NSObject

@property (nonatomic, assign) WXRulerFrequencyType frequencyType;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@end

@interface WXAxisShapeLayer : CAShapeLayer

@property (nonatomic, strong) NSArray<NSDictionary *> *selectedRange;

@end

NS_ASSUME_NONNULL_END
