//
//  MTRecentViewController.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/14.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTRecentViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "MTConst.h"
#import "MTDealTool.h"
#import "MTDealCell.h"
#import "UIView+Extension.h"
#import "UIView+AutoLayout.h"
#import "MTDetailViewController.h"
#import "MJRefresh.h"
#import "MTDeal.h"

NSString *const MTDeleteALL = @"全部删除";

#define MTString(str) [NSString stringWithFormat:@"  %@  ", str]


@interface MTRecentViewController ()
@property (nonatomic, weak) UIImageView *noDataView;
@property (nonatomic, strong) NSMutableArray *deals;
@property (nonatomic, assign) int currentPage;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@end

@implementation MTRecentViewController

- (UIBarButtonItem *)backItem{
    if (!_backItem) {
        self.backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    }
    return _backItem;
}
- (NSMutableArray *)deals{
    if (!_deals) {
        self.deals = [[NSMutableArray alloc] init];
    }
    return _deals;
}

- (UIImageView *)noDataView{
    if (!_noDataView) {
        // 添加一个"没有数据"的提醒
        UIImageView *noDataView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_latestBrowse_empty"]];
        [self.view addSubview:noDataView];
        [noDataView autoCenterInSuperview];
        _noDataView = noDataView;
    }
    return _noDataView;
}

static NSString * const reuseIdentifier = @"deal";

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //cell的大小
    layout.itemSize = CGSizeMake(305, 305);
    return [self initWithCollectionViewLayout:layout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"最近浏览";
    self.collectionView.backgroundColor = MTGlobalBg;

    // 左边的返回
    self.navigationItem.leftBarButtonItems = @[self.backItem];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"MTDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.alwaysBounceVertical = YES;
    
    // 加载第一页的收藏数据
    [self loadMoreDeals];
    
    // 监听收藏状态改变的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(collectStateChange:) name:MTCollectStateDidChangedNotification object:nil];
    
    // 添加上拉加载
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    
    // 设置导航栏内容
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:MTDeleteALL style:UIBarButtonItemStyleDone target:self action:@selector(delateAll:)];
    
    
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//删除全部按钮
- (void)delateAll:(UIBarButtonItem *)item {
    
    for (MTDeal *deal in self.deals) {
        [MTDealTool removeRecentDeal:deal];
    }
    
    [self.deals removeObjectsInArray:[self.deals copy]];
    [self.collectionView reloadData];
}

- (void)loadMoreDeals {
    //增加页码
    self.currentPage++;
    //增加新数据
    [self.deals addObjectsFromArray:[MTDealTool recentDeals:self.currentPage]];
    //刷新表格
    [self.collectionView reloadData];
}

- (void)collectStateChange:(NSNotification *)notification {
    [self.deals removeAllObjects];
    self.currentPage = 0;
    [self loadMoreDeals];
}
/**
 当屏幕旋转,控制器view的尺寸发生改变调用
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    // 根据屏幕宽度决定列数
    int cols = (size.width == 1024) ? 3 : 2;
    
    // 根据列数计算内边距
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    CGFloat inset = (size.width - cols * layout.itemSize.width) / (cols + 1);
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);
    
    // 设置每一行之间的间距
    layout.minimumLineSpacing = 50;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 计算一遍内边距
    [self viewWillTransitionToSize:CGSizeMake(collectionView.width, 0) withTransitionCoordinator:nil];
    
    // 控制尾部控件的显示和隐藏
//    self.collectionView.footerHidden = (self.deals.count == [MTDealTool collectDealsCount]);
    
    // 控制"没有数据"的提醒
    self.noDataView.hidden = (self.deals.count != 0);
    return self.deals.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MTDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.deal = self.deals[indexPath.item];
    cell.delegate = self;
    return cell;
}


#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MTDetailViewController *detailVc = [[MTDetailViewController alloc] init];
    detailVc.deal = self.deals[indexPath.item];
    [self presentViewController:detailVc animated:YES completion:nil];
}

@end
