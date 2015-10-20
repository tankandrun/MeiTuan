//
//  MTSorts.h
//  MeiTuan
//
//  Created by 金顺度 on 15/10/12.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTSorts : NSObject
/** 排序的值（将来发给服务器） */
@property (nonatomic,assign)int value;
/** 排序名称 */
@property (nonatomic,copy)NSString *label;

@end
