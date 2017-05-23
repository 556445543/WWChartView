
//
//  WWLineViewController.m
//  WWChartView
//
//  Created by ww on 2017/5/19.
//  Copyright © 2017年 ww. All rights reserved.
//

#import "WWLineViewController.h"
#import "WWLineChartView.h"
#import "UIView+Extension.h"
#import "WWLineChartEntity.h"

@interface WWLineViewController ()

@property (nonatomic, copy) NSArray *entities;

@end

@implementation WWLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self buildTestDataThen:^{
        [self scrollLineView];

    }];
}
- (void)buildTestDataThen:(void (^)(void))then {
    // Simulate an async request
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        NSString *dataFilePath = [[NSBundle mainBundle] pathForResource:@"line" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
        NSDictionary *rootDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        NSArray *recordsDicts = rootDict[@"records"];
        
        
        NSMutableArray *entities = @[].mutableCopy;
        [recordsDicts enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [entities addObject:[[WWLineChartEntity alloc] initWithDictionary:obj]];
        }];
        self.entities = entities;
        
        // Callback
        dispatch_async(dispatch_get_main_queue(), ^{
            !then ?: then();
        });
    });
}
- (void)scrollLineView
{
    NSMutableArray *dates = @[].mutableCopy;
    NSMutableArray *datas = @[].mutableCopy;
    for (WWLineChartEntity *entity in self.entities) {
        [dates addObject:entity.staticTimeDateString];
        [datas addObject:[NSNumber numberWithDouble:entity.accumProfitAndLoss.doubleValue]];
    }
    
     WWLineChartView *lineView= [[WWLineChartView alloc] initWithFrame:CGRectMake(0, 64+40, self.view.bounds.size.width, 108)];
    [self.view addSubview:lineView];
    lineView.yMAxValue = 57;
    lineView.yMinValue = 162;

    lineView.PromptLabel.text = @"无完成的FOREX模拟挑战赛";
        
    lineView.yisYLabelArray = @[@"57",
                                @"-16",
                                @"-89",
                                @"-162"] ;
    

    lineView.zoomEnabled = YES;
    
    lineView.candleWidth = (lineView.width-lineView.leftSeparationDistance - lineView.rightSeparationDistance) /((20));
    
    lineView.rightYAxisColor = [UIColor lightTextColor];
    
    lineView.candleMaxWidth = 15;
    lineView.candleMinWidth =((lineView.width-lineView.leftSeparationDistance - lineView.rightSeparationDistance) /self.entities.count);
//    __weak __typeof(self)weakSelf = self;
    [lineView setChartViewDidClickedCompletion:^(NSInteger index){
        NSLog(@"选中第%ld个",index);
    }];
    [lineView setChartViewDidPitchCompletion:^(CGFloat calCandleWidth){
        NSLog(@"缩放持续调用");
    }];
    lineView.horizontalLinePitch = (lineView.height - lineView.topSeparationDistance - lineView.bottomSeparationDistance)/3;
    lineView.yAxisDistance = nil;
    lineView.horizontalLineCount =4;
    lineView.animation = YES;
    lineView.dateArray = dates;
    lineView.dataArray = datas;
    [lineView stroke];

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
