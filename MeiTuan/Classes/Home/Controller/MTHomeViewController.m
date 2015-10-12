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
@interface MTHomeViewController ()
/** 分类item */
@property (nonatomic,weak)UIBarButtonItem *categoryItem;
/** 地区item */
@property (nonatomic,weak)UIBarButtonItem *regionItem;
/** 排序item */
@property (nonatomic,weak)UIBarButtonItem *sortItem;

/** 当前选中的城市 */
@property (nonatomic,copy)NSString *selectedCityName;

/** 分类popover */
@property (nonatomic,strong)UIPopoverController *categoryPopover;
/** 区域popover */
@property (nonatomic,strong)UIPopoverController *regionPopover;
/** 排序popover */
@property (nonatomic,strong)UIPopoverController *sortPopover;
@end

@implementation MTHomeViewController

static NSString * const reuseIdentifier = @"Cell";
- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    return [self initWithCollectionViewLayout:layout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置背景色
    self.collectionView.backgroundColor = MTGlobalBg;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    //监听分类改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(categoryDidChange:) name:MTCategoryDidChangedNotification object:nil];
    //监听城市改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cityDidChange:) name:MTCityDidChangedNotification object:nil];
    //监听区域改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(regionDidChange:) name:MTRegionDidChangedNotification object:nil];
    //监听排序改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sortDidChange:) name:MTSortDidChangedNotification object:nil];
    
    //设置导航栏内容
    [self setupLeftNav];
    [self setupRightNav];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - 监听通知
- (void)cityDidChange:(NSNotification *)notification {
    self.selectedCityName = notification.userInfo[MTSelectedCityName];
    MTLog(@"监听到城市----%@",self.selectedCityName);
    //1.更换顶部区域item的文字
    MTHomeNavItem *topItem = (MTHomeNavItem *)self.regionItem.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - 全部",self.selectedCityName]];
    [topItem setSubTitle:nil];
    //2.刷新表格数据
#warning TODO
}
- (void)sortDidChange:(NSNotification *)notification {
    MTSorts *sort = notification.userInfo[MTSelectedSort];
    //1.更换顶部item文字
    MTHomeNavItem *topItem = (MTHomeNavItem *)self.sortItem.customView;
    [topItem setSubTitle:sort.label];
    //2.关闭popover
    [self.sortPopover dismissPopoverAnimated:YES];
    //3.刷新表格数据
#warning TODO
}
- (void)categoryDidChange:(NSNotification *)notification {
    MTCategory *category = notification.userInfo[MTSelectedCategory];
    NSString *subcategoryName = notification.userInfo[MTSelectedSubCategoryName];
    //1.更换顶部item文字
    MTHomeNavItem *topItem = (MTHomeNavItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubTitle:subcategoryName ? subcategoryName : @"全部"];
    //2.关闭popover
    [self.categoryPopover dismissPopoverAnimated:YES];
    //3.刷新表格数据
#warning TODO
}
- (void)regionDidChange:(NSNotification *)notification {
    MTRegion *region = notification.userInfo[MTSelectedRegion];
    NSString *subregionName = notification.userInfo[MTSelectedSubRegionName];
    //1.更换顶部item文字
    MTHomeNavItem *topItem = (MTHomeNavItem *)self.regionItem.customView;
    [topItem setTitle:[NSString stringWithFormat:@"%@ - %@",self.selectedCityName,region.name]];
    [topItem setSubTitle:subregionName ? subregionName : @"全部"];
    //2.关闭popover
    [self.regionPopover dismissPopoverAnimated:YES];
    //3.刷新表格数据
#warning TODO
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
    [categoryTopItem setSubTitle:nil];
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
    UIBarButtonItem *searchItem = [UIBarButtonItem itemWithTarget:nil action:nil image:@"icon_search" highImage:@"icon_search_highlighted"];
    searchItem.customView.width = 60;
    self.navigationItem.rightBarButtonItems = @[mapItem,searchItem];
}
#pragma mark - 顶部item点击
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
#warning Incomplete implementation, return the number of sections
    return 0;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
