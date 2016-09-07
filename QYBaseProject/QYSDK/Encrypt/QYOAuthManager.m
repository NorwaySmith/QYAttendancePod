//
//  QYOAuthManager.m
//  QYBaseProject
//
//  Created by 田 on 16/2/2.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYOAuthManager.h"
#import "QYTimeTool.h"
#import "QYDESUtil.h"
#import "QYShaUtil.h"

/**
 *  摘要签名
 */
static NSString *ShaKey = @"sha";

/**
 *  des加密key
 */
static NSString *DesKey = @"abcd1234";

/**
 *  默认接口版本
 */
static NSString *VersionDefault = @"1.0";
/**
 *  默认来源
 */
static NSString *SourceDefault = @"IOS";


@interface QYOAuthManager()
/**
 *  用户id
 */
@property(nonatomic,copy)NSString *userId;
/**
 *  公司id
 */
@property(nonatomic,copy)NSString *companyId;
/**
 *  用户名
 */
@property(nonatomic,copy)NSString *userName;
/**
 *  密码
 */
@property(nonatomic,copy)NSString *passWord;
/**
 *  请求时间
 */
@property(nonatomic,copy)NSString *requestTime;
/**
 *  接口版本
 */
@property(nonatomic,copy)NSString *version;
/**
 *  来源
 */
@property(nonatomic,copy)NSString *source;
/**
 *  设备id
 */
@property(nonatomic,copy)NSString *deviceId;

/**
 *  摘要签名
 */
@property(nonatomic,copy)NSString *sha;

@end

@implementation QYOAuthManager

/**
 *  根据规则生成oauth
 *
 *  @param parameters 网络请求参数
 *
 *  @return oauth
 */
-(NSString *)generateOAuthWithParameters:(NSDictionary *)parameters {

    self.userId = parameters[UserIdKey];
    self.companyId = parameters[CompanyIdKey];
    self.userName = [self replaceUnicode:parameters[UserNameKey]];
    self.passWord = parameters[PassWordKey];
    self.requestTime = parameters[RequestTimeKey]?:[self generateRequestTime];
    self.version = parameters[VersionKey]?:VersionDefault;
    self.source = parameters[SourceKey]?:SourceDefault;
    self.deviceId = [self generateDeviceId];
    self.sha = [self generateSHA];
    
    return [self generateOAuth];
}

/**
 *  Unicode转中文
 *
 *  @param unicodeStr Unicode字符串
 *
 *  @return 中文字符串
 */
- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    if(!unicodeStr) return nil;
    
    unicodeStr = [unicodeStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return unicodeStr;
}
/**
 *  生成设备唯一id
 *
 *  @return 设备id (6ECED284-F478-4695-9AE2-19B00E1C1949)
 */
-(NSString*)generateDeviceId{
    NSString *DeviceIdKey=@"com.quanya.DeviceIdKey";
    NSString *deviceId =[[NSUserDefaults standardUserDefaults] objectForKey:DeviceIdKey];
    if (deviceId&&![deviceId isEqualToString:@""]) {
        return deviceId;
    }
    
    CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuid = (NSString *)CFBridgingRelease(CFUUIDCreateString (kCFAllocatorDefault,uuidRef));
    [[NSUserDefaults standardUserDefaults] setObject:uuid forKey:DeviceIdKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return uuid;
}
/**
 *  生成oauth
 *
 *  @return oauth
 */
-(NSString *)generateOAuth {
    NSString *des = nil;
    if (_requestTime && _version && _source) {
        NSMutableString *parameters = [[NSMutableString alloc] init];
        [parameters appendFormat:@"%@,",_userId?:@"0"];
        [parameters appendFormat:@"%@,",_companyId?:@"0"];
        [parameters appendFormat:@"%@,",_userName?:@""];
        [parameters appendFormat:@"%@,",_passWord?:@""];
        [parameters appendFormat:@"%@,",_requestTime?:@""];
        [parameters appendFormat:@"%@,",_version?:@""];
        [parameters appendFormat:@"%@,",_source?:@""];
        [parameters appendFormat:@"%@,",_deviceId?:@""];
        [parameters appendFormat:@"%@",_sha?:@""];
        
        des = [QYDESUtil encryptUseDES:parameters key:DesKey];
    }else{
        des = nil;
    }
    return des;
    
}


/**
 *  生成请求时间
 *
 *  @return 请求时间
 */
-(NSString*)generateRequestTime{
    return  [QYTimeTool stringWithDate:[NSDate date] format:@"yyyy-MM-dd HH:mm:ss"];

}


/**
 *  生成摘要签名,根据上述表格中的参数生成摘要签名
 *
 *  @return 摘要签名
 */
-(NSString *)generateSHA {
    NSString *sha = @"";
    if (_requestTime && _version && _source) {
        NSMutableString *parameters = [[NSMutableString alloc] init];
        [parameters appendFormat:@"%@,",_userId?:@"0"];
        [parameters appendFormat:@"%@,",_companyId?:@"0"];
        [parameters appendFormat:@"%@,",_userName?:@""];
        [parameters appendFormat:@"%@,",_passWord?:@""];
        [parameters appendFormat:@"%@,",_requestTime?:@""];
        [parameters appendFormat:@"%@,",_version?:@""];
        [parameters appendFormat:@"%@,",_source?:@""];
        [parameters appendFormat:@"%@",_deviceId?:@""];
        sha=[QYShaUtil sha1:parameters];
    }else{
        sha = @"";
    }
    return sha;
    
}
@end
