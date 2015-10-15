//
//  MTDeal.h
//  MeiTuan
//
//  Created by 金顺度 on 15/10/13.
//  Copyright © 2015年 金顺度. All rights reserved.
//  团购模型

#import <Foundation/Foundation.h>
#import "MTRestrictions.h"
@interface MTDeal : NSObject
/** 团购单ID */
@property (nonatomic,copy)NSString *deal_id;
/** 团购标题 */
@property (nonatomic,copy)NSString *title;
/** 团购描述 */
@property (nonatomic,copy)NSString *desc;
/** 如果想保留服务器返回小数的小数位数，那就使用NSString或NSNumber */
/** 团购包含商品原价值 */
@property (nonatomic,strong)NSNumber *list_price;
/** 团购价格 */
@property (nonatomic,strong)NSNumber *current_price;
/** 团购当前已购买数 */
@property (nonatomic,assign)int purchase_count;
/** 团购图片链接，最大图片尺寸450*280 */
@property (nonatomic,copy)NSString *image_url;
/** 小尺寸团购图片链接，最大图片尺寸160*100 */
@property (nonatomic,copy)NSString *s_image_url;
/** 团购发布上线日期 */
@property (nonatomic,copy)NSString *publish_date;
/** 团购截止日期 */
@property (nonatomic,copy)NSString *purchase_deadline;

/** 团购HTML5页面链接，适用于移动应用的联网车载应用 */
@property (nonatomic,copy)NSString *deal_h5_url;

/** 团购限制条件 */
@property (nonatomic,strong)MTRestrictions *restrictions;

@property (nonatomic, assign,getter=isEditing) BOOL editing;
@property (nonatomic, assign,getter=isChecking) BOOL checking;



@end