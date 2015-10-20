//
//  MTDealAnnotation.m
//  MeiTuan
//
//  Created by soft on 15/10/20.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTDealAnnotation.h"

@implementation MTDealAnnotation
- (BOOL)isEqual:(MTDealAnnotation *)other {
    return [self.title isEqual:other.title];
}
@end
