//
//  LocationManager.m
//  LocationDemo
//
//  Created by hoomsun on 2017/5/23.
//  Copyright © 2017年 hoomsun. All rights reserved.
//

#import "LocationManager.h"
#import "HSInterface+Main.h"
#import "HSAddressInfoModel.h"
#import "ConfirmAlertController.h"                      // AlertVC

#define  EnterForeground @"UIApplicationDidBecomeActiveNotification"

@implementation LocationManager

+ (LocationManager *)sharedManager
{
    static LocationManager *handle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        handle = [[LocationManager alloc] init];
    });
    return handle;
}

- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 100.0f;
        [_locationManager requestWhenInUseAuthorization];
    }
    return _locationManager;
}

#pragma mark - 获取经纬度及用户具体位置的代理方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = [locations lastObject];
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:_currentLocation.coordinate.latitude longitude:_currentLocation.coordinate.longitude];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:newLocation.coordinate.latitude longitude:newLocation.coordinate.longitude];
    double distance = [loc1 distanceFromLocation:loc2];
    if(distance < 10) {
        return;
    }
    self.currentLocation = newLocation;
    NSLog(@"经度：%f  纬度：%f",self.currentLocation.coordinate.longitude,self.currentLocation.coordinate.latitude);
    _longitude = self.currentLocation.coordinate.longitude;
    _latitude = self.currentLocation.coordinate.latitude;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // 反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (!error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                // 省
                NSString *administrativeArea = placemark.administrativeArea;
                _administrativeArea = administrativeArea;
                // 市
                NSString *city = placemark.locality;
                if (!city) {
                    // 6
                    city = placemark.administrativeArea;
                }
                _city = city;
                // 区
                NSString *subLocality = placemark.subLocality;
                _subLocality = subLocality;
                // 省市区拼接为字符串
                NSString *currentCity = [NSString string];
                currentCity = [NSString stringWithFormat:@"%@%@%@",administrativeArea,city,subLocality];
#ifdef DEBUG
                NSLog(@"当前地址：%@",currentCity);
#endif
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                [center postNotificationName:@"LoacationComplete" object:nil];

                [self.locationManager stopUpdatingLocation];
                NSLog(@"停止定位");
            }
            // 定位城市失败
            else if ([placemarks count] == 0) {
            }
        }//网络出故障
        else {
        }
    }];
}



#pragma mark - Func

/// 开始定位
- (void)findCurrentLocation {
    //使用应用期间允许访问位置
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
        NSLog(@"重新定位");
    }
    //总是允许访问位置
    else if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
        NSLog(@"重新定位");
    }
    else
    {
        return;
    }
}

- (BOOL)canLocationAndAuthorization {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (status == kCLAuthorizationStatusAuthorizedAlways ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        return YES;
    }
    else if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
        [self showAlertForLocationWithMessage:@"请打开定位功能"];
        return NO;
    }
    else {
        [SVProgressHUD showInfoWithStatus:@"无法确认您的位置，请退出后重试"];
        return NO;
    }
}

- (void)showAlertForLocationWithMessage:(NSString *)message {
    UIViewController *currentVC = [UIViewController currentViewController];
    __weak typeof(currentVC) weakCurrentVC = currentVC;
    [ConfirmAlertController actionSheetWithTitle:@"提示" message:message confirmTitle:nil cancelTitle:nil actionStyle:UIAlertActionStyleDestructive viewController:weakCurrentVC actionBlock:^(NSInteger confirmIndex, UIAlertAction * _Nullable cancelAction) {
        if (confirmIndex == 0) {
            NSURL *url = nil;
            if ([[UIDevice currentDevice] systemVersion].floatValue < 10.0) {
                url = [NSURL URLWithString:@"prefs:root=LOCATION_SERVICES"];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }else
            {
                url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                    }];
                }
            }
//            //发起通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:EnterForeground object:nil];
//
//            //注册通知（name是通知的名称，这里使用的是UIApplicationDidBecomeActiveNotification，意思是应用程序为当前有效的，就是显示在用户面前时触发）
//            UIApplication *application = [UIApplication sharedApplication];
//            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActive:) name:EnterForeground object:application];
        }
    }];
}


@end
