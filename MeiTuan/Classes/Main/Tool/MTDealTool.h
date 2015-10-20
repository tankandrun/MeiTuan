//
//  MTDealTool.h
//  MeiTuan
//
//  Created by 金顺度 on 15/10/14.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MTDeal;
@interface MTDealTool : NSObject
/**
 *  返回第page页的收藏团购数据:page从1开始
 */
+ (NSArray *)collectDeals:(int)page;
+ (int)collectDealsCount;
/**
 *  收藏一个团购
 */
+ (void)addCollectDeal:(MTDeal *)deal;
/**
 *  取消收藏一个团购
 */
+ (void)removeCollectDeal:(MTDeal *)deal;
/**
 *  团购是否收藏
 */
+ (BOOL)isCollected:(MTDeal *)deal;
@end
