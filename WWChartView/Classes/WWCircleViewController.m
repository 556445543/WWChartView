
//
//  WWCircleViewController.m
//  WWChartView
//
//  Created by ww on 2017/5/19.
//  Copyright © 2017年 ww. All rights reserved.
//

#import "WWCircleViewController.h"
#import "WWPieChartView.h"

@interface WWCircleViewController ()

@end

@implementation WWCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self pieView];
    
}

- (void)pieView
{
   WWPieChartView *pieChartView = [[WWPieChartView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 108)];
    [self.view addSubview:pieChartView];
    NSArray *items = @[[WWPieChartDataItem dataItemWithValue:24 color:[UIColor grayColor] description:@"黄金"],
                       [WWPieChartDataItem dataItemWithValue:33 color:[UIColor orangeColor] description:@"美国原油"],
                       [WWPieChartDataItem dataItemWithValue:21 color:[UIColor colorWithRed:77.0 / 255.0 green:176.0 / 255.0 blue:122.0 / 255.0 alpha:1.0f] description:@"香港恒生指数"],
                       [WWPieChartDataItem dataItemWithValue:22 color:[UIColor colorWithRed:252.0 / 255.0 green:223.0 / 255.0 blue:101.0 / 255.0 alpha:1.0f] description:@"沪深指数"]];
    
    
    pieChartView.PromptLabel.text = @"无完成的FOREX模拟挑战赛";
        
    
    
    pieChartView.dataArray = items;

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
