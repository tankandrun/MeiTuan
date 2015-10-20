//
//  MTRegionViewController.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/12.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTRegionViewController.h"
#import "MTHomeDropDown.h"
#import "UIView+Extension.h"
#import "MTCityViewController.h"
#import "MTNavigationController.h"
#import "MTRegion.h"
#import "MTMetaTool.h"
#import "MTConst.h"

@interface MTRegionViewController ()<MTHomeDropdownDataSource,MTHomeDropdownDelegate>
- (IBAction)changCity;

@end

@implementation MTRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建下拉菜单
    UIView *title = [self.view.subviews firstObject];
    MTHomeDropDown *dropdown = [MTHomeDropDown dropdown];
    dropdown.y = title.height;
    dropdown.dataSource = self;
    dropdown.delegate = self;
    [self.view addSubview:dropdown];
    
    //设置控制起在popover中的尺寸
    self.preferredContentSize = CGSizeMake(dropdown.width, CGRectGetMaxY(dropdown.frame));
}
/** 切换城市 */
- (IBAction)changCity {
    [self.popover dismissPopoverAnimated:YES];

    MTCityViewController *city = [[MTCityViewController alloc]init];
    MTNavigationController *nav = [[MTNavigationController alloc]initWithRootViewController:city];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
//    [self presentViewController:nav animated:YES completion:^{
//        NSLog(@"%@,%@",nav,self.presentedViewController);
//    }];
    //modal出来的事MTNavigationController
    //dismiss掉的应该也是MTNavigationController
    
    //self.presentedviewController会引用着被modal出来的控制器
}
#pragma mark - MTHomeDropdownDataSource
- (NSInteger)numberOfRowsInMainTable:(MTHomeDropDown *)homeDropdown
{
    return self.regions.count;
}

- (NSString *)homeDropdown:(MTHomeDropDown *)homeDropdown titleForRowInMainTable:(NSInteger)row
{
    MTRegion *region = self.regions[row];
    return region.name;
}

- (NSArray *)homeDropdown:(MTHomeDropDown *)homeDropdown subdataForRowInMainTable:(NSInteger)row
{
    MTRegion *region = self.regions[row];
    return region.subregions;
}
#pragma mark - MTHomeDropdownDelegate
#pragma mark - MTHomeDropdownDelegate
- (void)homeDropdown:(MTHomeDropDown *)homeDropdown didSelectedRowInMainTable:(NSInteger)row {
    MTRegion *region = self.regions[row];
    NSLog(@"%@",region.name);
    //发通知
    if (region.subregions.count == 0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:MTRegionDidChangedNotification    object:nil userInfo:@{MTSelectedRegion : region}];
    }
}
- (void)homeDropdown:(MTHomeDropDown *)homeDropdown didSelectedRowInSubTable:(NSInteger)subRow inMainTable:(NSInteger)mainRow {
    MTRegion *region = self.regions[mainRow];
    NSLog(@"%@",region.subregions[subRow]);
    //发通知
    [[NSNotificationCenter defaultCenter]postNotificationName:MTRegionDidChangedNotification object:nil userInfo:@{MTSelectedRegion : region,MTSelectedSubRegionName : region.subregions[subRow]}];
    
}

@end