//
//  ViewController.m
//  WXRecordScaleView
//
//  Created by xun on 2017/8/24.
//  Copyright © 2017年 Antler. All rights reserved.
//

#import "ViewController.h"
//#import "WXScaleTimeView.h"
#import "WXTimeRulerView.h"

@interface ViewController ()
{
//    WXScaleTimeView *timeView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    timeView = [[WXScaleTimeView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 80) timeInterval:2];
//    timeView.recordTimes = @[@{@"from":@"1497546000",@"to":@"1497553200"},
//                           @{@"from":@"1497554200",@"to":@"1497575800"},
//                           @{@"from":@"1497576800",@"to":@"1497607200"},
//                           @{@"from":@"1497619200",@"to":@"1497624000"}];
//    [self.view addSubview:timeView];
//
//    timeView.currentVlaueBlock = ^(double value) {
//        NSLog(@"----%f",value);
//    };
    
    WXTimeRulerView *rulerView = [[WXTimeRulerView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height * 0.5 - 40, self.view.bounds.size.width, 80)];
    
    NSArray *arr = @[@{@"start": @(60),
                       @"end": @(300)},
                    @{@"start": @(500),
                      @"end": @(800)},
                     @{@"start": @(3600),
                     @"end": @(4800)},
                     @{@"start": @(8501),
                       @"end": @(10000)},
                     @{@"start": @(12000),
                       @"end": @(15797)}];
    [rulerView setSelectedRanges:arr];
    [self.view addSubview:rulerView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
