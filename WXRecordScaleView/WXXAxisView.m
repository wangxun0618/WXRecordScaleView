//
//  WXXAxisView.m
//  WXRecordScaleView
//
//  Created by xun on 2017/8/24.
//  Copyright © 2017年 Antler. All rights reserved.
//

#import "WXXAxisView.h"

#define lTopMargin 10   // 长刻度顶部留出的空白
#define sTopMargin 20   // 短刻度顶部留出的空白

#define kLineColor         [UIColor grayColor]
#define kTextColor         [UIColor whiteColor]

@interface WXXAxisView ()

@property (assign, nonatomic) CGRect firstFrame;//记录坐标轴的第一个frame

@property (assign, nonatomic) float  dialNumber;//刻度数目

@end


@implementation WXXAxisView

- (id)initWithFrame:(CGRect)frame defaultGap:(CGFloat)gap timeInterval:(NSTimeInterval)timeInterval {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1.0f];
        _dialNumber = 24*60/timeInterval+1;
        _pointGap = gap;
        _timeInterval = timeInterval;
    }
    return self;
}

//设置缩放间隔
- (void)setPointGap:(CGFloat)pointGap {
    _pointGap = pointGap;
    [self setNeedsDisplay];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    _timeInterval = timeInterval;
    [self setNeedsDisplay];
}

//设置录像片段时间轴
- (void)setRecordTimes:(NSArray *)recordTimes
{
    _recordTimes = recordTimes;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawRecordFootage:context];
    [self drawTimeLine:context];
    
}

#pragma mark ---绘制有录像片段
- (void)drawRecordFootage:(CGContextRef)context
{
    if (self.recordTimes.count > 0) {
        for (NSDictionary *dict in _recordTimes) {
            
            double recordTimeStart = [dict[@"from"] doubleValue];
            double recordTimeEnd   = [dict[@"to"] doubleValue];
            NSDate *currentDate    = [NSDate dateWithTimeIntervalSince1970:recordTimeStart] ;
            NSDate *startDate      = [currentDate dateAtStartOfDay];
            NSTimeInterval startX  = [currentDate timeIntervalSinceDate:startDate] / 60 * _pointGap / _timeInterval + _pointGap + leftMargin;
            double width           = (recordTimeEnd-recordTimeStart) /60 * _pointGap / _timeInterval;
            
            [self drawLine:context
                startPoint:CGPointMake(startX + width/2, 0)
                  endPoint:CGPointMake(startX + width/2, self.frame.size.height)
                 lineColor:[[UIColor greenColor] colorWithAlphaComponent:.5]
                 lineWidth:width];
        }
    }
}

#pragma mark ---绘制时间轴
- (void)drawTimeLine:(CGContextRef)context
{
    // 添加坐标轴Label
    for (int i = 0; i < _dialNumber; i++) {
        
        NSString *title    = [self computationTime:i];
        NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:8]};
        CGSize labelSize   = [title sizeWithAttributes:attr];
        CGRect titleRect   = CGRectMake((i + 1) * self.pointGap - labelSize.width / 2 + leftMargin,self.frame.size.height - labelSize.height,labelSize.width,labelSize.height);
        
        //缩放判断
        if (self.pointGap <= 10 && (i % 2 == 1)) {
            
            continue;
            
        } else if (self.pointGap <= 5 && i % 2 == 0){
            
            if ( (i/2) % 2 == 1) continue;
            
        }
        
        if (i == 0) {
            
            [title drawInRect:titleRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kTextColor}];
            
            //画垂直X轴的竖线
            [self drawLine:context
                startPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, lTopMargin)
                  endPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, self.frame.size.height - labelSize.height-5)
                 lineColor:kLineColor
                 lineWidth:1];
        }
        
        if (i != 0) {
            
            if (i % 5 == 0) {
                [title drawInRect:titleRect withAttributes:@{NSFontAttributeName :[UIFont systemFontOfSize:8],NSForegroundColorAttributeName:kTextColor}];
                
                [self drawLine:context
                    startPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, lTopMargin)
                      endPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, self.frame.size.height - labelSize.height-5)
                     lineColor:kLineColor
                     lineWidth:1];
            } else {
                [self drawLine:context
                    startPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, sTopMargin)
                      endPoint:CGPointMake(titleRect.origin.x+labelSize.width/2, self.frame.size.height - labelSize.height-10)
                     lineColor:kLineColor
                     lineWidth:1];
            }
            //画垂直X轴的竖线
            self.firstFrame = titleRect;
            
        } else {
            if (self.firstFrame.origin.x < 0) {
                
                CGRect frame = self.firstFrame;
                frame.origin.x = 0;
                self.firstFrame = frame;
            }
        }
    }
}

#pragma mark ---绘制线条
- (void)drawLine:(CGContextRef)context
      startPoint:(CGPoint)startPoint
        endPoint:(CGPoint)endPoint
       lineColor:(UIColor *)lineColor
       lineWidth:(CGFloat)width {
    
    CGContextSetShouldAntialias(context, YES ); //抗锯齿
    CGColorSpaceRef Linecolorspace1 = CGColorSpaceCreateDeviceRGB();
    CGContextSetStrokeColorSpace(context, Linecolorspace1);
    CGContextSetLineWidth(context, width);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
    CGContextStrokePath(context);
    CGColorSpaceRelease(Linecolorspace1);
    
}

#pragma mark ---计算时间
- (NSString *)computationTime:(NSInteger)row
{
    int time = (int)row * _timeInterval;//总分
    int hour = time/60;
    int minute = time%60;
    return [NSString stringWithFormat:@"%.2d:%.2d",hour,minute];
}

@end



@implementation NSDate(Category)

- (NSDate *) dateAtStartOfDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:self];
    NSDate *startDate = [calendar dateFromComponents:components];
    //    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    return startDate;
}
@end
