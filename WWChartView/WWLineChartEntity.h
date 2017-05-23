//
//  WWLineChartEntity.h
//  WWChartView
//
//  Created by ww on 2017/5/23.
//  Copyright © 2017年 ww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WWLineChartEntity : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, copy, readonly) NSString *accumProfitAndLoss;

@property (nonatomic, copy, readonly) NSString *profitAndLoss;

@property (nonatomic, copy, readonly) NSString *staticTime;

@property (nonatomic, copy, readonly) NSString *staticTimeDateString;

@end
