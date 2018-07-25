//
//  MapManager+AMapSearch.m
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/20.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import "MapManager+AMapSearch.h"
#import "ErrorInfoUtility.h"

static char *reGeocodeSearchBlockKey = "reGeocodeSearchBlockKey";

@interface MapManager () <AMapSearchDelegate>

@end



@implementation MapManager (AMapSearch)

#pragma mark - Getter / Setter

- (void)setReGeocodeSearchBlock:(void (^)(NSError *, AMapReGeocode *))reGeocodeSearchBlock {
    objc_setAssociatedObject(self, reGeocodeSearchBlockKey,reGeocodeSearchBlock, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSError *, AMapReGeocode *))reGeocodeSearchBlock {
    return objc_getAssociatedObject(self, reGeocodeSearchBlockKey);
}



#pragma mark - AMapSearch Delegate

- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    if (self.reGeocodeSearchBlock) {
        self.reGeocodeSearchBlock(error, nil);
    }
    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response {
    if (response.regeocode != nil) {
        AMapReGeocode *reGeoCode = response.regeocode;

        if (self.reGeocodeSearchBlock) {
            self.reGeocodeSearchBlock(nil, reGeoCode);
        }
    }
}

@end
