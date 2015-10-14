//
//  MTHomeViewController.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/9.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTHomeViewController.h"
#import "MTConst.h"
#import "UIBarButtonItem+Extension.h"
#import "UIView+Extension.h"
#import "MTHomeNavItem.h"
#import "MTHomeDropDown.h"
#import "MTCategoryViewController.h"
#import "MTRegionViewController.h"
#import "MTMetaTool.h"
#import "MTCity.h"
#import "MTRegion.h"
#import "MTSorts.h"
#import "MTCategory.h"
#import "MTSortViewController.h"
#import "MTDeal.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "UIView+AutoLayout.h"
#import "MTSearchViewController.h"
#import "MTNavigationController.h"
#import "MJRefresh.h"
#import "AwesomeMenu.h"
#import "AwesomeMenuItem.h"
#import "MTCollectViewController.h"
#import "MTRecentViewController.h"
@interface MTHomeViewController ()<AwesomeMenuDelegate>
/** 分类item */
@property (nonatomic,weak)UIBarButtonItem *categoryItem;
/** 地区item */
@property (nonatomic,weak)UIBarButtonItem *regionItem;
/** 排序item */
@property (nonatomic,weak)UIBarButtonItem *sortItem;

/** 当前选中的城市 */
@property (nonatomic,copy)NSString *selectedCityName;
/** 当前选中的区域 */
@property (nonatomic,copy)NSString *selectedRegionName;
/** 当前选中的分类 */
@property (nonatomic,copy)NSString *selectedCategoryName;
/** 当前选中的排序 */
@property (nonatomic,strong)MTSorts *selectedSort;

/** 分类popover */
@property (nonatomic,strong)UIPopoverController *categoryPopover;
/** 区域popover */
@property (nonatomic,strong)UIPopoverController *regionPopover;
/** 排序popover */
@property (nonatomic,strong)UIPopoverController *sortPopover;

@end

@implementation MTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNotification];
    //设置导航栏内容
    [self setupLeftNav];
    [self setupRightNav];
    
    //创建awesomemenu
    [self setupAwesomeMenu];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)setNotification {
    //监听分类改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(categoryDidChange:) name:MTCategoryDidChangedNotification object:nil];
    //监听城市改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityDidChange:) name:MTCityDidChangedNotification object:nil];
    //监听区域改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(regionDidChange:) name:MTRegionDidChangedNotification object:nil];
    //监听排序改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sortDidChange:) name:MTSortDidChangedNotification object:nil];
}
- (void)setupAwesomeMenu {
    //1.中间的Item
    AwesomeMenuItem *startItem = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"icon_pathMenu_background_normal"] highlightedImage:[UIImage imageNamed:@"icon_pathMenu_background_highlighted"] ContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"]];
    //2.周边的Item
    AwesomeMenuItem *item0 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_mine_highlighted"]];
    AwesomeMenuItem *item1 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_collect_highlighted"]];
    AwesomeMenuItem *item2 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_scan_highlighted"]];
    AwesomeMenuItem *item3 = [[AwesomeMenuItem alloc]initWithImage:[UIImage imageNamed:@"bg_pathMenu_black_normal"] highlightedImage:nil ContentImage:[UIImage imageNamed:@"icon_pathMenu_more_normal"] highlightedContentImage:[UIImage imageNamed:@"icon_pathMenu_more_highlighted"]];
    
    NSArray *items = @[item0,item1,item2,item3];
    CGRect menuF = CGRectMake(0, 0, 200, 200);
    AwesomeMenu *menu = [[AwesomeMenu alloc]initWithFrame:menuF startItem:startItem optionMenus:items];
    //设置代理
    menu.delegate = self;
    //不要旋转
    menu.rotateAddButton = NO;
    [self.view addSubview:menu];
    //设置菜单的活动范围
    menu.menuWholeAngle = M_PI_2;
    menu.startPoint = CGPointMake(50, 150);
    //设置菜单永远在左下角
    [menu autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [menu autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:0];
    [menu autoSetDimensionsToSize:CGSizeMake(200, 200)];
}
#pragma mark - AwesomeMenuDelegate
- (void)awesomeMenuWillAnimateOpen:(AwesomeMenu *)menu {
    //替换菜单图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_cross_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_cross_highlighted"];
}
- (void)awesomeMenuWillAnimateClose:(AwesomeMenu *)menu {
    //替换菜单图片
    menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_normal"];
    menu.highlightedContentImage = [UIImage imageNamed:@"icon_pathMenu_mainMine_highlighted"];
}
- (void)awesomeMenu:(AwesomeMenu *)menu didSelectIndex:(NSInteger)idx {
    //替换菜单图片
    switch (idx) {
        case 0:
            menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_mine_normal"];
            break;
        case 1:{//收藏
            menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_collect_normal"];
            MTNavigationController *nav = [[MTNavigationController alloc]initWithRootViewController:[[MTCollectViewController alloc]init]];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 2:{//最近浏览
            menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_scan_normal"];
            MTNavigationController *nav = [[MTNavigationController alloc]initWithRootViewController:[[MTRecentViewController alloc]init]];
            [self presentViewController:nav animated:YES completion:nil];
            break;
        }
        case 3:{//更多
            menu.contentImage = [UIImage imageNamed:@"icon_pathMenu_more_normal"];
            break;
        }
        default:
            break;
    }
}
#pragma mark - 监听通知
- (void)cityDidChange:(NSNotification *)notification {
    self.selectedCityName = notification.userInfo[MTSelectedCityName];
    MTLog(@"监听到城市----%@",self.selectedCityName);
    //1.更换顶部区域item的文字
    MTHomeNavItem *topItem = (MTHomeNavItem *)self.regionItem.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - 全部",self.selectedCityName]];
    [topItem setSubTitle:@"全部"];
    //2.刷新表格数据
    [self.collectionView headerBeginRefreshing];
}
- (void)sortDidChange:(NSNotification *)notification {
    self.selectedSort = notification.userInfo[MTSelectedSort];
    //1.更换顶部item文字
    MTHomeNavItem *topItem = (MTHomeNavItem *)self.sortItem.customView;
    [topItem setSubTitle:self.selectedSort.label];
    //2.关闭popover
    [self.sortPopover dismissPopoverAnimated:YES];
    //3.刷新表格数据
    [self.collectionView headerBeginRefreshing];
}
- (void)categoryDidChange:(NSNotification *)notification {
    MTCategory *category = notification.userInfo[MTSelectedCategory];
    NSString *subcategoryName = notification.userInfo[MTSelectedSubCategoryName];
    if (subcategoryName == nil || [subcategoryName isEqualToString:@"全部"]) {
        self.selectedCategoryName = category.name;
    }else {
        self.selectedCategoryName = subcategoryName;
    }
    if ([self.selectedCategoryName isEqualToString:@"全部分类"]) {
        self.selectedCategoryName = nil;
    }
    //1.更换顶部item文字
    MTHomeNavItem *topItem = (MTHomeNavItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubTitle:subcategoryName ? subcategoryName : @"全部"];
    //2.关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    //3.刷新表格数据
    [self.collectionView headerBeginRefreshing];
}
- (void)regionDidChange:(NSNotification *)notification {
    MTRegion *region = notification.userInfo[MTSelectedRegion];
    NSString *subregionName = notification.userInfo[MTSelectedSubRegionName];
    if (subregionName == nil || [subregionName isEqualToString:@"全部"]) {
        self.selectedRegionName = region.name;
    }else {
        self.selectedRegionName = subregionName;
    }
    if ([self.selectedRegionName isEqualToString:@"全部"]) {
        self.selectedRegionName = nil;
    }
    //1.更换顶部item文字
    MTHomeNavItem *topItem = (MTHomeNavItem *)self.regionItem.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - %@",self.selectedCityName,region.name]];
    [topItem setSubTitle:subregionName ? subregionName : @"全部"];
    //2.关闭popover
    [self.regionPopover dismissPopoverAnimated:YES];
    //3.刷新表格数据
    [self.collectionView headerBeginRefreshing];
}
#pragma mark - 实现父类提供的方法
- (void)setupParams:(NSMutableDictionary *)params {
    //城市
    params[@"city"] = self.selectedCityName;
    //分类
    if (self.selectedCategoryName) {//一开始是nil
        params[@"category"] = self.selectedCategoryName;
    }
    //排序
    if (self.selectedSort) {
        params[@"sort"] = @(self.selectedSort.value);
    }
    //区域
    if (self.selectedRegionName) {
        params[@"region"] = self.selectedRegionName;
    }
}
#pragma mark - 设置导航栏内容
- (void)setupLeftNav {
    //1.LOGO
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    logoItem.enabled = NO;
    //2.类别
    MTHomeNavItem *categoryTopItem = [MTHomeNavItem item];
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc]initWithCustomView:categoryTopItem];
    [categoryTopItem setTitle:nil];
    [categoryTopItem setSubTitle:@"全部分类"];
    [categoryTopItem setIcon:@"icon_category_-1" highIcon:@"icon_category_highlighted_-1"];
    self.categoryItem = categoryItem;
    //3.地区
    MTHomeNavItem *regionTopItem = [MTHomeNavItem item];
    [regionTopItem setTitle:nil];
    [regionTopItem setSubTitle:@"选择城市"];
    [regionTopItem addTarget:self action:@selector(regionClick)];
    UIBarButtonItem *regionItem = [[UIBarButtonItem alloc]initWithCustomView:regionTopItem];
    self.regionItem = regionItem;
    //4.排序
    MTHomeNavItem *sortTopItem = [MTHomeNavItem item];
    [sortTopItem setTitle:@"排序"];
    [sortTopItem setSubTitle:@"默认排序"];
    [sortTopItem setIcon:@"icon_sort" highIcon:@"icon_sort_highlighted"];
    [sortTopItem addTarget:self action:@selector(sortClick)];
    UIBarButtonItem *sortItem = [[UIBarButtonItem alloc]initWithCustomView:sortTopItem];
    self.sortItem = sortItem;
    
    self.navigationItem.leftBarButtonItems = @[logoItem,categoryItem,regionItem,sortItem];
}
- (void)setupRightNav {
    UIBarButtonItem *mapItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_map" highImage:@"icon_map_highlighted"];
    mapItem.customView.width = 60;
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:self action:@selector(search) image:@"icon_search" highImage:@"icon_search_highlighted"];
    searchItem.customView.width = 60;
    self.navigationItem.rightBarButtonItems = @[mapItem,searchItem];
}
#pragma mark - 顶部item点击
- (void)search {
    if (self.selectedCityName) {
        MTSearchViewController *searchVC = [[MTSearchViewController alloc]init];
        searchVC.cityName = self.selectedCityName;
        MTNavigationController *nav = [[MTNavigationController alloc]initWithRootViewController:[[MTSearchViewController alloc]init]];
        [self presentViewController:nav animated:YES completion:nil];
    }else {
        [MBProgressHUD showError:@"请选择城市再搜索" toView:self.view];
    }
}
- (void)categoryClick {
    //显示分类菜单
    self.categoryPopover = [[UIPopoverController alloc]initWithContentViewController:[[MTCategoryViewController alloc]init]];
    [self.categoryPopover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
} 
- (void)regionClick {
    MTRegionViewController *region = [[MTRegionViewController alloc]init];
    if (self.selectedCityName) {
        //获得当前选中城市的区域
        MTCity *city = [[[MTMetaTool cities]filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@",self.selectedCityName]]firstObject];
        region.regions = city.regions;
    }
    //显示地区菜单
    self.regionPopover = [[UIPopoverController alloc]initWithContentViewController:region];
    [self.regionPopover presentPopoverFromBarButtonItem:self.regionItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    region.popover = self.regionPopover;
}
- (void)sortClick {
    //显示排序菜单
    self.sortPopover = [[UIPopoverController alloc]initWithContentViewController:[[MTSortViewController alloc]init]];
    [self.sortPopover presentPopoverFromBarButtonItem:self.sortItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
@end
