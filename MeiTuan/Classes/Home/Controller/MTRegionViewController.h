//
//  MTRegionViewController.h
//  MeiTuan
//
//  Created by 金顺度 on 15/10/12.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTRegionViewController : UIViewController
@property (nonatomic,strong)NSArray *regions;

@property (nonatomic,weak)UIPopoverController *popover;
@end
