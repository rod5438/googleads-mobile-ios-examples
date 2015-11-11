//
//  DeviceInfoUtility.m
//  DFPBannerExample
//
//  Created by Jason Wu on 2015/11/11.
//  Copyright © 2015年 Google. All rights reserved.
//

#import <sys/utsname.h>
#include <sys/types.h>
#include <sys/sysctl.h>
#include <mach/machine.h>
#import "DeviceInfoUtility.h"

#define VERSION_GREATER_THAN_OR_EQUAL_TO(u, v)  ([u compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  VERSION_GREATER_THAN_OR_EQUAL_TO([[UIDevice currentDevice] systemVersion], v)

NSString * const DEVICE_UUID = @"DeviceUUID";

@implementation DeviceInfoUtility

/*  Get device model name
 @"i386"      on the simulator
 @"iPod1,1"   on iPod Touch
 @"iPod2,1"   on iPod Touch Second Generation
 @"iPod3,1"   on iPod Touch Third Generation
 @"iPod4,1"   on iPod Touch Fourth Generation
 @"iPhone1,1" on iPhone
 @"iPhone1,2" on iPhone 3G
 @"iPhone2,1" on iPhone 3GS
 @"iPad1,1"   on iPad
 @"iPad2,1"   on iPad 2
 @"iPad3,1"   on 3rd Generation iPad
 @"iPhone3,1" on iPhone 4
 @"iPhone4,1" on iPhone 4S
 @"iPhone5,1" on iPhone 5 (model A1428, AT&T/Canada)
 @"iPhone5,2" on iPhone 5 (model A1429, everything else)
 @"iPad3,4" on 4th Generation iPad
 @"iPad2,5" on iPad Mini
 @"iPhone5,3" on iPhone 5c (model A1456, A1532 | GSM)
 @"iPhone5,4" on iPhone 5c (model A1507, A1516, A1526 (China), A1529 | Global)
 @"iPhone6,1" on iPhone 5s (model A1433, A1533 | GSM)
 @"iPhone6,2" on iPhone 5s (model A1457, A1518, A1528 (China), A1530 | Global)
 @"iPad4,1" on 5th Generation iPad (iPad Air) - Wifi
 @"iPad4,2" on 5th Generation iPad (iPad Air) - Cellular
 @"iPad4,4" on 2nd Generation iPad Mini - Wifi
 @"iPad4,5" on 2nd Generation iPad Mini - Cellular
 */
+ (NSString *)modelName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine
                                            encoding:NSUTF8StringEncoding];
    
    return platform;
}

+ (NSString *)cpuType
{
    return getCPUType();
}

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)languageCode
{
    NSDictionary *languageMap = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"ar",    @"ar",
                                 @"ca-ES", @"ca",
                                 @"cs-CZ", @"cs",
                                 @"da-DK", @"da",
                                 @"de-DE", @"de",
                                 @"el-GR", @"el",
                                 @"en-GB", @"en-GB",
                                 @"en-US", @"en",
                                 @"es-ES", @"es",
                                 @"fi-FI", @"fi",
                                 @"fr-FR", @"fr",
                                 @"he-IL", @"he",
                                 @"hr-HR", @"hr",
                                 @"hu-HU", @"hu",
                                 @"it-IT", @"it",
                                 @"id",    @"id",
                                 @"ja-JP", @"ja",
                                 @"ko-KR", @"ko",
                                 @"nb-NO", @"nb",
                                 @"nl-NL", @"nl",
                                 @"pl-PL", @"pl",
                                 @"pt-BR", @"pt",
                                 @"pt-PT", @"pt-PT",
                                 @"ro-RO", @"ro",
                                 @"ru-RU", @"ru",
                                 @"sk-SK", @"sk",
                                 @"sv-SE", @"sv",
                                 @"th-TH", @"th",
                                 @"tr-TR", @"tr",
                                 @"uk-UA", @"uk",
                                 @"vi-VN", @"vi",
                                 @"zh-CN", @"zh-Hans",
                                 @"zh-TW", @"zh-Hant",
                                 @"zh-TW", @"zh-TW", // for 語：繁體中文 (台灣), 地區：台灣, etc
                                 @"zh-TW", @"zh-HK", // for 語：繁體中文 (香港), 地區：中香港, etc
                                 nil];
    NSString *langCode = [[NSLocale preferredLanguages] objectAtIndex:0];
    //    NSString *ori = [languageMap objectForKey:langCode];
    //    NSString *oriLangCode = langCode;
    
    if ([languageMap objectForKey:langCode] == nil && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")) {
        NSMutableArray *langCodes = [[NSMutableArray alloc] initWithArray:[langCode componentsSeparatedByString:@"-"]];
        [langCodes removeLastObject];
        langCode = [langCodes componentsJoinedByString:@"-"];
    }
    
    NSString *result = [languageMap objectForKey:langCode];
    if (result == nil) {
        result = langCode;
    }
    
    return result;
}

+ (CGSize)resolution
{
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    return CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
}

+ (NSString *)UUID
{
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    return uuid;
}

+ (NSString *)timeZone
{
    NSTimeZone *timeZone = [NSTimeZone localTimeZone];
    NSString *timeZoneName = [timeZone name];
    NSInteger timeZoneOffsetMinute = [timeZone secondsFromGMT] / 60;
    NSString *sign = (timeZoneOffsetMinute >= 0) ? @"+" : @"-";
    NSString *hour = [NSString stringWithFormat:@"%02ld", labs(timeZoneOffsetMinute) / 60];
    NSString *minute = [NSString stringWithFormat:@"%02ld", labs(timeZoneOffsetMinute) % 60];
    
    return [NSString stringWithFormat:@"%@ %@%@:%@", timeZoneName, sign, hour, minute];
}

+ (BOOL)isLowEndDevice
{
    NSString *cachedResult = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLowEndDevice"];
    if(cachedResult != nil)
    {
        if([cachedResult isEqual:@"YES"])
        {
            return YES;
        }
        else if([cachedResult isEqual:@"NO"])
        {
            return NO;
        }
    }
    
    NSArray *lowEndList = [NSArray arrayWithObjects:@"iPhone3", nil];
    BOOL isLowEnd = [DeviceInfoUtility isInPrifxList:lowEndList];
    
    if(isLowEnd)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isLowEndDevice"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isLowEndDevice"];
    }
    
    return isLowEnd;
}

+ (BOOL)isHighEndDevice
{
    NSString *cachedResult = [[NSUserDefaults standardUserDefaults] objectForKey:@"isHighEndDevice"];
    if(cachedResult != nil)
    {
        if([cachedResult isEqual:@"YES"])
        {
            return YES;
        }
        else if([cachedResult isEqual:@"NO"])
        {
            return NO;
        }
    }
    
    NSArray *highEndList = [NSArray arrayWithObjects:@"iPhone5", @"iPhone6", nil];
    BOOL isHighEnd = [DeviceInfoUtility isInPrifxList:highEndList];
    
    if(isHighEnd)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isHighEndDevice"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isHighEndDevice"];
    }
    
    return isHighEnd;
}

+ (BOOL)isInPrifxList:(NSArray *)prefixList
{
    NSString *modelName = [DeviceInfoUtility modelName];
    
    for(NSString *prefix in prefixList)
    {
        if ([modelName hasPrefix:prefix])
        {
            return YES;
        }
    }
    
    return NO;
}

+ (BOOL)isMemoryLessThan1GBDevice
{
    BOOL isMemoryLessThan1GB = NO;
    NSString *modelName = [DeviceInfoUtility modelName];
    
    if ([modelName hasPrefix:@"iPod"] ||
        [modelName hasPrefix:@"iPad2"] ||
        [modelName hasPrefix:@"iPhone3"] ||
        [modelName hasPrefix:@"iPhone4"]) {
        isMemoryLessThan1GB = YES;
    }
    
    return isMemoryLessThan1GB;
}


NSString *getCPUType(void)
{
    NSMutableString *cpu = [[NSMutableString alloc] init];
    size_t size;
    cpu_type_t type;
    cpu_subtype_t subtype;
    size = sizeof(type);
    sysctlbyname("hw.cputype", &type, &size, NULL, 0);
    
    size = sizeof(subtype);
    sysctlbyname("hw.cpusubtype", &subtype, &size, NULL, 0);
    
    // values for cputype and cpusubtype defined in mach/machine.h
    if(type == CPU_TYPE_X86)
    {
        [cpu appendString:@"x86"];
    } else if(type == CPU_TYPE_ARM)
    {
        [cpu appendString:@"arm"];
        switch(subtype)
        {
            case CPU_SUBTYPE_ARM_V4T:
                [cpu appendString:@"v4t"];
                break;
            case CPU_SUBTYPE_ARM_V5TEJ:
                [cpu appendString:@"v5tej"];
                break;
            case CPU_SUBTYPE_ARM_V6:
                [cpu appendString:@"v6"];
                break;
            case CPU_SUBTYPE_ARM_XSCALE:
                [cpu appendString:@"xscale"];
                break;
            case CPU_SUBTYPE_ARM_V7:
                [cpu appendString:@"v7"];
                break;
            case CPU_SUBTYPE_ARM_V7F:
                [cpu appendString:@"v7f"];
                break;
            case CPU_SUBTYPE_ARM_V7S:
                [cpu appendString:@"v7s"];
                break;
            case CPU_SUBTYPE_ARM_V7K:
                [cpu appendString:@"v7k"];
                break;
            case CPU_SUBTYPE_ARM_V6M:
                [cpu appendString:@"v6m"];
                break;
            case CPU_SUBTYPE_ARM_V7M:
                [cpu appendString:@"v7m"];
                break;
            case CPU_SUBTYPE_ARM_V7EM:
                [cpu appendString:@"v7em"];
                break;
            case CPU_SUBTYPE_ARM_V8:
                [cpu appendString:@"v8"];
                break;
            case CPU_SUBTYPE_ARM_ALL:
            default:
                break;
        }
    }else if (type == CPU_TYPE_ARM64)
    {
        [cpu appendString:@"arm64"];
        switch(subtype)
        {
            case CPU_SUBTYPE_ARM64_V8:
                [cpu appendString:@"v8"];
                break;
            case CPU_SUBTYPE_ARM64_ALL:
            default:
                break;
        }
    }
    
    return cpu;
}

@end