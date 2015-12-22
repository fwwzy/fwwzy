//
//  ReGeocodeAnnotation.m
//  SearchV3Demo
//
//  Created by songjian on 13-8-26.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "ReGeocodeAnnotation.h"

@interface ReGeocodeAnnotation ()

@property (nonatomic, readwrite, strong) AMapReGeocode *reGeocode;
@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;

@end

@implementation ReGeocodeAnnotation
@synthesize reGeocode  = _reGeocode;
@synthesize coordinate = _coordinate;

#pragma mark - MAAnnotation Protocol

- (NSString *)title
{
    return @"选取位置";
    /*
    NSString *myStr = [NSString stringWithFormat:@"%@%@",
                       self.reGeocode.addressComponent.province,
                       self.reGeocode.addressComponent.city];
    if ([HemaFunction xfunc_check_strEmpty:self.reGeocode.addressComponent.township])
    {
        myStr = self.reGeocode.addressComponent.province;
    }
    NSLog(@"标题：%@",[NSString stringWithFormat:@"%@%@%@%@",
                    self.reGeocode.addressComponent.province,
                    self.reGeocode.addressComponent.city,
                    self.reGeocode.addressComponent.district,
                    self.reGeocode.addressComponent.township]);
    NSLog(@"格式化地址：%@,%@",self.reGeocode.formattedAddress,myStr);
    for (int i = 0; i<self.reGeocode.pois.count; i++)
    {
        AMapPOI *area = [self.reGeocode.pois objectAtIndex:i];
        NSLog(@"兴趣点：%@,%@",area.name,area.address);
    }
    return [self.reGeocode.formattedAddress substringWithRange:NSMakeRange(myStr.length, self.reGeocode.formattedAddress.length-myStr.length)];
    // 包含 省, 市, 区以及乡镇.
    return [NSString stringWithFormat:@"%@%@%@",
            self.reGeocode.addressComponent.city,
            self.reGeocode.addressComponent.district,
            self.reGeocode.addressComponent.township];
    */
}

- (NSString *)subtitle
{
    /*
    NSLog(@"副标题：%@",[NSString stringWithFormat:@"%@,%@",
                     self.reGeocode.addressComponent.neighborhood,
                     self.reGeocode.addressComponent.building]);
    NSLog(@"剩余标题：%@",[NSString stringWithFormat:@"%@,%@",
                     self.reGeocode.addressComponent.streetNumber.street,
                     self.reGeocode.addressComponent.streetNumber.number]);
     */
    NSString *myStr = [NSString stringWithFormat:@"%@%@",
                       self.reGeocode.addressComponent.province,
                       self.reGeocode.addressComponent.city];
    if ([HemaFunction xfunc_check_strEmpty:self.reGeocode.addressComponent.township])
    {
        myStr = self.reGeocode.addressComponent.province;
    }
    return [self.reGeocode.formattedAddress substringWithRange:NSMakeRange(myStr.length, self.reGeocode.formattedAddress.length-myStr.length)];
    /* 包含 社区，建筑. */
    return [NSString stringWithFormat:@"%@%@",
            self.reGeocode.addressComponent.neighborhood,
            self.reGeocode.addressComponent.building];
}

#pragma mark - Life Cycle

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate reGeocode:(AMapReGeocode *)reGeocode
{
    if (self = [super init])
    {
        self.coordinate = coordinate;
        self.reGeocode  = reGeocode;
    }
    
    return self;
}

@end
