//
//  QYVoiceNotification.h
//  QY
//
//  Created by 田 on 14-9-18.
//  Copyright (c) 2014年 com.qytx.www. All rights reserved.
//

/* 实例-------------------------------------(获取语音通知列表页面,跳转)----------------------------------------
 
 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
 YYZTRequestEntity *requestEntity = [YYZTRequestEntity sharedInstance];

 NSString *urlString = VoiceNotificationUrl;
 NSString *urlString1 = PersonPhotoUrlStringYYTZ;
 requestEntity.urlString = urlString;
 requestEntity.userId = [userDefaults objectForKey:@"userId"];
 requestEntity.groupId = [userDefaults objectForKey:@"groupId"];
 requestEntity.companyId = [userDefaults objectForKey:@"companyId"];
 requestEntity.userName = [userDefaults objectForKey:@"userName"];
 requestEntity.phone = [userDefaults objectForKey:@"phone"];
 requestEntity.token = [userDefaults objectForKey:@"companyId"];
 requestEntity.groupName = [userDefaults objectForKey:@"groupName"]?[userDefaults objectForKey:@"groupName"]:@"";
 requestEntity.photoUrlString = [NSString stringWithFormat:@"%@_clientType=wap&filePath=",urlString1];
 requestEntity.notificationType = YYTZNotificationVoice;
 requestEntity.listType = YYTZOneList;
 
 QYVoiceNotification *voiceNotification = [[QYVoiceNotification alloc] init];
 
 UINavigationController *voiceNotificationController = [voiceNotification voiceNotification];
 voiceNotificationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
 voiceNotificationController.modalPresentationStyle =UIModalPresentationFullScreen;
 
 [self presentViewController:voiceNotificationController animated:YES completion:nil];
 
 */


/* 实例-------------------------------------(获取短信通列表页面,跳转)----------------------------------------
 
 NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
 YYZTRequestEntity *requestEntity = [YYZTRequestEntity sharedInstance];
 
 NSString *urlString = VoiceNotificationUrl;
 NSString *urlString1 = PersonPhotoUrlStringYYTZ;
 requestEntity.urlString = urlString;
 requestEntity.userId = [userDefaults objectForKey:@"userId"];
 requestEntity.groupId = [userDefaults objectForKey:@"groupId"];
 requestEntity.companyId = [userDefaults objectForKey:@"companyId"];
 requestEntity.userName = [userDefaults objectForKey:@"userName"];
 requestEntity.phone = [userDefaults objectForKey:@"phone"];
 requestEntity.token = [userDefaults objectForKey:@"companyId"];
 requestEntity.groupName = [userDefaults objectForKey:@"groupName"]?[userDefaults objectForKey:@"groupName"]:@"";
 requestEntity.photoUrlString = [NSString stringWithFormat:@"%@_clientType=wap&filePath=",urlString1];
 requestEntity.notificationType = YYTZNotificationSMS;
 requestEntity.listType = YYTZOneList;
 
 QYVoiceNotification *voiceNotification = [[QYVoiceNotification alloc] init];
 
 UINavigationController *voiceNotificationController = [voiceNotification voiceNotification];
 voiceNotificationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
 voiceNotificationController.modalPresentationStyle =UIModalPresentationFullScreen;
 
 [self presentViewController:voiceNotificationController animated:YES completion:nil];
 
 */

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    YYTZNotificationVoice,  //语音通
    YYTZNotificationSMS,    //短信通
} YYTZNotificationType;

//2015年4月30号  提示框改动  hud改为QYTool showAlert
//2015年5月4日 更改蝉道bug (22389,22393,22395,22406,22414,22415)
//2015年5月5日 发送消息时systemName改为从登录获取的systemName值，如果不存在systemName为ydtxzl，移动通讯助理专用
//2015年5月7日  选择人员外置，提供QYYYZTDelegate作为外置接口，实体类中增加QYAppName来根据项目需求对app进行适配

// 获取页面之前需要先设置 YYZTRequestEntity 单例信息

// 获取语音通知/短信通页面
@interface QYVoiceNotification : NSObject
/**
 *  获取语音通知/短信通列表页面
 *
 *  @return 语音通知/短信通列表页面
 */
-(id)voiceNotificationWithYYTZNotificationType:(YYTZNotificationType)notificationType;

@end
