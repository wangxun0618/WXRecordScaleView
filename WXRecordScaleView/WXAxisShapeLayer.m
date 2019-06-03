//
//  WXAxisShapeLayer.m
//  WXRecordScaleView
//
//  Created by xun on 2019/5/23.
//  Copyright © 2019 Antler. All rights reserved.
//

#import "WXAxisShapeLayer.h"

@implementation WXTimeRulerMark

- (instancetype)init {
    if (self = [super init]) {
        self.font = [UIFont systemFontOfSize:9.0];
        self.color = [UIColor colorWithWhite:0.78 alpha:1];
        self.textColor = [UIColor colorWithWhite:0.43 alpha:1];
    }
    return self;
}

@end


@interface WXAxisShapeLayer()

@property (nonatomic, strong) WXTimeRulerMark *minorMark;
@property (nonatomic, strong) WXTimeRulerMark *middleMark;
@property (nonatomic, strong) WXTimeRulerMark *majorMark;

@end

@implementation WXAxisShapeLayer


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColor.clearColor.CGColor;
    }
    return self;
}

- (void)display {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self drawToImage];
    [CATransaction commit];
}

- (void)setSelectedRange:(NSArray<NSDictionary *> *)selectedRange {
    _selectedRange = selectedRange;
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame {
    super.frame = frame;
    [self setNeedsDisplay];
}

- (void)drawToImage {
    CGFloat boundsW = self.bounds.size.width;
    CGFloat boundsH = self.bounds.size.height;
    WXRulerFrequencyType frequencyType = WXRulerFrequencyTypeMinute10;
    
    //每小时占用的宽度
    CGFloat hourWidth = (boundsW - sideOffset * 2) / 24.0;
    
    if (hourWidth / 30.0 >= 8.0) {
        frequencyType = WXRulerFrequencyTypeMinute2;
    }
    else if (hourWidth / 6.0 >= 50) {
        frequencyType = WXRulerFrequencyTypeMinute10;
    }
    else {
        frequencyType = WXRulerFrequencyTypeHour;
    }
    
    int numberOfLine = 24 * 3600 / frequencyType;
    CGFloat lineOffset = (boundsW - sideOffset * 2) / numberOfLine;
    
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:@"00:00" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11]}];
    
    CGFloat hourTextWidth = attributeString.size.width;
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:238.0/255.0 green:165.0/255 blue:133.0/255 alpha:1.0].CGColor);
    
    for (NSDictionary *rangeDict in _selectedRange) {
        int startSecond = [rangeDict[@"start"] intValue];
        int endSecond = [rangeDict[@"end"] intValue];
        CGFloat x =(startSecond / (24 * 3600.0)) * (boundsW - sideOffset * 2) + sideOffset;
        CGFloat width = (endSecond - startSecond) / (24 * 3600.0) * (boundsW - sideOffset * 2);
        CGRect rect = CGRectMake(x, 0, width, boundsH);
        CGContextFillRect(ctx, rect);
    }
    
    for (int i = 0; i < numberOfLine; i++) {
        CGFloat position = i * lineOffset;
        int timeSecond = i * frequencyType;
        BOOL showText = NO;
        NSString *timeString = @"00:00";
        WXTimeRulerMark *mark = self.minorMark;
        if (timeSecond % 3600 == 0) {
            mark = self.majorMark;
            if (hourWidth > (hourTextWidth + 5.0)) { showText = YES; }
            else if ((hourWidth * 3) > ((hourTextWidth + 5) * 2)) { showText = timeSecond % (3600 * 2) == 0; }
            else { showText = timeSecond % (3600 * 4) == 0; }
        }
        else if (timeSecond % 600 == 0) {
            mark = self.middleMark;
            showText = frequencyType = WXRulerFrequencyTypeMinute2;
        }
        
        int hour = timeSecond / 3600;
        int min = timeSecond % 3600 / 60;
        timeString = [NSString stringWithFormat:@"%02d:%02d",hour, min];
        
        [self drawMarkInContext:ctx position:position timeString:timeString mark:mark isShowText: showText];
        
    }
    
    UIImage *imageToDraw = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.contents = (__bridge id _Nullable)(imageToDraw.CGImage);
    
}

- (void)drawMarkInContext:(CGContextRef)context
                 position:(CGFloat)position
               timeString:(NSString *)timeString
                     mark:(WXTimeRulerMark *)mark
                 isShowText:(BOOL)isShowText {
    NSDictionary *attributes = @{NSFontAttributeName: mark.font,
                                NSForegroundColorAttributeName: mark.textColor};
    
    NSAttributedString *attributeString = [[NSAttributedString alloc] initWithString:timeString attributes:attributes];
    
    CGSize textSize = attributeString.size;
    CGFloat rectX = position + sideOffset - mark.size.width * 0.5;
    CGFloat rectY = 0;
    
    CGRect rect = CGRectMake(rectX, rectY, mark.size.width, mark.size.height);
    CGContextSetFillColorWithColor(context, mark.color.CGColor);
    CGContextFillRect(context, rect);
    if (isShowText) {
        CGFloat textRectX = position + sideOffset - textSize.width * 0.5;
        CGFloat textRectY = CGRectGetMaxY(rect) + 4.0;
        if ((textRectY + textSize.height * 0.5) > self.bounds.size.height * 0.5) {
            textRectY = self.bounds.size.height - textSize.height * 0.5;
        }
        CGRect textRect = CGRectMake(textRectX, textRectY, textSize.width, textSize.height);
        [timeString drawInRect:textRect withAttributes: attributes];
        
    }
    
}


// 最小标记
- (WXTimeRulerMark *)minorMark {
    if (!_minorMark) {
        _minorMark = [[WXTimeRulerMark alloc] init];
        _minorMark.frequencyType = WXRulerFrequencyTypeMinute2;
        _minorMark.size = CGSizeMake(1.0, 4.0);
    }
    return _minorMark;
}

// 中等标记
- (WXTimeRulerMark *)middleMark {
    if (!_middleMark) {
        _middleMark = [[WXTimeRulerMark alloc] init];
        _middleMark.frequencyType = WXRulerFrequencyTypeMinute10;
        _middleMark.size = CGSizeMake(1.0, 8.0);
    }
    return _middleMark;
}

- (WXTimeRulerMark *)majorMark {
    if (!_majorMark) {
        _majorMark = [[WXTimeRulerMark alloc] init];
        _majorMark.frequencyType = WXRulerFrequencyTypeHour;
        _majorMark.size = CGSizeMake(1.0, 13.0);
    }
    return _majorMark;
}

@end
