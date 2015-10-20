//
//  MTMapViewController.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/20.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTMapViewController.h"
#import "UIBarButtonItem+Extension.h"
#import "DPAPI.h"
#import "MTBusiness.h"
#import "MJExtension.h"
#import "MTDeal.h"
#import "MTDealAnnotation.h"
#import "MTMetaTool.h"
#import "MTCategory.h"
#import "MTHomeNavItem.h"
#import "MTCategoryViewController.h"
#import "MTConst.h"
@import MapKit;
@import CoreLocation;

@interface MTMapViewController ()<MKMapViewDelegate,DPRequestDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (copy,nonatomic) NSString *city;
/** 分类item */
@property (nonatomic,weak)UIBarButtonItem *categoryItem;
/** 分类popover */
@property (nonatomic,strong)UIPopoverController *categoryPopover;
@property (nonatomic,strong)NSString *selectedCategoryName;

@property (nonatomic,strong)DPRequest *lastRequest;
@end

@implementation MTMapViewController{
    CLLocationManager *_locationManager;
    CLGeocoder *_geocoder;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 左边的返回
    UINavigationItem *backitem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    //标题
    self.title = @"地图";
    //设置地图跟踪用户的位置
    _locationManager = [[CLLocationManager alloc]init];
    if (![CLLocationManager locationServicesEnabled]||[CLLocationManager authorizationStatus]!=kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager requestWhenInUseAuthorization];
    }
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    _geocoder = [[CLGeocoder alloc]init];
    
    //设置左上角的分类菜单
    MTHomeNavItem *categoryTopItem = [MTHomeNavItem item];
    [categoryTopItem addTarget:self action:@selector(categoryClick)];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc]initWithCustomView:categoryTopItem];
    [categoryTopItem setTitle:nil];
    [categoryTopItem setSubTitle:@"全部分类"];
    [categoryTopItem setIcon:@"icon_category_-1" highIcon:@"icon_category_highlighted_-1"];
    self.categoryItem = categoryItem;
    self.navigationItem.leftBarButtonItems = @[backitem,categoryItem];
    //监听分类改变
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(categoryDidChange:) name:MTCategoryDidChangedNotification object:nil];
}
- (void)categoryClick {
    //显示分类菜单
    self.categoryPopover = [[UIPopoverController alloc]initWithContentViewController:[[MTCategoryViewController alloc]init]];
    [self.categoryPopover presentPopoverFromBarButtonItem:self.categoryItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
- (void)categoryDidChange:(NSNotification *)notification {
    [self.categoryPopover dismissPopoverAnimated:YES];
    //获得要发送给服务器的类型名称
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
    //删除所有的大头针
    [self.mapView removeAnnotations:self.mapView.annotations];
    //重新发送请求给服务器
    [self mapView:self.mapView regionDidChangeAnimated:YES];
    //更换顶部item文字
    MTHomeNavItem *topItem = (MTHomeNavItem *)self.categoryItem.customView;
    [topItem setIcon:category.icon highIcon:category.highlighted_icon];
    [topItem setTitle:category.name];
    [topItem setSubTitle:subcategoryName ? subcategoryName : @"全部"];
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - MKMapViewDelegate
//当用户位置更新了就会调用一次
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    //让地图显示到用户所在的位置
    MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.location.coordinate, MKCoordinateSpanMake(0.25, 0.25));
    [mapView setRegion:region animated:YES];
    
    //反地理编码
    [_geocoder reverseGeocodeLocation:userLocation.location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (error || placemarks.count == 0) {
            return;
        }
        CLPlacemark *placemark = [placemarks firstObject];
        NSString *city = placemark.locality ? placemark.locality : placemark.addressDictionary[@"State"];
        self.city = [city substringToIndex:city.length-1];
        
        //第一次发送请求给服务器
        [self mapView:self.mapView regionDidChangeAnimated:YES];
    }];
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //发送请求给服务器
//    mapView.region.center;
    DPAPI *api = [[DPAPI alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"city"] = self.city;
    params[@"latitude"] = @(mapView.region.center.latitude);
    params[@"longitude"] = @(mapView.region.center.longitude);
    params[@"radius"] = @(5000);
    if (self.selectedCategoryName) {
        params[@"category"] = self.selectedCategoryName;
    }
    self.lastRequest = [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
    
}
#pragma mark - 请求代理
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    if (request != self.lastRequest) {
        return;
    }
    NSLog(@"请求失败 - %@",error);
}
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    if (request != self.lastRequest) {
        return;
    }
//    NSLog(@"请求成功 - %@",result);
    NSArray *deals = [MTDeal objectArrayWithKeyValuesArray:result[@"deals"]];
    for (MTDeal *deal in deals) {
        //团购所属的类型
        MTCategory *category = [MTMetaTool categoryWithDeal:deal];
        
        for (MTBusiness *business in deal.businesses) {
            MTDealAnnotation *anno = [[MTDealAnnotation alloc]init];
            anno.coordinate = CLLocationCoordinate2DMake(business.latitude, business.longitude);
            anno.title = business.name;
            anno.subtitle = deal.title;
            anno.icon = category.map_icon;
            if ([self.mapView.annotations containsObject:anno]) break;
            [self.mapView addAnnotation:anno];
        }
    }
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(MTDealAnnotation *)annotation {
    //返回nil，意味着交给系统处理
    if (![annotation isKindOfClass:[MTDealAnnotation class]]) {
        return nil;
    }
    //创建大头针控件
    static NSString *ID = @"deal";
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:ID];
    if (annoView == nil) {
        annoView = [[MKAnnotationView alloc]initWithAnnotation:nil reuseIdentifier:ID];
        annoView.canShowCallout = YES;
    }
    //设置模型(位置)--传数据
    annoView.annotation = annotation;
    //设置图片
    annoView.image = [UIImage imageNamed:annotation.icon];

    return annoView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
