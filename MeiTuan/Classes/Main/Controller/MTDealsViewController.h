//
//  MTDealsViewController.h
//  MeiTuan
//
//  Created by 金顺度 on 15/10/13.
//  Copyright © 2015年 金顺度. All rights reserved.
//  团购列表控制器（父类）

#import <UIKit/UIKit.h>

@interface MTDealsViewController : UICollectionViewController
/**
 *  设置请求参数：交给子类去实现
 */
- (void)setupParams:(NSMutableDictionary *)params;
@end
