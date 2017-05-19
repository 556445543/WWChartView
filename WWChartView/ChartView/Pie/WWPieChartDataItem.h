//
//  WWPieChartDataItem.h
//  Pie
//
//  Created by ww on 16/6/29.
//  Copyright © 2016年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WWPieChartDataItem : NSObject
+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color;

+ (instancetype)dataItemWithValue:(CGFloat)value
                            color:(UIColor*)color
                      description:(NSString *)description;

@property (nonatomic,assign) CGFloat   value;
@property (nonatomic,strong) UIColor  *color;
@property (nonatomic,strong) NSString *textDescription;

@end
