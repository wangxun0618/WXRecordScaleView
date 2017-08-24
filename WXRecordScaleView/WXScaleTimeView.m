//
//  WXScaleTimeView.m
//  WXRecordScaleView
//
//  Created by xun on 2017/8/24.
//  Copyright © 2017年 Antler. All rights reserved.
//

#import "WXScaleTimeView.h"
#import "WXXAxisView.h"

@interface WXScaleTimeView ()

@property (nonatomic, strong) WXXAxisView  *xAxisView;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, assign) CGFloat      pointGap;

@property (nonatomic, assign) CGFloat      dialNumber;//刻度数目

@end

@implementation WXScaleTimeView

- (instancetype)initWithFrame:(CGRect)frame timeInterval:(NSTimeInterval)timeInterval
{
    if (self = [super initWithFrame:frame]) {
        
        _dialNumber = 24*60/timeInterval+1;
        
        _maxGap = 15;
        _minGap = 2;
        _pointGap = _maxGap;
        _timeInterval = timeInterval;
        
        [self creatLineXView];
        self.mainScrollView.backgroundColor = [UIColor blackColor];
        //2. 捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
        [self.xAxisView addGestureRecognizer:pinch];
        
    }
    return self;
}


#pragma mark ---加载ScrollView
- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.delegate = self;
        _mainScrollView.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1.0f];
        _mainScrollView.bounces = NO;
        [self insertSubview:_mainScrollView atIndex:0];
        _mainScrollView.contentInset = UIEdgeInsetsMake(0, -_pointGap, 0, 0);
    }
    return _mainScrollView;
}

- (WXXAxisView *)xAxisView
{
    if (!_xAxisView) {
        
        _xAxisView = [[WXXAxisView alloc] initWithFrame:CGRectMake(0, 0, _dialNumber * _pointGap + leftMargin + rightMargin, self.frame.size.height)
                                             defaultGap:_maxGap
                                           timeInterval:_timeInterval];
        
        [_mainScrollView addSubview:_xAxisView];
        
        _mainScrollView.contentSize = _xAxisView.frame.size;
        
    }
    return _xAxisView;
}

#pragma mark ---绘制中间红色线条
- (void)creatLineXView {
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2, 0, 1, self.frame.size.height)];
    line.backgroundColor = [UIColor redColor];
    [self addSubview:line];
}

#pragma mark ---捏合手势监听方法
- (void)pinchGesture:(UIPinchGestureRecognizer *)recognizer
{
    if (recognizer.state == 3) {
        
    } else {
        
        CGFloat currentIndex,leftMagin;
        if( recognizer.numberOfTouches == 2 ) {
            
            CGFloat centerX = self.mainScrollView.contentOffset.x;
            
            leftMagin = centerX - self.mainScrollView.contentOffset.x;
            
            currentIndex = centerX / self.pointGap;
            
            self.pointGap *= recognizer.scale;
            self.pointGap = self.pointGap > _maxGap ? _maxGap : self.pointGap; //判断放至最大
            self.pointGap = self.pointGap <= _minGap ? _minGap : self.pointGap;
            
            if (self.pointGap == _maxGap) {
                NSLog(@"已经放至最大");
            }
            if (self.pointGap == _minGap) {
                NSLog(@"已经放至最小");
            }
            
            self.xAxisView.pointGap = self.pointGap;
            recognizer.scale = 1.0;
            
            self.xAxisView.frame = CGRectMake(0, 0, _dialNumber * self.pointGap + leftMargin + rightMargin, self.frame.size.height);
            
            self.mainScrollView.contentOffset = CGPointMake(currentIndex*self.pointGap - leftMagin, 0);
        }
    }
    self.mainScrollView.contentSize = CGSizeMake(self.xAxisView.frame.size.width, 0);
    self.mainScrollView.contentInset = UIEdgeInsetsMake(0, -self.pointGap, 0, 0);
    
}

- (void)setRecordTimes:(NSArray *)recordTimes
{
    _recordTimes = recordTimes;
    _xAxisView.recordTimes = recordTimes;
}

#pragma mark --- UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        
        float currentNum = (scrollView.contentOffset.x - self.pointGap) / self.pointGap;
        NSTimeInterval interval = currentNum * _timeInterval * 60;
        if (self.currentVlaueBlock) {
            self.currentVlaueBlock(interval);
        }
    }
}

#pragma mark --- Call-Back Block

- (void)scrollViewCurrentValueBlock:(void(^)(double value))valueBlock
{
    if (valueBlock) {
        self.currentVlaueBlock = valueBlock;
    }
}

@end
