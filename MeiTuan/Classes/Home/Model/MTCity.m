//
//  MTCity.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/10.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTCity.h"
#import "MJExtension.h"
#import "MTRegion.h"
@implementation MTCity
- (NSDictionary *)objectClassInArray {
    return @{@"regions":[MTRegion class]};
}

@end