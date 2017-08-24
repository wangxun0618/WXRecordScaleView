//
//  WXXAxisView.h
//  WXRecordScaleView
//
//  Created by xun on 2017/8/24.
//  Copyright © 2017年 Antler. All rights reserved.
//

#import <UIKit/UIKit.h>

#define rightMargin [UIScreen mainScreen].bounds.size.width /2
#define leftMargin [UIScreen mainScreen].bounds.size.width /2

@interface NSDate (Category)

- (NSDate *)dateAtStartOfDay;

@end

@interface WXXAxisView : UIView

@property (assign, nonatomic) CGFloat        pointGap;//点之间的距离

@property (nonatomic, assign) NSTimeInterval timeInterval;//刻度与刻度之间时间间隔 单位：min

@property (strong, nonatomic) NSArray        *recordTimes;//标记有数据的时间点 格式要是 [@{@"from":时间戳, @"to":时间戳},@{@"from":时间戳, @"to":时间戳}]

- (id)initWithFrame:(CGRect)frame
         defaultGap:(CGFloat)gap
       timeInterval:(NSTimeInterval)timeInterval;

@end
