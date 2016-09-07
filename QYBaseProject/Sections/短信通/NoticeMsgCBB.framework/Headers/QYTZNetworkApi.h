//
//  QYTZNetworkApi.h
//  QYBaseProject
//
//  Created by lin on 15/6/16.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QYNetworkHelper.h"

@interface QYTZNetworkApi : NSObject
/**
 *  刷新通知列表
 *
 *  @param sendType sendType description
 *  @param token token description
 *  @param userId userId description
 *  @param pageNum pageNum description
 *  @param success  success description
 *  @param failure  failure description
 */
+(void)loadListWithSendType:(NSString *)sendType
                      token:(NSString *)token
                     userId:(NSString *)userId
                    pageNum:(int)pageNum
                    showHud:(BOOL)showHud
                    success:(void (^)(NSString *responseString))success
                    failure:(void (^)(NSString *alert))failure;

/**
 *  通知详情
 *
 *  @param token token description
 *  @param userId userId description
 *  @param msgId msgId description
 *  @param success  success description
 *  @param failure  failure description
 */
+(void)loadMsgDetailsWithtoken:(NSString *)token
                        userId:(NSString *)userId
                         msgId:(NSString *)msgId
                       success:(void (^)(NSString *responseString))success
                       failure:(void (^)(NSString *alert))failure;
/**
 *  预约通知立即发送
 *
 *  @param token token description
 *  @param userId userId description
 *  @param msgId msgId description 通知ID
 *  @param success  success description
 *  @param failure  failure description
 */
+(void)sendNoticeAtonceWithtoken:(NSString *)token
                          userId:(NSString *)userId
                           msgId:(NSString *)msgId
                         success:(void (^)(NSString *responseString))success
                         failure:(void (^)(NSString *alert))failure;
/**
 *  取消预约通知
 *
 *  @param token token description
 *  @param userId userId description
 *  @param msgId msgId description 通知ID
 *  @param companyId  companyId description
 *  @param success  success description
 *  @param failure  failure description
 */
+(void)cancleNoticeWithtoken:(NSString *)token
                       userId:(NSString *)userId
                        msgId:(NSString *)msgId
                    companyId:(NSString *)companyId
                      success:(void (^)(NSString *responseString))success
                      failure:(void (^)(NSString *alert))failure;

/**
 *  重呼未通的人员
 *
 *  @param token token description
 *  @param userId userId description
 *  @param msgId msgId description 通知ID
 *  @param success  success description
 *  @param failure  failure description
 */
+(void)willReCallFailedUserWithtoken:(NSString *)token
                          userId:(NSString *)userId
                           msgId:(NSString *)msgId
                         success:(void (^)(NSString *responseString))success
                         failure:(void (^)(NSString *alert))failure;

/**
 *  新建通知页面发送通知
 *
 *  @param token token description
 *  @param userId userId description
 *  @param msg msg description 通知
 *  @param receiver receiver description
 *  @param success  success description
 *  @param failure  failure description
 */
+(void)sendNoticeWithtoken:(NSString *)token
                    userId:(NSString *)userId
                       msg:(NSString *)msg
                  receiver:(NSString *)receiver
                   success:(void (^)(NSString *responseString))success
                   failure:(void (^)(NSString *alert))failure;

/**
 *  加载模板标题数组
 *
 *  @param token token description
 *  @param success  success description
 *  @param failure  failure description
 */
+(void)getGenericTemplateListWithtoken:(NSString *)token
                               success:(void (^)(NSString *responseString))success
                               failure:(void (^)(NSString *alert))failure;

/**
 *  加载对应标题的模板内容
 *
 *  @param token token description
 *  @param templateId templateId description
 *  @param success  success description
 *  @param failure  failure description
 */
+(void)getGenericTemplateContentWithtoken:(NSString *)token
                               templateId:(NSString *)templateId
                                  success:(void (^)(NSString *responseString))success
                                  failure:(void (^)(NSString *alert))failure;

/**
 *  获取模板的数据
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)getGenericTemplateListContentSuccess:(void (^)(NSString *responseString))success
                                      failure:(void (^)(NSString *alert))failure;

@end
