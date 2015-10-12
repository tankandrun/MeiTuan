//
//  MTCityGroups.h
//  MeiTuan
//
//  Created by 金顺度 on 15/10/10.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTCityGroups : NSObject
/** 这组的所有城市 */
@property (nonatomic,strong)NSArray *cities;
/** 这组的名字 */
@property (nonatomic,copy)NSString *title;
@end
