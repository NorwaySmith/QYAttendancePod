//
//  QYMoreNetworkApi.m
//  QYBaseProject
//
//  Created by 田 on 15/6/9.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreNetworkApi.h"
#import "QYURLHelper.h"
#import "QYNetworkJsonProtocol.h"
static NSString  *ModelCode          = @"ydzjMobile";

@implementation QYMoreNetworkApi
//上传头像
+(void)uploadUserPhoto:(UIImage *)image
                userId:(NSString *)userId
              fileName:(NSString *)fileName
               success:(void (^)(NSString *responseString))success
               failure:(void (^)(NSString *alert))failure{

    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"headPictureUpload"];
    //NSLog(@"urlString==%@",urlString);

    NSDictionary *parameters = @{@"userId":userId,@"_clientType":@"wap"};
    
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    
    [networkHelper showHUDAtView:nil message:nil];
    
    [networkHelper upload:urlString
                 fileData:UIImagePNGRepresentation(image)
                 fileName:fileName
                 mimeType:@"image/png"
               parameters:parameters
                  success:^(QYNetworkResult *result)
    {
          if(result.statusCode == NetworkResultStatusCodeSuccess)
          {
              //NSLog(@"string===%lu",(unsigned long)result.statusCode);
              //NSLog(@"result.result===%@",result.result);
              
              success(result.result);
          }
          else if(result.statusCode == NetworkResultStatusCodeNoData)
          {
              success(result.result);
          }
          else
          {
              failure(result.errMessage);
          }
    }
    failure:^(NetworkErrorType errorType)
    {
        if (errorType == NetworkErrorTypeNoNetwork)
        {
            failure(ErrorNoNetworkAlert);
        }
        if (errorType == NetworkErrorType404)
        {
            NSString *errMessage = [NSString stringWithFormat:@"%s :404",__FUNCTION__];
            failure(Error404Alert);
        }
    }];
    
}
//修改性别
+(void)updateUserSex:(BOOL)sex
              userId:(NSString*)userId
             success:(void (^)(NSString *responseString))success
             failure:(void (^)(NSString *alert))failure{

    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"updateUserSex"];
    NSDictionary *parameters = @{@"userId":userId, @"sex":@(sex), @"_clientType":@"wap"};
    
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    
    [networkHelper POST:urlString parameters:parameters
                success:^(QYNetworkResult *result)
    {
        if(result.statusCode == NetworkResultStatusCodeSuccess)
        {
            success(result.result);
        }
        else if(result.statusCode == NetworkResultStatusCodeNoData)
        {
            success(result.result);
        }
        else
        {
            failure(result.errMessage);
        }
    }
    failure:^(NetworkErrorType errorType)
    {
        if (errorType == NetworkErrorTypeNoNetwork)
        {
            failure(ErrorNoNetworkAlert);
        }
        if (errorType == NetworkErrorType404)
        {
            NSString *errMessage = [NSString stringWithFormat:@"%s :404",__FUNCTION__];
            failure(Error404Alert);
        }
    }];

    
//    [self POST:urlString parameters:parameters
//       success:^(NSString *responseString) {
//           NSArray *resultArray=[responseString componentsSeparatedByString:decollator];
//           if ([resultArray count]>=2) {
//               if([resultArray[0] integerValue]==100){
//                   success(resultArray[1]);
//               }else{
//                   failure(resultArray[1]);
//               }
//           }else{
//               failure(@"服务器返回数据错误");
//           }
//       } failure:^(NSError *error) {
//           failure(@"接口连接失败");
//           
//       }];

}

//更新个人签名
+(void)updateSign:(NSString*)sign
           userId:(NSString*)userId
          success:(void (^)(NSString *responseString))success
          failure:(void (^)(NSString *alert))failure
{
    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"updateSign"];

    NSDictionary *parameters = @{@"userId":userId, @"sign":sign, @"_clientType":@"wap"};
    
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    
    [networkHelper showHUDAtView:nil message:nil];

    [networkHelper POST:urlString parameters:parameters
                success:^(QYNetworkResult *result)
    {
        if(result.statusCode == NetworkResultStatusCodeSuccess)
        {
            //NSLog(@"statusCode===%d",result.statusCode);
            success(result.result);
        }
        else if(result.statusCode == NetworkResultStatusCodeNoData)
        {
            success(result.result);
        }
        else
        {
            failure(result.errMessage);
        }
    }
    failure:^(NetworkErrorType errorType)
    {
        if (errorType == NetworkErrorTypeNoNetwork)
        {
            failure(ErrorNoNetworkAlert);
        }
        if (errorType == NetworkErrorType404)
        {
            NSString *errMessage = [NSString stringWithFormat:@"%s :404",__FUNCTION__];
            failure(Error404Alert);
        }
    }];
}

//发送推荐 请求
+(void)sendRecommendWithRecommendContent:(NSString *)recommendContent
                               phoneList:(NSString *)phoneListStr
                                  userId:(NSString *)userId
                                 success:(void (^)(NSString *responseString))success
                                 failure:(void (^)(NSString *alert))failure
{
    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:@"ydzjMobile" urlKey:@"addRecommend"];
    
    NSDictionary *parameters = @{@"_clientType":@"wap", @"userId":userId, @"content":recommendContent, @"phoneList":phoneListStr};
    
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    [networkHelper showHUDAtView:nil message:nil];
    
    [networkHelper POST:urlString parameters:parameters success:^(QYNetworkResult *result)
    {
        if(result.statusCode == NetworkResultStatusCodeSuccess)
        {
            //NSLog(@"result.result==%@",result.result);
            success(result.result);
        }
        else if(result.statusCode == NetworkResultStatusCodeNoData)
        {
            success(result.result);
        }
        else
        {
            failure(result.errMessage);
        }
    }
    failure:^(NetworkErrorType errorType)
    {
        if (errorType == NetworkErrorTypeNoNetwork)
        {
            failure(ErrorNoNetworkAlert);
        }
        if (errorType == NetworkErrorType404)
        {
            NSString *errMessage = [NSString stringWithFormat:@"%s :404",__FUNCTION__];
            failure(Error404Alert);
        }
    }];
}

//发送 反馈请求
+ (void)sendProblemFeedBackWithContent:(NSString *)content userId:(NSString *)userId companyId:(NSString *)companyId success:(void (^)(NSString *successStr))success failure:(void (^)(NSString *error))failure
{
     NSString *urlString = [[QYURLHelper shared] getUrlWithModule:@"ydzjMobile" urlKey:@"addGuest"];
    
    NSDictionary *parameters = @{@"_clientType":@"wap", @"content":content, @"userId":userId, @"companyId":companyId};
    
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    [networkHelper showHUDAtView:nil message:nil];
    
    [networkHelper POST:urlString parameters:parameters success:^(QYNetworkResult *result)
     {
         if(result.statusCode == NetworkResultStatusCodeSuccess)
         {
             //NSLog(@"问题反馈result.result==%@",result.result);
             success(result.result);
         }
         else if(result.statusCode == NetworkResultStatusCodeNoData)
         {
             success(result.result);
         }
         else
         {
             failure(result.errMessage);
         }
     }
                failure:^(NetworkErrorType errorType)
     {
         if (errorType == NetworkErrorTypeNoNetwork)
         {
             failure(ErrorNoNetworkAlert);
         }
         if (errorType == NetworkErrorType404)
         {
             NSString *errMessage = [NSString stringWithFormat:@"%s :404",__FUNCTION__];
             failure(Error404Alert);
         }
     }];
}

//切换单位
+ (void)requestWith:(NSString *)companyId andWith:(NSString *)userId success:(void (^)(NSString *successStr))success failure:(void (^)(NSString *error))failure
{
    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:@"ydzjMobile" urlKey:@"checkCompOrderType"];
    
    NSDictionary *parameters = @{@"_clientType": @"wap", @"companyId": companyId, @"userId": userId};
    QYNetworkHelper *networkHelper = [[QYNetworkHelper alloc] init];
    networkHelper.parseDelegate = [QYNetworkJsonProtocol new];
    [networkHelper showHUDAtView:nil message:nil];
    
    [networkHelper POST:urlString parameters:parameters success:^(QYNetworkResult *result)
     {
         if(result.statusCode == NetworkResultStatusCodeSuccess)
         {
             //NSLog(@"切换单位result.result==%@",result.result);
             success(result.result);
         }
         else if(result.statusCode == NetworkResultStatusCodeNoData)
         {
             success(result.result);
         }
         else
         {
             failure(result.errMessage);
         }
     }
    failure:^(NetworkErrorType errorType)
     {
         if (errorType == NetworkErrorTypeNoNetwork)
         {
             failure(ErrorNoNetworkAlert);
         }
         if (errorType == NetworkErrorType404)
         {
             NSString *errMessage = [NSString stringWithFormat:@"%s :404",__FUNCTION__];
             failure(Error404Alert);
         }
     }];
}














@end
