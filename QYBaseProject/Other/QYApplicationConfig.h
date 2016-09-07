//
//  QYApplicationConfig.h
//  QYBaseProject
//
//  Created by 田 on 16/3/9.
//  Copyright © 2016年 田. All rights reserved.
//

#ifndef QYApplicationConfig_h
#define QYApplicationConfig_h
typedef NS_ENUM(NSInteger, Channel){
    /**
     *  内部灰度
     */
    ChannelBeta = 0,
    /**
     *  appstore发布版本
     */
    ChannelAppstore =1
};

#if TARGET_VERSION_BETA ==1
//...................内部、蒲公英版本.................//

#define Channel ChannelBeta

//版本更新类型
#define VersionType 1

// 百度地图key，乐工作
#define kBaiduMapKey @"1HlCytmL9InpD02ly6Asydfq"

// 友盟key
#define kUMKey @"55f0493ae0f55a4cb7006f92"

// 微信AppId
#define kWXAppId @"wx9fca301341a2a047"
#define kWXAppSecret @"0aabdd81baf6dfa093ab996fcbc1f735"

// QQ AppId
#define kQQAppId @"1104658239"
#define kQQAppKey @"XhZGuExRZBD3J6Wd"
//...................内部、蒲公英版本.................//


#elif TARGET_VERSION_APPSTORE ==1
//...................AppStore发布版.................//
#define Channel ChannelAppstore


//版本更新类型
#define VersionType 2

// 百度地图key，乐工作
#define kBaiduMapKey @"Q6RvjUMGNh2Gtwb0oj0qmKro"

// 友盟key
#define kUMKey @"56de310367e58e2a5200016b"

// 微信AppId
#define kWXAppId @"wxc38b551a38e54d1f"
#define kWXAppSecret @"51694a93a7a4f12f8e54a32f27813ffb"

// QQ AppId
#define kQQAppId @"1105235662"
#define kQQAppKey @"13boKLo3ZpSfj06f"
//...................AppStore发布版.................//

#endif


#endif /* QYApplicationConfig_h */
