//
//  MTHomeNavItem.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/9.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTHomeNavItem.h"
@interface MTHomeNavItem ()
@property (weak, nonatomic) IBOutlet UIButton *iconButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@end
@implementation MTHomeNavItem
- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
}
+ (instancetype)item {
    return [[[NSBundle mainBundle] loadNibNamed:@"MTHomeNavItem" owner:nil options:nil] firstObject];
}
- (void)addTarget:(id)target action:(SEL)action {
    [self.iconButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}
- (void)setSubTitle:(NSString *)subTitle{
    self.subtitleLabel.text = subTitle;
}
- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon{
    [self.iconButton setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [self.iconButton setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
}


@end
