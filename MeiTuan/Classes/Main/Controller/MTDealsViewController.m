//
//  MTDealsViewController.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/13.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTDealsViewController.h"
#import "MJRefresh.h"
#import "DPAPI.h"
#import "MTDealCell.h"
#import "UIView+AutoLayout.h"
#import "MTConst.h"
#import "MJExtension.h"
#import "MTDeal.h"
#import "UIView+Extension.h"
#import "MBProgressHUD+MJ.h"
@interface MTDealsViewController ()<DPRequestDelegate>
/** 所有团购数据*/
@property (nonatomic,strong)NSMutableArray *deals;
@property (nonatomic,weak)UIImageView *noDataView;
/** 总数 */
@property (nonatomic,assign)int *total_count;
/** 记录当前页码 */
@property (nonatomic,assign)int currentPage;
/** 保存最后一个请求 */
@property (nonatomic,weak)DPRequest *lastRequest;

@end

@implementation MTDealsViewController

static NSString * const reuseIdentifier = @"deal";
- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //cell的大小
    layout.itemSize = CGSizeMake(305, 305);
    return [self initWithCollectionViewLayout:layout];
}
- (NSMutableArray *)deals {
    if (!_deals) {
        self.deals = [[NSMutableArray alloc]init];
    }
    return _deals;
}
- (UIImageView *)noDataView {
    if (!_noDataView) {
        //添加一个没有数据的提醒
        UIImageView *noDataView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_deals_empty"]];
        noDataView.hidden = YES;
        [self.view addSubview:noDataView];
        [noDataView autoCenterInSuperview];
        self.noDataView = noDataView;
    }
    return _noDataView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置背景色
    self.collectionView.backgroundColor = MTGlobalBg;
    //Register cell classes
    [self.collectionView  registerNib:[UINib nibWithNibName:@"MTDealCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.collectionView.alwaysBounceVertical = YES;//横屏可以拉动
    //添加上拉加载
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreDeals)];
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewDeals)];
}
/**
 *  当屏幕旋转，控制器view的尺寸发生改变调用
 */
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    //根据屏幕宽度设置列数
    int cols = size.width == 1024 ? 3 : 2;
    //根据列数计算内边距
    CGFloat inset = (size.width - cols*layout.itemSize.width)/(cols+1);
    layout.sectionInset = UIEdgeInsetsMake(inset, inset, inset, inset);//总的collectionView的外边距
    //设置每个cell竖直方向上的间距
    layout.minimumLineSpacing = inset;
}
#pragma mark - 跟服务器交互
- (void)loadDeals {
    DPAPI *api = [[DPAPI alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //每页10条
    params[@"limit"] = @10;
    //页码
    params[@"page"] = @(self.currentPage);
    //调用子类实现方法
    [self setupParams:params];
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}
- (void)loadNewDeals {
    self.currentPage = 1;
    [self loadDeals];
}
- (void)loadMoreDeals {
    self.currentPage++;
    [self loadDeals];
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    if (request != self.lastRequest) {
        return;
    }
    self.total_count = [result[@"total_count"] intValue];
    //1.取出团购的字典数组
    NSArray *newDeals = [MTDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    //加载第一页数据
    if (self.currentPage == 1) {
        [self.deals removeAllObjects];//清除之前的数据
    }
    [self.deals addObjectsFromArray:newDeals];
    //2.刷新表格
    [self.collectionView reloadData];
    //3.结束上拉加载
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    //1.提醒失败
#warning 在支持横竖屏的情况下，HUD信息最好不要添加到windouw上
    MTLog(@"%@",error.userInfo);
    [MBProgressHUD showError:@"网络繁忙" toView:self.view];
    //2.结束刷新
    [self.collectionView headerEndRefreshing];
    [self.collectionView footerEndRefreshing];
    //3.如果上拉加载失败
    if (self.currentPage > 1) {
        self.currentPage --;
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //计算一遍内边距
    [self viewWillTransitionToSize:CGSizeMake(collectionView.width, 0) withTransitionCoordinator:nil];
    //控制没有数据提醒控件的显示和隐藏
    self.noDataView.hidden = (self.deals.count != 0);
    //控制尾部刷新控件的显示和隐藏
    self.collectionView.footerHidden = self.total_count == self.deals.count;
    return self.deals.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MTDealCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.deal = self.deals[indexPath.item];
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

@end
