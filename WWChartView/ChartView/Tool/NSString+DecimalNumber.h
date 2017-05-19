//
//  NSString+DecimalNumber.h
//  JiaoYiHui
//
//  Created by ww on 2017/4/13.
//  Copyright © 2017年 weihui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DecimalNumber)
/// 加
- (NSString *)priceByAdding:(NSString *)number;

/// 减
- (NSString *)priceBySubtracting:(NSString *)number;

/// 乘
- (NSString *)priceByMultiplyingBy:(NSString *)number;

/// 除
- (NSString *)priceByDividingBy:(NSString *)number;

+(NSString *)notRounding:(NSString *)price afterPoint:(int)position roundingMode:(NSRoundingMode)roundingMode;
@end
