//
//  MTCenterLineLabel.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/13.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTCenterLineLabel.h"

@implementation MTCenterLineLabel

- (void)drawRect:(CGRect)rect {//==>UILabel的文字是画出来的
    [super drawRect:rect];
    
    //获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //画线
    //设置起点
    CGContextMoveToPoint(ctx, 0, rect.size.height*0.5);
    //连线到另一个点
    CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height*0.5);
    //渲染
    CGContextStrokePath(ctx);
    
//    UIRectFill(CGRectMake(0, rect.size.height*0.5, rect.size.width, 1));
}


@end
