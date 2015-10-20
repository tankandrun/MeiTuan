//
//  MTDeal.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/13.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTDeal.h"
#import "MJExtension.h"
#import "MTBusiness.h"
@implementation MTDeal
- (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"desc" : @"description"};
}
- (NSDictionary *)objectClassInArray {
    return @{@"businesses":[MTBusiness class]};
}
- (BOOL)isEqual:(MTDeal *)other {
    return [self.deal_id isEqual:other.deal_id];
}
MJCodingImplementation
@end
