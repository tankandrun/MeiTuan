//
//  MTHomeDropDown.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/9.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTHomeDropDown.h"
#import "MTHomeDropdownMainCell.h"
#import "MTHomeDropdownSubCell.h"
@interface MTHomeDropDown () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;

/** 左边主表选中的行号 */
@property (nonatomic,assign)NSInteger selectedMainRow;

@end
@implementation MTHomeDropDown

+ (instancetype)dropdown {
    return [[[NSBundle mainBundle]loadNibNamed:@"MTHomeDropDown" owner:nil options:nil] firstObject];
}
- (void)awakeFromNib {//唤醒界面的时候触发
    //不需要跟随父控件的尺寸变化而伸缩
    self.autoresizingMask = UIViewAutoresizingNone;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        return [self.dataSource numberOfRowsInMainTable:self];
    }else {
        return [self.dataSource homeDropdown:self subdataForRowInMainTable:self.selectedMainRow].count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (tableView == self.mainTableView) {//主表
        cell = [MTHomeDropdownMainCell cellWithTableView:tableView];
        //取出模型数据
        cell.textLabel.text = [self.dataSource homeDropdown:self titleForRowInMainTable:indexPath.row];
        if ([self.dataSource respondsToSelector:@selector(homeDropdown:iconForRowInMainTable:)]) {
            cell.imageView.image = [UIImage imageNamed:[self.dataSource homeDropdown:self iconForRowInMainTable:indexPath.row]];
        }
        if ([self.dataSource respondsToSelector:@selector(homeDropdown:selectedIconForRowInMainTable:)]) {
            cell.imageView.highlightedImage = [UIImage imageNamed:[self.dataSource homeDropdown:self selectedIconForRowInMainTable:indexPath.row]];
        }
        NSArray *subdata = [self.dataSource homeDropdown:self subdataForRowInMainTable:indexPath.row];
        if (subdata.count) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else {//从表
        cell = [MTHomeDropdownSubCell cellWithTableView:tableView];
        NSArray *subdata = [self.dataSource homeDropdown:self subdataForRowInMainTable:self.selectedMainRow];
        //显示文字
        cell.textLabel.text = subdata[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        //被点击的分类
        self.selectedMainRow = indexPath.row;
        //刷新右边的数据
        [self.subTableView reloadData];
        
        //通知代理
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectedRowInMainTable:)]) {
            [self.delegate homeDropdown:self didSelectedRowInMainTable:indexPath.row];
        }
    }else {
        //通知代理
        if ([self.delegate respondsToSelector:@selector(homeDropdown:didSelectedRowInSubTable:inMainTable:)]) {
            [self.delegate homeDropdown:self didSelectedRowInSubTable:indexPath.row inMainTable:self.selectedMainRow];
        }
    }
    
}

@end
