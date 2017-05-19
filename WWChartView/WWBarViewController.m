

//
//  WWBarViewController.m
//  WWChartView
//
//  Created by ww on 2017/5/19.
//  Copyright © 2017年 ww. All rights reserved.
//

#import "WWBarViewController.h"
#import "WWBarView.h"
#import "UIView+Extension.h"

@interface WWBarViewController ()

@property (nonatomic,weak) WWBarView *barView;
@end

@implementation WWBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self unEnableScrollWithBarView];
 
    [self scrollEnableWithBarView];
}

- (void)scrollEnableWithBarView
{
    WWBarView *barView = [[WWBarView alloc] initWithFrame:CGRectMake(0, 100+108+60, self.view.bounds.size.width, 108)];
    
    [self.view addSubview:barView];
    self.barView = barView;
    self.barView.candleMaxWidth = 30;
    self.barView.candleMinWidth = 8;
    self.barView.animation = YES;
    self.barView.drawCenterLineEnabled = YES;
    self.barView.highlightLineShowEnabled = YES;
    self.barView.yMAxValue = 50;
    self.barView.yMinValue = 127;
    self.barView.autoDisplayXAxis = YES;
    self.barView.PromptLabel.text = @"无实盘项目";
    
    self.barView.PromptLabel.text = @"无完成的FOREX模拟挑战赛";
    self.barView.yisYLabelArray = @[@"50%"
                                    ,@"-9%"
                                    ,@"-68%"
                                    ,@"-127%"] ;
    self.barView.chartItemColor.strokeTopColor = [UIColor orangeColor];
    self.barView.chartItemColor.strokeBottomColor = [UIColor greenColor];
    self.barView.yisYLeftLabelArray = @[];
    self.barView.xAxisCount = 4;
    self.barView.horizontalSpacing = 14;
    self.barView.zoomEnabled = YES;
    self.barView.rightYAxisColor = [UIColor lightTextColor];
    self.barView.drawYAxisEnable = NO;
    
    
    __weak __typeof(self)weakSelf = self;
    
    [self.barView setChartViewDidPitchCompletion:^(CGFloat candleWidth){
        NSLog(@"放大 setChartViewDidPitchCompletion%f",candleWidth);
    }];
    self.barView.animation = YES;
    
  
    self.barView.candleWidth = 8;
    

    self.barView.horizontalSpacing = 14;
    
    self.barView.horizontalLinePitch = (self.barView.height - self.barView.topSeparationDistance - self.barView.bottomSeparationDistance)/3;
    self.barView.yAxisDistance = nil;
    self.barView.horizontalLineCount =4;
    self.barView.lineDataArray = @[];
    self.barView.dateArray = @[@"05-14",
                               @"05-17",
                               @"05-22",
                               @"05-28",
                               @"06-04",
                               @"06-12",
                               @"06-18",
                               @"06-25",
                               @"07-02",
                               @"07-10",
                               @"07-17",
                               @"07-25",
                               @"07-31",
                               @"08-07",
                               @"08-14",
                               @"08-21",
                               @"08-28",
                               @"09-04",
                               @"09-12",
                               @"09-18",
                               @"09-25",
                               @"09-30",
                               @"09-29",
                               @"09-30",
                               @"10-09",
                               @"10-12",
                               @"10-13",
                               @"10-16",
                               @"10-24",
                               @"10-30",
                               @"11-06",
                               @"11-14",
                               @"11-21",
                               @"11-27",
                               @"12-05",
                               @"12-11",
                               @"12-19",
                               @"12-26",
                               @"01-02",
                               @"01-08",
                               @"01-16",
                               @"01-23",
                               @"02-06",
                               @"02-21",
                               @"03-08",
                               @"03-27",
                               @"04-10"
                               ];
    self.barView.dataArray =@[@0,
                              @0.22,
                              @7.61,
                              @-0.07,
                              @-16.85,
                              @-35.69,
                              @5.21,
                              @-27.35,
                              @7.23,
                              @9.4,
                              @11.36,
                              @9.77,
                              @23.58,
                              @4.36,
                              @8.2,
                              @-31.18,
                              @5.68,
                              @4.67,
                              @0.51,
                              @-13.68,
                              @-10.15,
                              @0,
                              @0,
                              @-100,
                              @1.75,
                              @2.05,
                              @8.89,
                              @1.12,
                              @8.43,
                              @-23.12,
                              @-90.24,
                              @-33.64,
                              @-2.49,
                              @1.13,
                              @-53.07,
                              @10.08,
                              @5.78,
                              @-13.23,
                              @12.12,
                              @7.52,
                              @8.1,
                              @5.74,
                              @-5.19,
                              @8.04,
                              @-32.15,
                              @-8.16,
                              @4.22
];
    [self.barView stroke];
    
    [barView setChartViewDidClickedCompletion:^(NSInteger tag) {
        NSLog(@"点击了回调哦！！！！！---%ld",tag);
    }];

}
- (void)unEnableScrollWithBarView
{
    WWBarView *barView = [[WWBarView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 108)];
    
    [self.view addSubview:barView];
    self.barView = barView;
    NSArray *dataArray = @[@45.07,
                           @-86.26,
                           @-97.41,
                           @-65.74,
                           @-72.99,
                           @-9.72,
                           @-96.53,
                           @32.53];
    self.barView.highlightLineShowEnabled = YES;
    self.barView.yMAxValue = 76;
    self.barView.yMinValue = 128;
    self.barView.autoDisplayXAxis = YES;

    self.barView.PromptLabel.text = @"无实盘项目";
    

    self.barView.PromptLabel.text = @"无完成的FOREX模拟挑战赛";

    self.barView.yisYLabelArray = @[@"76%"
                                    ,@"8%"
                                    ,@"-60%"
                                    ,@"-128%"] ;

    self.barView.chartItemColor.strokeTopColor = [UIColor orangeColor];
    self.barView.chartItemColor.strokeBottomColor = [UIColor greenColor];
    self.barView.yisYLeftLabelArray = @[];
    self.barView.xAxisCount = 4;
    self.barView.horizontalSpacing = 14;
    self.barView.zoomEnabled = YES;
    self.barView.rightYAxisColor = [UIColor lightTextColor];

    self.barView.drawYAxisEnable = NO;
    
    self.barView.candleMaxWidth = 30;
    self.barView.candleMinWidth = 8;
    self.barView.animation = YES;
    
    __weak __typeof(self)weakSelf = self;
    
    [self.barView setChartViewDidPitchCompletion:^(CGFloat candleWidth){
        NSLog(@"放大 setChartViewDidPitchCompletion%f",candleWidth);

    }];

    self.barView.animation = YES;
    
    self.barView.candleWidth = 8;
    
    CGFloat distance = (self.barView.width-self.barView.leftSeparationDistance - self.barView.rightSeparationDistance) /((dataArray.count));
    self.barView.horizontalSpacing = distance - self.barView.candleWidth;
    
    self.barView.horizontalLineCount =4;

    self.barView.horizontalLinePitch = (self.barView.height - self.barView.topSeparationDistance - self.barView.bottomSeparationDistance)/(self.barView.horizontalLineCount-1);
    self.barView.yAxisDistance = nil;
    self.barView.lineDataArray = @[].mutableCopy;
    self.barView.dateArray = @[@"12-20",
                               @"12-23",
                               @"01-22",
                               @"02-20",
                               @"03-03",
                               @"03-15",
                               @"03-19",
                               @"03-21"
                               ];
    self.barView.dataArray = dataArray;
    [self.barView stroke];
    
    [barView setChartViewDidClickedCompletion:^(NSInteger tag) {
        NSLog(@"点击了回调哦！！！！！---%ld",tag);
    }];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
