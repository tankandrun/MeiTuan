//
//  MTSortViewController.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/12.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTSortViewController.h"
#import "MTMetaTool.h"
#import "MTSorts.h"
#import "UIView+Extension.h"
#import "MTConst.h"

@interface MTSortButton : UIButton
@property (nonatomic,strong)MTSorts *sort;
@end

@implementation MTSortButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
    }
    return self;
}
- (void)setSort:(MTSorts *)sort {
    _sort = sort;
    [self setTitle:sort.label forState:UIControlStateNormal];
}
@end

@interface MTSortViewController ()

@end

@implementation MTSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *sorts = [MTMetaTool sorts];
    NSInteger count = sorts.count;
    CGFloat btnW = 100;
    CGFloat btnH = 30;
    CGFloat btnX = 15;
    CGFloat btnStartY = 15;
    CGFloat btnMargin = 15;
    CGFloat height = 0;
    for (NSUInteger i = 0; i < count; i++) {
        MTSortButton *button = [[MTSortButton alloc]init];
        //传递模型
        button.sort = sorts[i];//一个按钮绑定一个模型
        button.width = btnW;
        button.height = btnH;
        button.x = btnX;
        button.y = btnStartY+i*(btnH+btnMargin);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [self.view addSubview:button];
        
        height = CGRectGetMaxY(button.frame);
    }
    //设置控制器在popover中的尺寸
    CGFloat width = btnW+2*btnX;
    height += btnMargin;
    self.preferredContentSize = CGSizeMake(width, height);
}
- (void)buttonClick:(MTSortButton *)button {
    [[NSNotificationCenter defaultCenter]postNotificationName:MTSortDidChangedNotification object:nil userInfo:@{MTSelectedSort : button.sort}];
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
