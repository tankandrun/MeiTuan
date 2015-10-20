//
//  MTDetailViewController.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/14.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTDetailViewController.h"
#import "MTDeal.h"
#import "MTConst.h"
#import "MTCenterLineLabel.h"
#import "DPAPI.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "MJExtension.h"
#import "MTDealTool.h"
#import "MBProgressHUD.h"
@interface MTDetailViewController ()<UIWebViewDelegate,DPRequestDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
- (IBAction)back:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet MTCenterLineLabel *priceLabel;

@property (weak, nonatomic) IBOutlet UIButton *first;
@property (weak, nonatomic) IBOutlet UIButton *second;
@property (weak, nonatomic) IBOutlet UIButton *Third;
@property (weak, nonatomic) IBOutlet UIButton *Forth;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *buyNowButton;

- (IBAction)buy:(id)sender;
- (IBAction)collect:(id)sender;
- (IBAction)share:(id)sender;

//ShareSDK
//友盟分享
//百度分享

@end

@implementation MTDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //打开一个团购 --> 访问了这个团购 --> 增加到最近访问
    
    //基本设置
    self.view.backgroundColor = MTGlobalBg;
    //加载网页
    self.webView.hidden = YES;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.deal.deal_h5_url]]];
    //设置基本信息
    [self.image sd_setImageWithURL:[NSURL URLWithString:self.deal.image_url]];
    self.titleLabel.text = self.deal.title;
    self.detailLabel.text = self.deal.desc;
    self.priceLabel.text = [NSString stringWithFormat:@"¥ %@",self.deal.list_price];
    self.currentLabel.text = [NSString stringWithFormat:@"¥ %@",self.deal.current_price];
    NSUInteger dotLoc = [self.currentLabel.text rangeOfString:@"."].location;
    if (dotLoc != NSNotFound) {
        // 超过2位小数
        if (self.currentLabel.text.length - dotLoc > 3) {
            self.currentLabel.text = [self.currentLabel.text substringToIndex:dotLoc + 3];//截取
        }
    }
    [self.Forth setTitle:[NSString stringWithFormat:@"已售%d",self.deal.purchase_count] forState:UIControlStateNormal];
    //获取剩余时间
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSDate *dead = [fmt dateFromString:self.deal.purchase_deadline];
    //追加一天
    [dead dateByAddingTimeInterval:24*3600];
    NSDate *now = [NSDate date];
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmp = [[NSCalendar currentCalendar]components:unit fromDate:now toDate:dead options:0];
    if (cmp.day > 365) {
        [self.Third setTitle:@"一年内不过期" forState:UIControlStateNormal];
    }else {
        [self.Third setTitle:[NSString stringWithFormat:@"剩余%ld天%ld小时%ld分",cmp.day,cmp.hour,cmp.minute] forState:UIControlStateNormal];
    }
    
    //发送请求获取更详细的团购数据
    DPAPI *api = [[DPAPI alloc]init];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"deal_id"] = self.deal.deal_id;
    [api requestWithURL:@"v1/deal/get_single_deal" params:params delegate:self];
    
    //设置收藏状态
    self.collectButton.selected = [MTDealTool isCollected:self.deal];
}
/**
 *  控制器支持的方向
 */
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
#pragma mark - DPRequestDelegate
- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    self.deal = [MTDeal objectWithKeyValues:[result[@"deals"] firstObject]];
    self.first.selected = self.deal.restrictions.is_refundable;
    self.second.selected = self.deal.restrictions.is_refundable;
}
- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    
    MTLog(@"%@",error.userInfo);
    [MBProgressHUD showError:@"网络繁忙" toView:self.view];
    
}
#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([webView.request.URL.absoluteString isEqualToString:self.deal.deal_h5_url]) {
        //旧的HTML5页面加载完毕
            NSString *ID = [self.deal.deal_id substringFromIndex:[self.deal.deal_id rangeOfString:@"-"].location+1];
            NSString *urlStr = [NSString stringWithFormat:@"http://m.dianping.com/tuan/deal/moreinfo/%@",ID];
            [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    }else {//详情页面加载完毕
        //获得网页
//        NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('html')[0].outerHTML;"];
//        NSLog(@"%@",html);
        //用来拼接所有的js
        NSMutableString *js = [NSMutableString string];
        // 删除header
        [js appendString:@"var header = document.getElementsByTagName('header')[0];"];
        [js appendString:@"header.parentNode.removeChild(header);"];
        // 删除顶部的购买
        [js appendString:@"var box = document.getElementsByClassName('cost-box')[0];"];
        [js appendString:@"box.parentNode.removeChild(box);"];
        // 删除底部的购买
        [js appendString:@"var buyNow = document.getElementsByClassName('buy-now')[0];"];
        [js appendString:@"buyNow.parentNode.removeChild(buyNow);"];
        //利用webView执行JS
        [webView stringByEvaluatingJavaScriptFromString:js];
        
        //显示webView
        webView.hidden = NO;
        //隐藏正在加载
        [self.loadingView stopAnimating];
    }
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    return YES;
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)buy:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.deal.deal_url]];
}
- (IBAction)collect:(id)sender {
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    info[MTCollectDealKey] = self.deal;
    
    if (self.collectButton.isSelected) {//取消收藏
        [MTDealTool removeCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"取消收藏成功" toView:self.view];
    }else {//收藏
        [MTDealTool addCollectDeal:self.deal];
        [MBProgressHUD showSuccess:@"收藏成功" toView:self.view];
    }
    self.collectButton.selected = !self.collectButton.isSelected;
    //发出通知
    [[NSNotificationCenter defaultCenter]postNotificationName:MTCollectStateDidChangedNotification object:nil userInfo:info];
    
}
- (IBAction)share:(id)sender {
    
}
@end
