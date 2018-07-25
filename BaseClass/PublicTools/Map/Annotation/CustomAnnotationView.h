//
//  CustomAnnotationView.h
//  LDDriverSide
//
//  Created by shandiangou on 2018/6/19.
//  Copyright © 2018年 lightingdog. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "CustomCalloutView.h"

@interface CustomAnnotationView : MAPinAnnotationView

@property (nonatomic, strong) CustomCalloutView *calloutView;

@end
