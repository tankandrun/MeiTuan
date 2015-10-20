//
//  MTMetaTool.m
//  MeiTuan
//
//  Created by 金顺度 on 15/10/12.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import "MTMetaTool.h"
#import "MTCity.h"
#import "MTCategory.h"
#import "MJExtension.h"
#import "MTSorts.h"
#import "MTDeal.h"

@implementation MTMetaTool
static NSArray *_cities;
+ (NSArray *)cities {
    if (!_cities) {
        _cities = [MTCity objectArrayWithFilename:@"cities.plist"];
    }
    return _cities;
}
static NSArray *_categories;
+ (NSArray *)categories {
    if (!_categories) {
        _categories = [MTCategory objectArrayWithFilename:@"categories.plist"];
    }
    return _categories;
}
static NSArray *_sorts;
+ (NSArray *)sorts {
    if (!_sorts) {
        _sorts = [MTSorts objectArrayWithFilename:@"sorts.plist"];
    }
    return _sorts;
}
+ (MTCategory *)categoryWithDeal:(MTDeal *)deal {
    NSArray *cs = [self categories];
    NSString *cname = [deal.categories firstObject];
    for (MTCategory *c in cs) {
        if ([cname isEqualToString:c.name]) {
            return c;
        }
        if ([c.subcategories containsObject:cname]) {
            return c;
        }
    }
    return nil;
}
@end
