//
//  DeviceInfoUtility.h
//  DFPBannerExample
//
//  Created by Jason Wu on 2015/11/11.
//  Copyright © 2015年 Google. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface DeviceInfoUtility : NSObject

+ (NSString *)modelName;
+ (NSString *)cpuType;
+ (NSString *)systemVersion;
+ (NSString *)languageCode;
+ (CGSize)resolution;
+ (NSString *)UUID;
+ (NSString *)timeZone;
+ (BOOL)isLowEndDevice;
+ (BOOL)isHighEndDevice;
+ (BOOL)isMemoryLessThan1GBDevice;

@end
