//
//  WWPieChartDataItem.m
//  Pie
//
//  Created by ww on 16/6/29.
//  Copyright © 2016年 cc. All rights reserved.
//

#import "WWPieChartDataItem.h"

@implementation WWPieChartDataItem
+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color{
    WWPieChartDataItem *item = [WWPieChartDataItem new];
    item.value = value;
    item.color  = color?:[UIColor whiteColor];
    return item;
}

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color
                      description:(NSString *)description {
    WWPieChartDataItem *item = [WWPieChartDataItem dataItemWithValue:value color:color];
    item.textDescription = description;
    return item;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
