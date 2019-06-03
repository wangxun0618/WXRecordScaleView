//
//  WXTimeRulerView.m
//  WXRecordScaleView
//
//  Created by xun on 2019/5/23.
//  Copyright © 2019 Antler. All rights reserved.
//

#import "WXTimeRulerView.h"

@interface WXTimeRulerView() <UIScrollViewDelegate>

@end

@implementation WXTimeRulerView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultValue];
        [self setupUI];
    }
    return self;
}

- (void)defaultValue {
    _currentTime = 0;
    _isTouch = NO;
    _oldRulerWidth = 0;
    self.rulerWidth = 6.0 * self.bounds.size.width;
}

- (void)setupUI {
    [self topLineView];
    [self bottomLineView];
    [self scrollView];
    [self rulerLayer];
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchActionWithRecoginer:)];
    [self addGestureRecognizer:pinch];
}

- (void)pinchActionWithRecoginer:(UIPinchGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        _startScale = sender.scale;
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        [self updateFrameWithScale:sender.scale / _startScale];
        _startScale = sender.scale;
    }
}

- (void)updateFrameWithScale:(CGFloat)scale {
    CGFloat updateRulerWidth = _rulerLayer.bounds.size.width * scale;
    if (updateRulerWidth < self.bounds.size.width + 2 * sideOffset) {
        updateRulerWidth = self.bounds.size.width + 2 *sideOffset;
    }
    
    if (updateRulerWidth > rulerMaxWidth) {
        updateRulerWidth = rulerMaxWidth;
    }
    _oldRulerWidth = _rulerWidth;
    _rulerWidth = updateRulerWidth;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat sideInset = self.bounds.size.width /2.0;
    self.scrollView.frame = self.bounds;
    self.scrollView.contentInset = UIEdgeInsetsMake(0, sideInset - sideOffset, 0, sideInset - sideOffset);
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _rulerLayer.frame = CGRectMake(0, 0, _rulerWidth, self.bounds.size.height);
    [CATransaction commit];
    
    _scrollView.contentSize = CGSizeMake(_rulerWidth, self.bounds.size.height);
    
    _topLineView.frame = CGRectMake(0, 0, self.bounds.size.width, 1.0);
    _bottomLineView.frame = CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 1.0);
    self.scrollView.contentOffset = [self contentOffsetWithCurrentTime:_currentTime];
}

- (CGPoint)contentOffsetWithCurrentTime:(int)currentTime {
    CGFloat proportion = currentTime / (24 * 3600.0);
    CGFloat proportionWidth = (_scrollView.contentSize.width - sideOffset * 2) * proportion;
    return CGPointMake(proportionWidth - _scrollView.contentInset.left, _scrollView.contentOffset.y);
}

#pragma mark: --------UIScrollViewDelegate-------
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isTouch = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat proportionWidth = scrollView.contentOffset.x + scrollView.contentInset.left;
    CGFloat proportion = proportionWidth / (scrollView.contentSize.width - sideOffset * 2);
    int value = ceil(proportion * 24 * 3600);
    _currentTime = value;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isTouch = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        _isTouch = NO;
    }
}

- (void)setSelectedRanges:(NSArray<NSDictionary *> *)ranges {
    self.rulerLayer.selectedRange = ranges;
}


// 懒加载
- (UIView *)topLineView {
    if (!_topLineView) {
        _topLineView = [[UIView alloc] init];
        _topLineView.backgroundColor = [UIColor colorWithWhite:0.78 alpha:1.0];
        [self addSubview:_topLineView];
    }
    return _topLineView;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor colorWithWhite:0.78 alpha:1.0];
        [self addSubview:_bottomLineView];
    }
    return _bottomLineView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame: self.bounds];
        _scrollView.delegate = self;
        _scrollView.pinchGestureRecognizer.enabled = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (WXAxisShapeLayer *)rulerLayer {
    if (!_rulerLayer) {
        _rulerLayer = [[WXAxisShapeLayer alloc] init];
        [self.scrollView.layer addSublayer:_rulerLayer];
    }
    return _rulerLayer;
}

@end
