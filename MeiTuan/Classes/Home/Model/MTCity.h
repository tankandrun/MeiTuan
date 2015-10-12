//
//  MTCity.h
//  MeiTuan
//
//  Created by 金顺度 on 15/10/10.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTCity : NSObject
/** 城市的名称 */
@property (nonatomic,copy)NSString *name;
/** 城市的拼音 */
@property (nonatomic,copy)NSString *pinYin;
/** 城市拼音的首字母 */
@property (nonatomic,copy)NSString *pinYinHead;
/** 区域(存放的都是MTRegion模型) */
@property (nonatomic,strong)NSArray *regions;

@end
