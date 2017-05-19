//
//  NSString+DecimalNumber.m
//  JiaoYiHui
//
//  Created by ww on 2017/4/13.
//  Copyright © 2017年 weihui. All rights reserved.
//

#import "NSString+DecimalNumber.h"

@implementation NSString (DecimalNumber)

- (NSString *)priceByAdding:(NSString *)number {
    
    NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *numberB = [NSDecimalNumber decimalNumberWithString:number];
    
    NSDecimalNumber *result = [numberA decimalNumberByAdding:numberB];
    
    return result.stringValue;
}

- (NSString *)priceBySubtracting:(NSString *)number {
    
    NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *numberB = [NSDecimalNumber decimalNumberWithString:number];
    
    NSDecimalNumber *result = [numberA decimalNumberBySubtracting:numberB];
    
    return result.stringValue;
}

- (NSString *)priceByMultiplyingBy:(NSString *)number {
    
    NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *numberB = [NSDecimalNumber decimalNumberWithString:number];
    
    NSDecimalNumber *result = [numberA decimalNumberByMultiplyingBy:numberB];
    
    return result.stringValue;
}

- (NSString *)priceByDividingBy:(NSString *)number {
//    if (number.doubleValue ==0.000) {
//        return nil;
//    }
    NSDecimalNumber *numberA = [NSDecimalNumber decimalNumberWithString:self];
    NSDecimalNumber *numberB = [NSDecimalNumber decimalNumberWithString:number];
    
    NSDecimalNumber *result = [numberA decimalNumberByDividingBy:numberB];
    
    return result.stringValue;
}
+(NSString *)notRounding:(NSString *)price afterPoint:(int)position roundingMode:(NSRoundingMode)roundingMode
{
    
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    
    NSDecimalNumber *ouncesDecimal;
    
    NSDecimalNumber *roundedOunces;
    
    ouncesDecimal = [[NSDecimalNumber alloc] initWithString:price];
    
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    
    
    return [NSString stringWithFormat:@"%@",roundedOunces];
    
}

@end
