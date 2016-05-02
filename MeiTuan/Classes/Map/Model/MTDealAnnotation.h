//
//  MTDealAnnotation.h
//  MeiTuan
//
//  Created by soft on 15/10/20.
//  Copyright © 2015年 金顺度. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapKit;
@interface MTDealAnnotation : NSObject <MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *subtitle;
//图片名
@property (nonatomic,copy) NSString *icon;
@end
