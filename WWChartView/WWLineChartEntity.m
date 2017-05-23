
//
//  WWLineChartEntity.m
//  WWChartView
//
//  Created by ww on 2017/5/23.
//  Copyright © 2017年 ww. All rights reserved.
//

#import "WWLineChartEntity.h"
#import "WWTool.h"

@implementation WWLineChartEntity

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = super.init;
    if (self) {
        _accumProfitAndLoss = dictionary[@"accumProfitAndLoss"];
        _profitAndLoss = dictionary[@"profitAndLoss"];
        _staticTime = dictionary[@"staticTime"];
        _staticTimeDateString = [self fetchYearMonthTimeHoursStr:_staticTime];
    }
    return self;
}

- (NSString *)fetchYearMonthTimeHoursStr:(NSString *)timeStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM-dd"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timeStr.doubleValue/1000.0];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}
@end
