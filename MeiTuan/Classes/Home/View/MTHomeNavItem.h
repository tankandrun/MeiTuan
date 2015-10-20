//
//  MTHomeNavItem.h
//  MeiTuan
//
//  Created by 金顺度 on 15/10/9.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTHomeNavItem : UIView
+ (instancetype)item;
/**
 *  设置点击的监听器
 *
 *  @param target 监听器
 *  @param action 监听方法
 */
- (void)addTarget:(id)target action:(SEL)action;

- (void)setTitle:(NSString *)title;
- (void)setSubTitle:(NSString *)subTitle;
- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon;
@end
