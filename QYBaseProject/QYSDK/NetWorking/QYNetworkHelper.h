//
//  QYNetworkHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/6/2.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IOSTool.h"
#import "QYNetworkProtocol.h"
#import "QYNetworkResult.h"
/**
 *  重新登录通知
 */
static NSString *const kReloginNotification = @"com.quanya.relogin";

#define ErrorNoNetworkAlert             @"对不起，暂时没有网络可以使用"
#define Error404Alert                   @"请求失败"

typedef NS_ENUM(NSUInteger, NetworkErrorType) {
    NetworkErrorTypeNoNetwork = 0,//无网络
    NetworkErrorType404 = 1//找不到服务器
};
typedef NS_ENUM(NSUInteger, NetworkHelperCachePolicy) {
    //不缓存
    NetworkHelperCachePolicyNone = 0,
    //缓存数据，在网络数据未返回，或网络失败时使用缓存数据，如果返回网络数据则替换缓存数据
    NetworkHelperCachePolicyCacheData = 1,
    //仅在网络请求失败时使用缓存数据，暂不使用
    NetworkHelperCachePolicyOnlyFailureUsingCacheData = 2,
};

@interface QYNetworkHelper : NSObject


//解析代理
@property (strong,nonatomic) id<QYNetworkProtocol> parseDelegate;


+ (BOOL)isInternetReachable;

/**
 *  在view上显示指示器。不调用则不显示
 *
 *  @param view hud父view，如果为空则显示在window上
 *  @param message hud提示信息，如果为空则不显示提示信息
 */
-(void)showHUDAtView:(UIView *)view message:(NSString *)message;

-(void)hideHUD;
/**
 *  缓存网络请求
 *
 *  @param URLString  url
 *  @param parameters 参数
 *  @param cachePolicy    缓存测试
 *  @param success    成功回调
 *  @param cache      缓存回调
 *  @param failure    失败回调
 */
- (void)request:(NSString *)URLString
     parameters:(id)parameters
    cachePolicy:(NetworkHelperCachePolicy)cachePolicy
        success:(void (^)(QYNetworkResult *result))success
        failure:(void (^)(NetworkErrorType errorType))failure;
//发送post请求
-(void)POST:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(QYNetworkResult *result))success
    failure:(void (^)(NetworkErrorType errorType))failure;

//发送get请求
-(void)GET:(NSString *)URLString
parameters:(id)parameters
   success:(void (^)(QYNetworkResult *result))success
   failure:(void (^)(NetworkErrorType errorType))failure;

//上传文件
-(void)upload:(NSString *)URLString
     fileData:(NSData *)fileData
     fileName:(NSString *)fileName
     mimeType:(NSString *)mimeType
   parameters:(id)parameters
      success:(void (^)(QYNetworkResult *result))success
      failure:(void (^)(NetworkErrorType errorType))failure;

//上传图片，带进度进度
-(void)upload:(NSString *)URLString
     fileData:(NSData *)fileData
     fileName:(NSString *)fileName
     mimeType:(NSString *)mimeType
   parameters:(id)parameters
      success:(void (^)(QYNetworkResult *result))success
      failure:(void (^)(NetworkErrorType errorType))failure
     proGress:(void(^)(float progress))progress;

//嘀嘀上传语音
-(void)uploadVoice:(NSString *)URLString
          fileData:(NSData *)fileData
          fileName:(NSString *)fileName
          mimeType:(NSString *)mimeType
        parameters:(id)parameters
           success:(void (^)(QYNetworkResult *result))success
           failure:(void (^)(NetworkErrorType errorType))failure;


@end
