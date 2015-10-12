//
//  MTCategoryViewController.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/9.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTCategoryViewController.h"
#import "MTHomeDropDown.h"
#import "UIView+Extension.h"
#import "MTCategory.h"
#import "MJExtension.h"
#import "MTMetaTool.h"
#import "MTConst.h"

@interface MTCategoryViewController ()<MTHomeDropdownDataSource,MTHomeDropdownDelegate>
@property (nonatomic,weak)MTHomeDropDown *dropdown;
@end

@implementation MTCategoryViewController
- (void)loadView {
    
    MTHomeDropDown *dropdown = [MTHomeDropDown dropdown];
    dropdown.dataSource = self;
    dropdown.delegate = self;
    self.view = dropdown;
    
    //设置控制器view在popover中的尺寸
    self.preferredContentSize = dropdown.size;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
#pragma mark - MTHomeDropdownDataSource
- (NSInteger)numberOfRowsInMainTable:(MTHomeDropDown *)homeDropdown {
    return [MTMetaTool categories].count;
}
- (NSString *)homeDropdown:(MTHomeDropDown *)homeDropdown titleForRowInMainTable:(NSInteger)row {
    MTCategory *category = [MTMetaTool categories][row];
    return category.name;
}
- (NSString *)homeDropdown:(MTHomeDropDown *)homeDropdown iconForRowInMainTable:(NSInteger)row {
    MTCategory *category = [MTMetaTool categories][row];
    return category.small_icon;
}
- (NSString *)homeDropdown:(MTHomeDropDown *)homeDropdown selectedIconForRowInMainTable:(NSInteger)row {
    MTCategory *category = [MTMetaTool categories][row];
    return category.small_highlighted_icon;
}
- (NSArray *)homeDropdown:(MTHomeDropDown *)homeDropdown subdataForRowInMainTable:(NSInteger)row {
    MTCategory *category = [MTMetaTool categories][row];
    return category.subcategories;
}
#pragma mark - MTHomeDropdownDelegate
- (void)homeDropdown:(MTHomeDropDown *)homeDropdown didSelectedRowInMainTable:(NSInteger)row {
    MTCategory *category = [MTMetaTool categories][row];
    NSLog(@"%@",category.name);
    //发通知
    if (category.subcategories.count == 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:MTCategoryDidChangedNotification object:nil userInfo:@{MTSelectedCategory: category}];
    }
}
- (void)homeDropdown:(MTHomeDropDown *)homeDropdown didSelectedRowInSubTable:(NSInteger)subRow inMainTable:(NSInteger)mainRow {
    MTCategory *category = [MTMetaTool categories][mainRow];
    NSLog(@"%@",category.subcategories[subRow]);
    //发通知
    [[NSNotificationCenter defaultCenter]postNotificationName:MTCategoryDidChangedNotification object:nil userInfo:@{MTSelectedCategory : category,MTSelectedSubCategoryName : category.subcategories[subRow]}];
    
}

@end
