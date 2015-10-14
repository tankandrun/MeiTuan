//
//  MTRestrictions.h
//  MeiTuan
//
//  Created by 金顺度 on 15/10/14.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTRestrictions : NSObject

/** int 是否需要预约，0:不是，1:是 */
@property (nonatomic,assign)int is_reservation_required;
/** int 是否支持随时退款，0:不是，1:是 */
@property (nonatomic,assign)int is_refundable;
/** string 附加信息 */
@property (nonatomic,strong)NSString *special_tips;


@end
