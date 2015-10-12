//
//  MTCategory.h
//  MeiTuan
//
//  Created by 金顺度 on 15/10/10.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface MTCategory : NSObject
/** 类别的名称 */
@property (nonatomic,copy)NSString *name;
/** 子类别，里面都是字符串（子类别的名称） */
@property (nonatomic,strong)NSArray *subcategories;
/** 显示在下拉菜单的小图标 */
@property (nonatomic,copy)NSString *small_highlighted_icon;
@property (nonatomic,copy)NSString *small_icon;
/** 显示在导航栏顶部的大图标 */
@property (nonatomic,copy)NSString *highlighted_icon;
@property (nonatomic,copy)NSString *icon;
/** 显示在地图上的图标 */
@property (nonatomic,copy)NSString *map_icon;


@end
