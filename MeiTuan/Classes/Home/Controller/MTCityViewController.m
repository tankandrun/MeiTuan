//
//  MTCityViewController.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/10.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTCityViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MJExtension.h"
#import "MTCityGroups.h"
#import "MTConst.h"
#import "MTCitySearchResultViewController.h"
#import "UIView+AutoLayout.h"

const int MTCovewTag = 999;

@interface MTCityViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIButton *cover;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *cityGroups;
@property (nonatomic,weak) MTCitySearchResultViewController *citySearchResult;
@end

@implementation MTCityViewController
- (MTCitySearchResultViewController *)citySearchResult {
    if (!_citySearchResult) {
        MTCitySearchResultViewController *citySearchResult = [[MTCitySearchResultViewController alloc]init];
        [self addChildViewController:citySearchResult];
        self.citySearchResult = citySearchResult;
        
        [self.view addSubview:self.citySearchResult.view];
        [self.citySearchResult.view autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeTop];//和父空间间距都为0,不包含上边
        [self.citySearchResult.view autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.searchBar withOffset:10];//当前控制器的顶部距离搜索框的底部多少距离
    }
    return _citySearchResult;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //基本设置
    self.title = @"切换城市";
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(close) image:@"btn_navigation_close" highImage:@"btn_navigation_close_hl"];
    //加载城市数据
    self.cityGroups = [MTCityGroups objectArrayWithFilename:@"cityGroups.plist"];
    
    self.searchBar.tintColor = MTColor(32,191,179);
}
- (void)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UISearchBarDelegate
/**
 *  键盘弹出：搜索框开始编辑文字
 */
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    //1.隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //2.修改搜索框的背景图片
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield_hl"]];
    //3.显示搜索框右边的取消按钮
    [searchBar setShowsCancelButton:YES animated:YES];
    //4.显示遮盖
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha = 0.5;
    }];
}
/**
 *  键盘退下：搜索框结束编辑文字
 */
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    //1.出现导航栏
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //2.修改搜索框的背景图片
    [searchBar setBackgroundImage:[UIImage imageNamed:@"bg_login_textfield"]];
    //3.隐藏搜索框右边的取消按钮
    [searchBar setShowsCancelButton:NO animated:YES];
    //4.移除遮盖
    [UIView animateWithDuration:0.5 animations:^{
        self.cover.alpha = 0;
    }];
    //5.移除搜索结果,清掉文字
    self.citySearchResult.view.hidden = YES;
    searchBar.text = nil;
    
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}
/**
 *  搜索框里面的文字变化的时候调用
 */
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length) {
        self.citySearchResult.view.hidden = NO;
        self.citySearchResult.searchText = searchText;
    }else {
        self.citySearchResult.view.hidden = YES;
    }
}
/**
  *  点击遮盖
  */
- (IBAction)coverClick {
    [self.searchBar resignFirstResponder];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.cityGroups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    MTCityGroups *groups = self.cityGroups[section];
    return groups.cities.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"city";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    MTCityGroups *group = self.cityGroups[indexPath.section];
    cell.textLabel.text = group.cities[indexPath.row];
    
    return cell;
}
#pragma mark - UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    MTCityGroups *group = self.cityGroups[section];
    return group.title;
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return [self.cityGroups valueForKeyPath:@"title"];//将self.cityGroups中的title属性取出来存在一个数组中返回
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MTCityGroups *group = self.cityGroups[indexPath.section];
    //发出通知
    [[NSNotificationCenter defaultCenter]postNotificationName:MTCityDidChangedNotification object:nil userInfo:@{MTSelectedCityName : group.cities[indexPath.row]}];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
