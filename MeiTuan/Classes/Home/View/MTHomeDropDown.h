//
//  MTHomeDropDown.h
//  MeiTuan
//
//  Created by 金顺度 on 15/10/9.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MTHomeDropDown;
@protocol MTHomeDropdownDataSource <NSObject>
/**
 *  左边的表格一共有几行
 */
- (NSInteger)numberOfRowsInMainTable:(MTHomeDropDown *)homeDropdown;
/**
 *  左边的表格每一行的标题
 *  @param row 行号
 */
- (NSString *)homeDropdown:(MTHomeDropDown *)homeDropdown titleForRowInMainTable:(NSInteger)row;
/**
 *  左边的表格每一行的子数据
 *  @param row 行号
 */
- (NSArray *)homeDropdown:(MTHomeDropDown *)homeDropdown subdataForRowInMainTable:(NSInteger)row;

@optional
/**
 *  左边的表格每一行的图标
 *  @param row 行号
 */
- (NSString *)homeDropdown:(MTHomeDropDown *)homeDropdown iconForRowInMainTable:(NSInteger)row;
/**
 *  左边的表格每一行的高亮图标
 *  @param row 行号
 */
- (NSString *)homeDropdown:(MTHomeDropDown *)homeDropdown selectedIconForRowInMainTable:(NSInteger)row;
@end
@protocol MTHomeDropdownDelegate <NSObject>

@optional
- (void)homeDropdown:(MTHomeDropDown *)homeDropdown didSelectedRowInMainTable:(NSInteger)row;
- (void)homeDropdown:(MTHomeDropDown *)homeDropdown didSelectedRowInSubTable:(NSInteger)subRow inMainTable:(NSInteger)mainRow;

@end

@interface MTHomeDropDown : UIView
+ (instancetype)dropdown;

@property (nonatomic,weak) id<MTHomeDropdownDataSource> dataSource;
@property (nonatomic,weak) id<MTHomeDropdownDelegate> delegate;

@end
