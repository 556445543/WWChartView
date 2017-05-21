


//
//  WWXAxisView.m
//  JiaoYiHui
//
//  Created by ww on 2017/3/30.
//  Copyright © 2017年 weihui. All rights reserved.
//

#import "WWXAxisView.h"
#import "WWTool.h"
#import "WWChartEntity.h"
#import "UIView+Extension.h"
#import "NSString+DecimalNumber.h"
#import "WWBarXAxisItem.h"

@interface WWXAxisView()<UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *xAxisArray;

@end

@implementation WWXAxisView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (instancetype)initWithFrame:(CGRect)frame xAxisCount:(NSInteger)xAxisCount{
    self = [super initWithFrame:frame];
    if (self) {
        _xAxisCount = xAxisCount;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)updateTextLayer
{
    for (NSInteger i = 1; i <= self.xAxisCount; i++) {
        CGFloat distance = self.frame.size.width / 4.0;
        CATextLayer *firstTextLayer = [WWTool textLayerWithRect:CGRectMake(i * distance, 4,10, 10) position:  CGPointMake(i * distance, 8) date:nil textColor:[UIColor grayColor] currentView:self];
        [self.xAxisArray addObject:firstTextLayer];
    }
}
#pragma mark - scrollview delegtate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateScreenIndexWithScrollView:scrollView];
}

- (void)updateScreenIndexWithScrollView:(UIScrollView *)scrollView
{
    NSString *nb3 = [[NSString stringWithFormat:@"%f",scrollView.contentOffset.x] priceByDividingBy:[NSString stringWithFormat:@"%f",self.candleWidth+ self.horizontalSpacing]];
    NSString *str = [NSString notRounding:nb3 afterPoint:0 roundingMode:NSRoundUp];
    
    NSString *str2 = [NSString notRounding:nb3 afterPoint:0 roundingMode:NSRoundDown];
    
    
    self.firstIndex = str.integerValue;
    self.lastIndex = str2.integerValue + self.countOfshowCandle ;

    if (self.lastIndex >= self.entityArray.count) {
        self.lastIndex = self.entityArray.count - 1;
    }
    if (self.firstIndex == NSNotFound || self.firstIndex < 0) {
        self.firstIndex = 0;
    }
    
    [self setNeedsDisplay];

}

- (void)updateXAxisArray
{
    if (self.autoDisplayXAxis) {

        NSString *nb3 = [[NSString stringWithFormat:@"%ld",self.countOfshowCandle] priceByDividingBy:[NSString stringWithFormat:@"%ld",(self.xAxisCount -1 <=0?1:self.xAxisCount -1)]];
            NSString *distanceStr = [NSString notRounding:nb3 afterPoint:0 roundingMode:NSRoundDown];
        if (self.dateArray.count <= self.xAxisArray.count) {
            for (NSInteger i =0; i <self.dateArray.count; i++) {
                CATextLayer *textLayer = self.xAxisArray[i ];
                CGSize fontSize = [WWTool sizeOfStr:self.dateArray[i] andFont:[UIFont systemFontOfSize:8] andMaxSize:CGSizeMake(25, 10) andLineBreakMode:NSLineBreakByWordWrapping];
                WWChartEntity *chartEntity = self.entityArray[i];
                
                textLayer.frame = CGRectMake(chartEntity.rect.origin.x -  fontSize.width/2, 4, fontSize.width, 10);
                textLayer.string = self.dateArray[i];

            }
        }else{
            for (NSInteger i =0; i <self.xAxisArray.count; i++) {
                CATextLayer *textLayer = self.xAxisArray[i ];

                NSString *str2 = [distanceStr priceByMultiplyingBy:[NSString stringWithFormat:@"%ld",i]];
                
                NSString *str5 = [NSString notRounding:str2 afterPoint:0 roundingMode:NSRoundDown];
                NSInteger cc = self.firstIndex + str5.integerValue;
                if (cc > self.entityArray.count -1 ) {
                    cc = self.entityArray.count - 1;
                }
                WWChartEntity *chartEntity = self.entityArray[cc];

                NSInteger index = self.firstIndex + distanceStr.integerValue * i;
//                if (self.dateArray.count <= index) {
//                    index = self.dateArray.count - 1;
//                }
                if (i == self.xAxisArray.count - 1) {
                    index = self.lastIndex;
                }
                if (index > self.dateArray.count - 1) {
                    index = self.dateArray.count - 1;
                }
                textLayer.string = self.dateArray[index];
                textLayer.frame =CGRectMake(chartEntity.rect.origin.x, 8, 20, 10);
                textLayer.position =  CGPointMake(chartEntity.rect.origin.x +chartEntity.rect.size.width/2, 8);
                if (i == self.xAxisArray.count - 1) {
                    WWChartEntity *chartEntity = self.entityArray[self.lastIndex];

                    textLayer.position =  CGPointMake(chartEntity.rect.origin.x +chartEntity.rect.size.width/2, 8);

                }

            }
            
        }

    }else{
        
        for (NSInteger i = 0; i < self.xAxiscoordinateArray.count; i++) {
            CATextLayer *textLayer = self.xAxisArray[i];
            WWBarXAxisItem *item = self.xAxiscoordinateArray[i];
           CGRect rect = item.rect;
            rect.origin.x -= self.leftSeparationDistance;
            textLayer.frame = rect;
            textLayer.string = item.coordinateAxisX;
            
        }
    }
    

}
- (void)upDateArray:(NSArray<NSString *> *)dateArray candleWidth:(CGFloat)candleWidth horizontalSpacing:(CGFloat)horizontalSpacing countOfshowCandle:(CGFloat)countOfshowCandle entityArray:(NSMutableArray*)entityArray 
{
    self.dateArray = [NSMutableArray array];
    self.entityArray = @[].mutableCopy;
    self.dateArray = dateArray;
    self.candleWidth = candleWidth;
    self.horizontalSpacing= horizontalSpacing;
    self.entityArray = entityArray;
    self.countOfshowCandle = countOfshowCandle;

}

#pragma mark -getter setter method

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
    _lastIndex = lastIndex;
    
}

- (void)setXAxisCount:(NSInteger)xAxisCount
{
    _xAxisCount = xAxisCount;
    for (NSInteger i = self.xAxisArray.count ; i > 0; i --) {
        CATextLayer *textLayer = self.xAxisArray[i - 1];
        [textLayer removeFromSuperlayer];
    }
    [self.xAxisArray removeAllObjects];
    
    for (NSInteger i = 0; i < xAxisCount; i++) {
        
        CGFloat distance = self.frame.size.width / (xAxisCount -1 <=0?1:xAxisCount -1);
        CATextLayer *firstTextLayer = [WWTool textLayerWithRect:CGRectMake(i * distance, 4,20, 10) date:nil textColor:[UIColor grayColor] currentView:self];
        [self.xAxisArray addObject:firstTextLayer];
    }
}

- (NSMutableArray *)xAxisArray
{
    if (!_xAxisArray) {
        _xAxisArray = @[].mutableCopy;
    }
    return _xAxisArray;
}

@end
