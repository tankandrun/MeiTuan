//
//  MTSetUpViewController.m
//  MeiTuan
//
//  Created by 金顺度 on 16/5/2.
//  Copyright © 2016年 金顺度. All rights reserved.
//

#import "MTSetUpViewController.h"
#import "MTConst.h"
#import "UIBarButtonItem+Extension.h"

@interface MTSetUpViewController ()
@property (nonatomic, strong) UIBarButtonItem *backItem;

@end

@implementation MTSetUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    self.view.backgroundColor = MTGlobalBg;
    
    // 左边的返回
    self.navigationItem.leftBarButtonItems = @[self.backItem];
}
- (UIBarButtonItem *)backItem{
    if (!_backItem) {
        _backItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) image:@"icon_back" highImage:@"icon_back_highlighted"];
    }
    return _backItem;
}
- (void)back {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
