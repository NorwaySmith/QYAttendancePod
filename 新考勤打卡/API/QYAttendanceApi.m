//
//  QYAttendanceApi.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/6.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYAttendanceApi.h"
#import "QYDialogTool.h"
#import "QYURLHelper.h"
#import "QYNetworkHelper.h"
#import "QYNetworkJsonProtocol.h"
#import "QYVersionHelper.h"
#import "QYLoginConstant.h"
#import "QYAccount.h"
#import "QYAccountService.h"
#import "MBProgressHUD.h"
static NSString  *ModelCode = @"attendance";

@implementation QYAttendanceApi
+(void)getAttendanceFirstPageMessageWithIdentifire :(NSString *)identify
                                            succeed:(void(^)(NSString *responseString))success
                                            failure:(void(^)(NSString *alert))failure{
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    QYAccount *account = [[QYAccountService shared] defaultAccount];
//    NSString *urlString = @"http://101.200.31.143/txzlbmc/attWap/getSignCountAndInfo.action?";
    
    //2016/07/20张永峰   新接口，数据结构改变，旧版本存放于svn
//    NSString *urlString = @"http://101.200.31.143/txzlbmc/attWap/init.action?";
        NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"getInitData"];

//    NSDictionary *parameters = @{@"userId":@"11614246", @"companyId":@"1", @"_clientType":@"wap"};
    NSDictionary *parameters = @{@"userId":account.userId, @"companyId":account.companyId, @"_clientType":@"wap"};
//    NSDictionary *parameters = @{@"userId":@"29223395", @"companyId":@"81245", @"_clientType":@"wap"};

    [networkHelper POST:urlString parameters:parameters success:^(QYNetworkResult *result)
     {
         if(result.statusCode == NetworkResultStatusCodeSuccess)
         {
             success(result.result);
         }
     } failure:^(NetworkErrorType errorType)
     {
         failure(@"");
     }];
 
}

+(void)getThisMonthDataWithData :(NSDictionary *)dictionary
                         succeed:(void(^)(NSString *responseString))success
                         failure:(void(^)(NSString *alert))failure{
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    QYAccount *account = [[QYAccountService shared] defaultAccount];
        NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"getRecordReport"];
//    NSString *urlString = @"http://101.200.31.143/txzlbmc/attWap/recordReport.action?";
    //http://101.200.31.143/txzlbmc/attWap/recordReport.action?_clientType=wap&userId=29223372&companyId=81245&month=2016-07
    NSDictionary *parameters = @{@"userId":account.userId, @"companyId":account.companyId, @"_clientType":@"wap", @"year":dictionary[@"year"], @"month":dictionary[@"month"]};
//    NSDictionary *parameters = @{@"userId":@"29223395", @"companyId":@"81245", @"_clientType":@"wap", @"year":dictionary[@"year"], @"month":dictionary[@"month"]};

    [networkHelper showHUDAtView:nil message:nil];

    [networkHelper POST:urlString parameters:parameters success:^(QYNetworkResult *result)
     {
         if(result.statusCode == NetworkResultStatusCodeSuccess)
         {
             success(result.result);
         }
     } failure:^(NetworkErrorType errorType){
     }];
}
+(void)getAttentionSettingMessageWithIdentifire :(NSString *)identify
                                         succeed:(void(^)(NSString *responseString))success
                                         failure:(void(^)(NSString *alert))failure{
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    QYAccount *account = [[QYAccountService shared] defaultAccount];
        NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"getAttendanceSet"];
//    NSString *urlString = @"http://101.200.31.143/txzlbmc/attWap/getAttendanceSet.action?";
    NSDictionary *parameters = @{@"userId":account.userId, @"companyId":account.companyId, @"_clientType":@"wap"};
//    NSDictionary *parameters = @{@"userId":@"29223395", @"companyId":@"81245", @"_clientType":@"wap"};

    [networkHelper showHUDAtView:nil message:nil];
    
    [networkHelper POST:urlString parameters:parameters success:^(QYNetworkResult *result)
     {
         if(result.statusCode == NetworkResultStatusCodeSuccess)
         {
             success(result.result);
         }
     } failure:^(NetworkErrorType errorType){
     }];

}
+(void)saveAttentionSettingMessageWithLocation:(CLLocationCoordinate2D )selectionLocation
                                       address:(NSString *)address
                                         range:(NSString *)range
                                      amOnDuty:(NSString *)amOnDuty
                                     pmOffDuty:(NSString *)pmOffDuty
                                  attSettingId:(NSString *)attSettingId
                                  comAddressId:(NSString *)comAddressId
                                       succeed:(void(^)(NSString *responseString))success
                                       failure:(void(^)(NSString *alert))failure{
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    QYAccount *account = [[QYAccountService shared] defaultAccount];
        NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"getAttendanceSetNew"];
//    http://192.168.10.43:8080/txzlbmc/attWap/attendanceSet.action?_clientType=wap&userId=29220911&companyId=81085&lng=12.12356&lat=24.456&address=lsdffsdf&range=500&dutyType=1&amOnDuty=2016-06-03 08:45:00&pmOffDuty=2016-06-03 18:15:00&attSettingId=1&comAddressId=1
    
//    NSString *urlString = @"http://101.200.31.143/txzlbmc/attWap/attendanceSet.action?";
    NSDictionary *parameters = @{@"userId":account.userId,
                                 @"companyId":account.companyId,
                                 @"lng":[NSString stringWithFormat:@"%f",selectionLocation.longitude],
                                 @"lat":[NSString stringWithFormat:@"%f",selectionLocation.latitude],
                                 @"address":address,
                                 @"range":[NSString stringWithFormat:@"%@",range],
                                 @"dutyType":@"1",
                                 @"amOnDuty":[NSString stringWithFormat:@"1970-01-01 %@:52",amOnDuty],
                                 @"pmOffDuty":[NSString stringWithFormat:@"1970-01-01 %@:52",pmOffDuty],
                                 @"attSettingId":[NSString stringWithFormat:@"%@",attSettingId],
                                 @"comAddressId":[NSString stringWithFormat:@"%@",comAddressId],
                                 @"_clientType":@"wap"};
    [networkHelper showHUDAtView:nil message:nil];
    
    [networkHelper POST:urlString parameters:parameters success:^(QYNetworkResult *result)
     {
         if(result.statusCode == NetworkResultStatusCodeSuccess)
         {
             success(result.result);
         }
     } failure:^(NetworkErrorType errorType){
     }];

}
+(void)signInWithPosition:(NSString *)position
                 Location:(CLLocationCoordinate2D )selectionLocation
                  attType:(NSString *)attType
                     memo:(NSString *)memo
               outOfRange:(NSString *)outOfRange
         systermPowerTime:(NSString *)systermPowerTime
                  succeed:(void(^)(NSString *responseString))success
                  failure:(void(^)(NSString *alert))failure{
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    QYAccount *account = [[QYAccountService shared] defaultAccount];
        NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"saveRecord."];
    //    http://192.168.10.43:8080/txzlbmc/attWap/addSign.action? _clientType=wap&userId=29220911&companyId=81085&position=1234566555&longitude=12.12357000&latitude=24.45700000&attType=10
    
//    http://101.200.31.143/txzlbmc/attWap/saveRecord.action?_clientType=wap&userId=1&companyId=1&position=郑州2222222&longitude=0&latitude=0&attType=10&memo=打卡打卡扩大卡卡打卡打卡打卡打卡打卡的卡卡
//    NSString *urlString = @"http://101.200.31.143/txzlbmc/attWap/saveRecord.action?";
    NSDictionary *parameters = @{
//                                 @"userId":@"29223395",
//                                 @"companyId":@"81245",
                                 @"userId":account.userId,
                                 @"companyId":account.companyId,
                                 @"longitude":[NSString stringWithFormat:@"%f",selectionLocation.longitude],
                                 @"latitude":[NSString stringWithFormat:@"%f",selectionLocation.latitude],
                                 @"position":position,
                                 @"attType":attType,
                                 @"memo":memo,
                                 @"outOfRange":outOfRange,
                                 @"systermPowerTime":systermPowerTime,
                                 @"_clientType":@"wap"};
    [networkHelper showHUDAtView:nil message:nil];
    
    [networkHelper POST:urlString parameters:parameters success:^(QYNetworkResult *result)
     {
         if(result.statusCode == NetworkResultStatusCodeSuccess)
         {
             success(result.result);
         }
     } failure:^(NetworkErrorType errorType){
     }];
    

}
@end
