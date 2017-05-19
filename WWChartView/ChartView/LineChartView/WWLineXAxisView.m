


//
//  WWLineXAxisView.m
//  JiaoYiHui
//
//  Created by ww on 2017/3/30.
//  Copyright © 2017年 weihui. All rights reserved.
//

#import "WWLineXAxisView.h"
#import "WWTool.h"
#import "WWChartEntity.h"
#import "UIView+Extension.h"
#import "NSString+DecimalNumber.h"
#import "WWBarXAxisItem.h"

@interface WWLineXAxisView()<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *xAxisArray;

@property (nonatomic,weak) CATextLayer *firstTextLayer;

@property (nonatomic,weak) CATextLayer *lastTextLayer;

@end

@implementation WWLineXAxisView



- (instancetype)initWithFrame:(CGRect)frame xAxisCount:(NSInteger)xAxisCount
{
    self = [super initWithFrame:frame];
    if (self) {
        _xAxisCount = xAxisCount;

        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)setupXAxisCount:(NSInteger)xAxisCount customXAxisEnable:(BOOL)customXAxisEnable
{
    _xAxisCount = xAxisCount;
    if (customXAxisEnable) {
        for (NSInteger i = self.xAxisArray.count ; i > 0; i --) {
            CATextLayer *textLayer = self.xAxisArray[i - 1];
            [textLayer removeFromSuperlayer];
        }
        [self.xAxisArray removeAllObjects];
        
        for (NSInteger i = 0; i < xAxisCount; i++) {
            CGFloat distance = self.frame.size.width / (xAxisCount -1 <=0?1:xAxisCount -1);
            CATextLayer *firstTextLayer = [WWTool textLayerWithRect:CGRectMake(i * distance, 4,20, 10) date:nil textColor:[UIColor grayColor] currentView:self];
            firstTextLayer.hidden = YES;
            [self.xAxisArray addObject:firstTextLayer];
        }

    }else{
        for (NSInteger i =0; i <2; i++) {
            if (i == 0) {
                CATextLayer *firstTextLayer = [WWTool textLayerWithRect:CGRectMake(10, 4,10, 10) position:CGPointMake(10, 8) date:nil textColor:[UIColor grayColor] currentView:self];
                [self.xAxisArray addObject:firstTextLayer];
                self.firstTextLayer = firstTextLayer;

            }else{
                self.lastTextLayer = [WWTool textLayerWithRect:CGRectMake(self.width - 10, 4,10, 10) position:CGPointMake(self.width - 10, 8) date:nil textColor:[UIColor grayColor] currentView:self];
                [self.xAxisArray addObject:self.lastTextLayer];

 
            }
        
        }
        

    }
   
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    
    CGPoint pointP = [self convertPoint:point toView:self];
    
    if ([self pointInside:pointP withEvent:event]) {
        return nil;
        
    }else{
        return [super hitTest:point withEvent:event];
    }
    
}

- (void)updateXAxisArray
{
    if (self.xAxiscoordinateArray.count) {
        for (NSInteger i = 0; i < self.xAxiscoordinateArray.count; i++) {
            CATextLayer *textLayer = self.xAxisArray[i];
            WWBarXAxisItem *item = self.xAxiscoordinateArray[i];
            CGRect rect = item.rect;
            rect.origin.x -= rect.size.width/2;
            textLayer.frame = rect;
            textLayer.hidden = NO;
            textLayer.string = item.coordinateAxisX;
            
        }
    }else{
        for (NSInteger i =0; i <self.xAxisArray.count; i++) {
            CATextLayer *textLayer = self.xAxisArray[i];
            if (!self.entityArray.count ) {
                return;
            }
            if (i == 0) {
                
                WWChartEntity *chartEntity = self.entityArray[self.firstIndex];
                CGSize fontSize = [WWTool sizeOfStr:self.dateArray[self.firstIndex] andFont:[UIFont systemFontOfSize:8] andMaxSize:CGSizeMake(25, 10) andLineBreakMode:NSLineBreakByWordWrapping];
                
                textLayer.frame = CGRectMake(chartEntity.rect.origin.x, 4, fontSize.width, 10);
                
                self.firstTextLayer.position = CGPointMake( fontSize.width/2,  fontSize.height/2+8);
                
                self.firstTextLayer.string = self.dateArray[self.firstIndex];


            }else{

                CGSize fontSize = [WWTool sizeOfStr:self.dateArray[self.lastIndex] andFont:[UIFont systemFontOfSize:8] andMaxSize:CGSizeMake(25, 10) andLineBreakMode:NSLineBreakByWordWrapping];
//                if (!self.lastIndex) {
//                    self.lastIndex = 0;
//                }
                WWChartEntity *chartEntity = self.entityArray[self.lastIndex];
                self.lastTextLayer.string = self.dateArray[self.lastIndex];
                self.lastTextLayer.frame = CGRectMake(chartEntity.rect.origin.x, 4, fontSize.width, 10);
                
                if (self.scrollEnabled) {
                    self.lastTextLayer.position = CGPointMake(self.width - fontSize.width/2, fontSize.height/2+8);
                }else{
                    self.lastTextLayer.position = CGPointMake(chartEntity.rect.origin.x - fontSize.width/2, fontSize.height/2+8);
                }

            }

        }
    }
    
}

#pragma mark - getter setter method

- (void)setXAxiscoordinateArray:(NSArray *)xAxiscoordinateArray
{
    _xAxiscoordinateArray = [xAxiscoordinateArray copy];
    for (NSInteger i = self.xAxisArray.count ; i > 0; i --) {
        CATextLayer *textLayer = self.xAxisArray[i - 1];
        [textLayer removeFromSuperlayer];
    }
    
    [self.xAxisArray removeAllObjects];
    self.xAxisCount = xAxiscoordinateArray.count;
    for (NSInteger i = 0; i < self.xAxisCount; i++) {
        WWBarXAxisItem *item = self.xAxiscoordinateArray[i];
        CATextLayer *firstTextLayer = [WWTool textLayerWithRect:item.rect date:nil textColor:[UIColor grayColor]currentView:self];
        
        [self.xAxisArray addObject:firstTextLayer];
    }
    
}

- (void)setFirstIndex:(NSInteger)firstIndex
{
    if (!self.dateArray ) {
        return;
    }
    
    if (firstIndex == NSNotFound || firstIndex < 0) {
        firstIndex = 0;
    }
    else if ( firstIndex >= self.entityArray.count && self.entityArray.count != 0) {
        firstIndex = self.entityArray.count - 1;
    }
    
    _firstIndex = firstIndex;
    
}

- (void)setLastIndex:(NSInteger)lastIndex
{
    if ( lastIndex >= self.entityArray.count && self.entityArray.count > 0) {
        lastIndex = self.entityArray.count - 1;
    }
    if (lastIndex >= self.dateArray.count  && self.dateArray.count > 0) {
        lastIndex = self.dateArray.count - 1;
    }
    
    _lastIndex = lastIndex;
}


- (NSMutableArray *)xAxisArray
{
    if (!_xAxisArray) {
        _xAxisArray = @[].mutableCopy;
    }
    return _xAxisArray;
}
@end
