//
//  QYNetworkHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/6/2.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYNetworkHelper.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "QYOAuthManager.h"
#import "QYDESUtil.h"
#import "QYNetworkCache.h"

static NSString *OauthKey = @"oauth";
@interface QYNetworkHelper()

@property(nonatomic,strong)MBProgressHUD *hud;

@end

@implementation QYNetworkHelper

+ (BOOL)isInternetReachable
{
    return [[QYNetworkInfo shared] connectedToNetwork];
}

-(void)showHUDAtView:(UIView *)view message:(NSString *)message
{
    UIView *hudSuperView = view;
    if (!hudSuperView)
    {
        hudSuperView = [[UIApplication sharedApplication].delegate window];
    }
    _hud = [[MBProgressHUD alloc] initWithView:hudSuperView];
    _hud.removeFromSuperViewOnHide = YES;
    [hudSuperView addSubview:_hud];
    _hud.labelText = message;
    [_hud show:YES];
}

-(void)hideHUD
{
    if (_hud)
    {
        [_hud hide:YES];
    }
}
/**
 *  请求参数处理
 *
 *  @param parameters 参数字典
 *
 *  @return 处理后参数字典
 */
-(NSDictionary*)generateParameters:(NSDictionary*)parameters{
    NSMutableDictionary *muParameters = nil;
    if(parameters){
        muParameters=[[NSMutableDictionary alloc] initWithDictionary:parameters];
    }else{
        muParameters=[[NSMutableDictionary alloc] init];
    }
    
    QYOAuthManager *oauthManager=[[QYOAuthManager alloc] init];
    NSString *oauth=[oauthManager generateOAuthWithParameters:muParameters];
    
    //添加加密令牌
    [muParameters setObject:oauth forKey:OauthKey];
    
    //删除明文key
    [muParameters removeObjectForKey:UserIdKey];
    [muParameters removeObjectForKey:CompanyIdKey];
    [muParameters removeObjectForKey:UserNameKey];
    [muParameters removeObjectForKey:PassWordKey];
    [muParameters removeObjectForKey:RequestTimeKey];
    [muParameters removeObjectForKey:VersionKey];
    [muParameters removeObjectForKey:SourceKey];
    return muParameters;
}
/**
 *  验证是否重新登录
 *
 *  @param result 解析后的对象
 *
 *  @return 是否重新登录
 */
-(BOOL)verifyReLogin:(QYNetworkResult*)result{
    if (result.statusCode==NetworkResultStatusCodeRelogin) {
        [[[AFHTTPRequestOperationManager manager] operationQueue] cancelAllOperations];
        [[NSNotificationCenter defaultCenter] postNotificationName:kReloginNotification object:nil];
        return YES;
    }
    return NO;
}
- (NSString *)generateCacheKeyWithURLString:(NSString *)URLString
                                 parameters:(id)parameters {
    NSMutableString *paramsString = nil;
    
    if (parameters) {
        // build a simple url encoded param string
        paramsString = [NSMutableString stringWithString:@""];
        for (NSString *key in
             [[parameters allKeys] sortedArrayUsingSelector:@selector(compare:)]) {
            [paramsString appendFormat:@"%@=%@&", key, parameters[key]];
        }
        if ([paramsString hasSuffix:@"&"]) {
            paramsString = [[NSMutableString alloc]
                            initWithString:[paramsString
                                            substringToIndex:paramsString.length - 1]];
        }
    }
    
    NSString *key = [NSString stringWithFormat:@"%@?%@", URLString, paramsString];
    return key;
}

/**
 *  缓存网络请求
 *
 *  @param URLString  url
 *  @param parameters 参数
 *  @param cachePolicy    缓存策略
 *  @param success    成功回调
 *  @param cache      缓存回调
 *  @param failure    失败回调
 */
- (void)request:(NSString *)URLString
     parameters:(id)parameters
    cachePolicy:(NetworkHelperCachePolicy)cachePolicy
        success:(void (^)(QYNetworkResult *result))success
        failure:(void (^)(NetworkErrorType errorType))failure;
{
    
    //何时 缓存
    NSString *cacheKey =
    [self generateCacheKeyWithURLString:URLString parameters:parameters];
    QYNetworkResult *cacheObject =
    [[QYNetworkCache shared] cachedObjectForKey:cacheKey];
    if (cachePolicy == NetworkHelperCachePolicyCacheData) {
        if (cacheObject != nil &&
            [cacheObject isKindOfClass:[QYNetworkResult class]]) {
            [self hideHUD];
            cacheObject.resultType = NetworkResultTypeCache;
            success(cacheObject);
        }
    }
    NSAssert(_parseDelegate, @"error: QYNetworkHelper必须设置_parseDelegate");
    NSAssert(URLString, @"error: QYNetworkHelper URLString不能为空");
    
    AFHTTPRequestOperationManager *manager =
    [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    [manager POST:URLString
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              [self hideHUD];
              QYNetworkResult *result =
              [_parseDelegate convertResultData:operation.responseData
                                     resultType:NetworkResultTypeNetwork];
              result.resultType = NetworkResultTypeNetwork;
              //数据请求成功并且此接口需要缓存时，缓存QYNetworkResult对象
              if (cachePolicy == NetworkHelperCachePolicyCacheData) {
                  [[QYNetworkCache shared] cacheObject:result forKey:cacheKey];
              }
              success(result);
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              [self hideHUD];
              failure(NetworkErrorType404);
          }];
}

-(void)POST:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(QYNetworkResult *result))success
    failure:(void (^)(NetworkErrorType errorType))failure
{
    if(![QYNetworkHelper isInternetReachable])
    {
        [self hideHUD];
        failure(NetworkErrorTypeNoNetwork);
        return;
    }

    NSAssert(_parseDelegate, @"error: QYNetworkHelper必须设置_parseDelegate");
    NSAssert(URLString, @"error: QYNetworkHelper URLString不能为空");
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSDictionary *machiningParameters=[self generateParameters:parameters];
    //NSLog(@"URLString....:%@",URLString);
    //NSLog(@"machiningParameters....:%@",parameters);
    [manager POST:URLString
       parameters:parameters
          success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self hideHUD];
        QYNetworkResult *result = [_parseDelegate convertResultData:operation.responseData  resultType:NetworkResultTypeNetwork];
        if (![self verifyReLogin:result]) {
            success(result);
        }else{
            failure(NetworkErrorType404);

        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self hideHUD];
        failure(NetworkErrorType404);
    }];
}
- (void)GET:(NSString *)URLString
 parameters:(id)parameters
    success:(void (^)(QYNetworkResult *result))success
    failure:(void (^)(NetworkErrorType errorType))failure
{
    if(![QYNetworkHelper isInternetReachable])
    {
        [self hideHUD];
        failure(NetworkErrorTypeNoNetwork);
        return;
    }
    NSAssert(_parseDelegate, @"error: QYNetworkHelper必须设置_parseDelegate");
    NSAssert(URLString, @"error: QYNetworkHelper URLString不能为空");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *machiningParameters=[self generateParameters:parameters];

    [manager GET:URLString
      parameters:machiningParameters
         success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self hideHUD];
        QYNetworkResult *result = [_parseDelegate convertResultData:operation.responseData  resultType:NetworkResultTypeNetwork];
        if (![self verifyReLogin:result]) {
            success(result);
        }
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self hideHUD];
        failure(NetworkErrorType404);
    }];
}

-(void)upload:(NSString *)URLString
     fileData:(NSData *)fileData
     fileName:(NSString *)fileName
     mimeType:(NSString *)mimeType
   parameters:(id)parameters
      success:(void (^)(QYNetworkResult *result))success
      failure:(void (^)(NetworkErrorType errorType))failure
{
    if(![QYNetworkHelper isInternetReachable])
    {
        [self hideHUD];
        failure(NetworkErrorTypeNoNetwork);
        return;
    }
    NSAssert(_parseDelegate, @"error: QYNetworkHelper必须设置_parseDelegate");
    NSAssert(URLString, @"error: QYNetworkHelper URLString不能为空");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSDictionary *machiningParameters=[self generateParameters:parameters];

    [manager POST:URLString
       parameters:parameters
constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:fileData name:fileName fileName:[NSString stringWithFormat:@"%@.png",fileName] mimeType:mimeType];
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self hideHUD];
        QYNetworkResult *result = [_parseDelegate convertResultData:operation.responseData  resultType:NetworkResultTypeNetwork];
        success(result);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self hideHUD];
        failure(NetworkErrorType404);
    }];
    
}
-(void)upload:(NSString *)URLString
     fileData:(NSData*)fileData
     fileName:(NSString*)fileName
     mimeType:(NSString*)mimeType
   parameters:(id)parameters
      success:(void (^)(QYNetworkResult *result))success
      failure:(void (^)(NetworkErrorType errorType))failure
     proGress:(void(^)(float progress))progress
{
    if(![QYNetworkHelper isInternetReachable])
    {
        [self hideHUD];
        failure(NetworkErrorTypeNoNetwork);
        return;
    }
    NSAssert(_parseDelegate, @"error: QYNetworkHelper必须设置_parseDelegate");
    NSAssert(URLString, @"error: QYNetworkHelper URLString不能为空");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSDictionary *machiningParameters=[self generateParameters:parameters];
    AFHTTPRequestOperation *operation =  [manager POST:URLString
                                            parameters:parameters
                             constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:fileData name:fileName fileName:[NSString stringWithFormat:@"%@.png",fileName] mimeType:mimeType];
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self hideHUD];
        QYNetworkResult *result = [_parseDelegate convertResultData:operation.responseData  resultType:NetworkResultTypeNetwork];
        success(result);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self hideHUD];
        failure(NetworkErrorType404);
    }];
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite)
    {
        //NSLog(@"bytesWritten=%lu, totalBytesWritten=%lld, totalBytesExpectedToWrite=%lld", (unsigned long)bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) ;
        progress(totalBytesWritten*1.0/totalBytesExpectedToWrite);
    }];
}

-(void)uploadVoice:(NSString *)URLString
          fileData:(NSData *)fileData
          fileName:(NSString *)fileName
          mimeType:(NSString *)mimeType
        parameters:(id)parameters
           success:(void (^)(QYNetworkResult *))success
           failure:(void (^)(NetworkErrorType))failure
{
    if(![QYNetworkHelper isInternetReachable])
    {
        [self hideHUD];
        failure(NetworkErrorTypeNoNetwork);
        return;
    }
    NSAssert(_parseDelegate, @"error: QYNetworkHelper必须设置_parseDelegate");
    NSAssert(URLString, @"error: QYNetworkHelper URLString不能为空");
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSDictionary *machiningParameters=[self generateParameters:parameters];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
    {
        [formData appendPartWithFileData:fileData name:fileName fileName:[NSString stringWithFormat:@"%@.wav",fileName] mimeType:mimeType];
    }
    success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        [self hideHUD];
        QYNetworkResult *result = [_parseDelegate convertResultData:operation.responseData  resultType:NetworkResultTypeNetwork];
        success(result);
    }
    failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        [self hideHUD];
        failure(NetworkErrorType404);
    }];
}

@end
