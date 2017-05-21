

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

//@property (nonatomic,weak) WWBarView *barView;
@end

@implementation WWBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    UIScrollView *scrollView = (UIScrollView *)self.view;
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, (100+108+60)*3);
    // Do any additional setup after loading the view.
    //不能滚动的barview
    [self unEnableScrollWithBarView];
    //能滚动
    [self scrollEnableWithBarView];
    //自定义x轴的位置
    [self unEnableScrollWithCustomXAxisValue];
}

- (void)unEnableScrollWithCustomXAxisValue
{
    WWBarView *barView = [[WWBarView alloc] initWithFrame:CGRectMake(0, 100+108+60+108+60, self.view.bounds.size.width, 108)];
    
    [self.view addSubview:barView];
    barView.highlightLineShowEnabled = YES;
    barView.zoomEnabled = NO;
    barView.strokeColor = [UIColor redColor];
    barView.yMAxValue = 296;
    barView.yMinValue = 2;
    barView.yisYLabelArray =@[@"296",
                                   @"198",
                                   @"100",
                                   @"2"];
    barView.horizontalLinePitch = (barView.height - barView.topSeparationDistance - barView.bottomSeparationDistance)/3;

    barView.horizontalLineCount =4;

    barView.PromptLabel.text = @"无完成的FOREX模拟挑战赛";

    barView.chartItemColor.strokeTopColor = [UIColor redColor];
    barView.yisYLeftLabelArray = @[];
    
    CGFloat distance = (barView.width-(barView.leftSeparationDistance + barView.rightSeparationDistance))/24.0;
    barView.horizontalSpacing = distance/2;
    barView.candleWidth = distance/2;
    barView.dateArray = @[];
    barView.autoDisplayXAxis = NO;
    NSArray *times = @[@"7:00",@"14:00",@"21:00"];
    NSMutableArray *frames = @[].mutableCopy;
    barView.xAxisCount = 3;
    barView.drawYAxisEnable = YES;
    barView.rightYAxisColor = [UIColor lightTextColor];
    
    barView.animation = YES;
    CGFloat width = (barView.width - barView.leftSeparationDistance - barView.rightSeparationDistance);
    NSMutableArray *xAxiscoordinateArray = @[].mutableCopy;
    for (int i =0; i<times.count; i++) {
        //竖直线条
        CGFloat pitch =  width/(24.0);
        CGFloat firstLineStartX = pitch *7*(i+1);
        CGFloat lineStartX = pitch *7+ pitch *7*(i);
        CGRect rect;
        
        if (i == 0){
            
            rect = CGRectMake(firstLineStartX + barView.candleWidth/2 + barView.horizontalSpacing/2 , 2, 24, 24);
            [frames addObject:[NSValue valueWithCGRect:rect]];
            
            
        }else{
            
            rect = CGRectMake(lineStartX+barView.candleWidth/2+ barView.horizontalSpacing/2  , 2, 24, 24);
            
            [frames addObject:[NSValue valueWithCGRect:rect]];
            
        }
        WWBarXAxisItem *item = [WWBarXAxisItem itemModelWithCoordinateAxisX:times[i] rect:rect];
        [xAxiscoordinateArray addObject:item];
    }
    
    barView.lineDataArray = @[].mutableCopy;
    barView.xAxiscoordinateArray = xAxiscoordinateArray;
        
    barView.dataArray = @[@161,
                               @72,
                               @31,
                               @4,
                               @3,
                               @5,
                               @2,
                               @14,
                               @16,
                               @33,
                               @46,
                               @21,
                               @14,
                               @26,
                               @26,
                               @56,
                               @99,
                               @72,
                               @75,
                               @101,
                               @160,
                               @190,
                               @246,
                               @189];

    [barView stroke];
    

}

- (void)scrollEnableWithBarView
{
    WWBarView *barView = [[WWBarView alloc] initWithFrame:CGRectMake(0, 100+108+60, self.view.bounds.size.width, 108)];
    
    [self.view addSubview:barView];
    
    barView.candleMaxWidth = 30;
    barView.candleMinWidth = 8;
    barView.drawCenterLineEnabled = YES;
    barView.highlightLineShowEnabled = YES;
    barView.yMAxValue = 50;
    barView.yMinValue = 127;
    barView.PromptLabel.text = @"无实盘项目";
    
    barView.PromptLabel.text = @"无完成的FOREX模拟挑战赛";
    barView.yisYLabelArray = @[@"50%"
                                    ,@"-9%"
                                    ,@"-68%"
                                    ,@"-127%"] ;
    barView.chartItemColor.strokeTopColor = [UIColor orangeColor];
    barView.chartItemColor.strokeBottomColor = [UIColor greenColor];
    barView.yisYLeftLabelArray = @[];
    
    barView.xAxisCount = 4;
    barView.autoDisplayXAxis = YES;

    barView.horizontalSpacing = 14;
    barView.zoomEnabled = YES;
    barView.rightYAxisColor = [UIColor lightTextColor];
    barView.drawYAxisEnable = NO;
    
    
    __weak __typeof(self)weakSelf = self;
    
    [barView setChartViewDidPitchCompletion:^(CGFloat candleWidth){
        NSLog(@"放大 setChartViewDidPitchCompletion%f",candleWidth);
    }];
    barView.animation = YES;
    
  
    barView.candleWidth = 8;
    

    barView.horizontalSpacing = 14;
    
    barView.horizontalLinePitch = (barView.height - barView.topSeparationDistance - barView.bottomSeparationDistance)/3;
    barView.yAxisDistance = nil;
    barView.horizontalLineCount =4;
    barView.lineDataArray = @[];
    barView.dateArray = @[@"05-14",
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
    barView.dataArray =@[@0,
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
    [barView stroke];
    
    [barView setChartViewDidClickedCompletion:^(NSInteger tag) {
        NSLog(@"点击了回调哦！！！！！---%ld",tag);
    }];

}
- (void)unEnableScrollWithBarView
{
    WWBarView *barView = [[WWBarView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 108)];
    
    [self.view addSubview:barView];
    
    NSArray *dataArray = @[@45.07,
                           @-86.26,
                           @-97.41,
                           @-65.74,
                           @-72.99,
                           @-9.72,
                           @-96.53,
                           @32.53];
    barView.highlightLineShowEnabled = YES;
    barView.yMAxValue = 76;
    barView.yMinValue = 128;
    barView.autoDisplayXAxis = YES;

    barView.PromptLabel.text = @"无实盘项目";
    

    barView.PromptLabel.text = @"无完成的FOREX模拟挑战赛";

    barView.yisYLabelArray = @[@"76%"
                                    ,@"8%"
                                    ,@"-60%"
                                    ,@"-128%"] ;

    barView.chartItemColor.strokeTopColor = [UIColor orangeColor];
    barView.chartItemColor.strokeBottomColor = [UIColor greenColor];
    barView.yisYLeftLabelArray = @[];
    barView.xAxisCount = 4;
    barView.horizontalSpacing = 14;
    barView.zoomEnabled = YES;
    barView.rightYAxisColor = [UIColor lightTextColor];

    barView.drawYAxisEnable = NO;
    
    barView.candleMaxWidth = 30;
    barView.candleMinWidth = 8;
    barView.animation = YES;
    
    __weak __typeof(self)weakSelf = self;
    
    [barView setChartViewDidPitchCompletion:^(CGFloat candleWidth){
        NSLog(@"放大 setChartViewDidPitchCompletion%f",candleWidth);

    }];

    barView.animation = YES;
    
    barView.candleWidth = 8;
    
    CGFloat distance = (barView.width-barView.leftSeparationDistance - barView.rightSeparationDistance) /((dataArray.count));
    barView.horizontalSpacing = distance - barView.candleWidth;
    
    barView.horizontalLineCount =4;

    barView.horizontalLinePitch = (barView.height - barView.topSeparationDistance - barView.bottomSeparationDistance)/(barView.horizontalLineCount-1);
    barView.yAxisDistance = nil;
    barView.lineDataArray = @[].mutableCopy;
    barView.dateArray = @[@"12-20",
                               @"12-23",
                               @"01-22",
                               @"02-20",
                               @"03-03",
                               @"03-15",
                               @"03-19",
                               @"03-21"
                               ];
    barView.dataArray = dataArray;
    [barView stroke];
    
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
