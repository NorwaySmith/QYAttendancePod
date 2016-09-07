//
//  QYAttendanceApi.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/6.
//  Copyright © 2016年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface QYAttendanceApi : NSObject

/**
 *  获取首页信息
 *
 *  @identify companyId 标示 暂时无用
 *  @param succeed
 *  @param failure
 */
+(void)getAttendanceFirstPageMessageWithIdentifire :(NSString *)identify
                                            succeed:(void(^)(NSString *responseString))success
                                            failure:(void(^)(NSString *alert))failure;

/**
 *  获取当年当月数据
 *
 *  @param dictionary key(year,month)
 *  @param succeed
 *  @param failure
 */
+(void)getThisMonthDataWithData :(NSDictionary *)dictionary
                                            succeed:(void(^)(NSString *responseString))success
                                            failure:(void(^)(NSString *alert))failure;


/**
 *  获取打卡设置
 *
 *  @param identify
 *  @param success  success
 *  @param failure  failure
 */
+(void)getAttentionSettingMessageWithIdentifire :(NSString *)identify
                                         succeed:(void(^)(NSString *responseString))success
                                         failure:(void(^)(NSString *alert))failure;

//http://192.168.10.43:8080/txzlbmc/attWap/attendanceSet.action?_clientType=wap&userId=29220911&companyId=81085&lng=12.12356&lat=24.456&address=lsdffsdf&range=500&dutyType=1&amOnDuty=2016-06-03 08:45:00&pmOffDuty=2016-06-03 18:15:00&attSettingId=1&comAddressId=1

/**
 *  设置考勤信息同步到服务器
 *
 *  @param selectionLocation 考勤地点坐标
 *  @param address           考勤地点坐标对应位置
 *  @param range             打卡有效范围
 *  @param amOnDuty          上午上班
 *  @param pmOffDuty         下午下班
 *  @param attSettingId      id（服务器返回，第一次没有就不传）
 *  @param comAddressId      id（服务器返回，第一次没有就不传）
 *  @param success  success
 *  @param failure  failure
 */
+(void)saveAttentionSettingMessageWithLocation:(CLLocationCoordinate2D )selectionLocation
                                       address:(NSString *)address
                                         range:(NSString *)range
                                      amOnDuty:(NSString *)amOnDuty
                                     pmOffDuty:(NSString *)pmOffDuty
                                  attSettingId:(NSString *)attSettingId
                                  comAddressId:(NSString *)comAddressId
                                       succeed:(void(^)(NSString *responseString))success
                                       failure:(void(^)(NSString *alert))failure;
//http://192.168.10.43:8080/txzlbmc/attWap/addSign.action? _clientType=wap&userId=29220911&companyId=81085&position=1234566555&longitude=12.12357000&latitude=24.45700000&attTy pe=10
/**
 *  打卡
 *
 *  @param position          位置
 *  @param selectionLocation 坐标
 *  @param memo 备注信息
 *  @param outOfRange 0正常打卡1外勤打卡
 *  @param systermPowerTime           本地特权时间
 *  @param attType           打卡类型 上午上班or下午下班
 */
+(void)signInWithPosition:(NSString *)position
                 Location:(CLLocationCoordinate2D )selectionLocation
                  attType:(NSString *)attType
                     memo:(NSString *)memo
               outOfRange:(NSString *)outOfRange
         systermPowerTime:(NSString *)systermPowerTime
                  succeed:(void(^)(NSString *responseString))success
                  failure:(void(^)(NSString *alert))failure;

@end
