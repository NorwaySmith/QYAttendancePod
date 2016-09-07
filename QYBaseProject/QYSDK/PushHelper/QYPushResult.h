//
//  QYPushResult.h
//  QYBaseProject
//
//  Created by 田 on 15/6/25.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, QYPushType) {
    QYPushTypeAPNS      = 0,      //APNS
    QYPushTypeMessage   = 1       //自定义消息
};


@interface QYPushResult : NSObject


/*!
*  @brief  APNS中的消息id
*/
@property(assign,nonatomic) QYPushType pushType;

/*!
 *  @brief  APNS中的消息id
 */
@property(assign,nonatomic) long long msgid;

/*!
 *  @brief  自定义消息中的content，APNS中的alert
 */
@property(copy,nonatomic) NSString *content;

/*!
 *  @brief  扩展字段，自定义消息中的extras，APNS中的自定义字段
 */
@property(strong,nonatomic) NSDictionary *extras;


/*!
 *  @brief  角标
 */
@property(assign,nonatomic) NSInteger badge;

/*!
 *  @brief  声音
 */
@property(copy,nonatomic) NSString *sound;


@end



//APNS
//Printing description of remoteInfo:
//{
//    "_j_msgid" = 3287720462;
//    a = 1;
//    aps =     {
//        alert = 1234567894;
//        badge = 1;
//        sound = default;
//    };
//}
//
//自定义消息
//Printing description of userInfo:
//{
//    content = 123456789;
//    extras =     {
//        a = 1;
//    };
//}



