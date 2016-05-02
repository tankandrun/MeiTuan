//
//  MTDealTool.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/14.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTDealTool.h"
#import "FMDB.h"
#import "MTDeal.h"
@implementation MTDealTool

static FMDatabase *_db;
+ (void)initialize {
    //1.打开数据库
    NSString *file = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:@"deal.sqlite"];
    NSLog(@"%@",file);
    _db = [FMDatabase databaseWithPath:file];
    if (![_db open]) return;
    
    //2.创表
    //收藏
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_collect_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
    //最近
    [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_recent_deal(id integer PRIMARY KEY, deal blob NOT NULL, deal_id text NOT NULL);"];
}

+ (NSArray *)collectDeals:(int)page
{
    int size = 10;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_collect_deal ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        MTDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}
//添加收藏
+ (void)addCollectDeal:(MTDeal *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_collect_deal(deal, deal_id) VALUES(%@, %@);", data, deal.deal_id];
}
//取消收藏
+ (void)removeCollectDeal:(MTDeal *)deal
{
    [_db executeUpdateWithFormat:@"DELETE FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
}
//判断收藏
+ (BOOL)isCollected:(MTDeal *)deal
{
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal WHERE deal_id = %@;", deal.deal_id];
    [set next];
//    #warning 索引从1开始
    return [set intForColumn:@"deal_count"] == 1;
}

+ (int)collectDealsCount
{    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT count(*) AS deal_count FROM t_collect_deal;"];
    [set next];
    return [set intForColumn:@"deal_count"];
}

#pragma mark - 最近浏览记录
+ (NSArray *)recentDeals:(int)page
{
    int size = 10;
    int pos = (page - 1) * size;
    FMResultSet *set = [_db executeQueryWithFormat:@"SELECT * FROM t_recent_deal ORDER BY id DESC LIMIT %d,%d;", pos, size];
    NSMutableArray *deals = [NSMutableArray array];
    while (set.next) {
        MTDeal *deal = [NSKeyedUnarchiver unarchiveObjectWithData:[set objectForColumnName:@"deal"]];
        [deals addObject:deal];
    }
    return deals;
}
//添加最近浏览记录
+ (void)addRecentDeal:(MTDeal *)deal
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:deal];
    [_db executeUpdateWithFormat:@"INSERT INTO t_recent_deal(deal, deal_id) VALUES(%@, %@);", data, deal.deal_id];
}
//删除最近浏览记录
+ (void)removeRecentDeal:(MTDeal *)deal
{
    [_db executeUpdateWithFormat:@"DELETE FROM t_recent_deal WHERE deal_id = %@;", deal.deal_id];
}

@end
