//
//  QYMoreNetworkApi.h
//  QYBaseProject
//
//  Created by 田 on 15/6/9.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYNetworkHelper.h"

@interface QYMoreNetworkApi : NSObject
//上传头像
+(void)uploadUserPhoto:(UIImage*)image
                       userId:(NSString*)userId
                        fileName:(NSString*)fileName
                     success:(void (^)(NSString *responseString))success
                     failure:(void (^)(NSString *alert))failure;
//修改性别
+(void)updateUserSex:(BOOL)sex
                       userId:(NSString*)userId
                     success:(void (^)(NSString *responseString))success
                     failure:(void (^)(NSString *alert))failure;
//修改签名
+(void)updateSign:(NSString*)sign
              userId:(NSString*)userId
             success:(void (^)(NSString *responseString))success
             failure:(void (^)(NSString *alert))failure;


/**
 *  短信推荐
 *
 *  @param recommendContent 推荐的内容
 *  @param phoneListStr     推荐人的手机号
 *  @param userId           用户userId
 *  @param success          成功回调block
 *  @param failure          失败回调block
 */
+(void)sendRecommendWithRecommendContent:(NSString *)recommendContent
                               phoneList:(NSString *)phoneListStr
                                  userId:(NSString *)userId
                                 success:(void (^)(NSString *responseString))success
                                 failure:(void (^)(NSString *alert))failure;

/**
 *  问题反馈
 *
 *  @param content   反馈的问题
 *  @param userId    用户userId
 *  @param companyId 公司Id
 *  @param success   成功回调block
 *  @param failure   失败回调block
 */
+ (void)sendProblemFeedBackWithContent:(NSString *)content userId:(NSString *)userId companyId:(NSString *)companyId success:(void (^)(NSString *successStr))success failure:(void (^)(NSString *error))failure;


/**
 *  切换单位
 *
 *  @param companyId <#companyId description#>
 *  @param userId    <#userId description#>
 *  @param success   <#success description#>
 *  @param failure   <#failure description#>
 */
+ (void)requestWith:(NSString *)companyId andWith:(NSString *)userId success:(void (^)(NSString *successStr))success failure:(void (^)(NSString *error))failure;


@end
