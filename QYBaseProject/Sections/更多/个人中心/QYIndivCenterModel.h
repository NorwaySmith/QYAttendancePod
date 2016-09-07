//
//  QYIndivCenterModel.h
//  QYBaseProject
//
//  Created by 田 on 15/6/9.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QYIndivCenterCellStyle)
{
    QYMoreCellStyleDefault = 0,//默认
    QYMoreCellStyleAvatar = 1,//头像
};

@interface QYIndivCenterModel : NSObject
@property (nonatomic, assign) QYIndivCenterCellStyle indivCenterCellStyle;
/**
 *  左边文字
 */
@property (nonatomic, strong) NSString *leftString;
/**
 *  右边文字
 */
@property (nonatomic, strong) NSString *rightString;
/**
 *  头像url
 */
@property (nonatomic, strong) NSString *imageUrl;
/**
 *  默认头像
 */
@property (nonatomic, strong) UIImage *defaultImage;

+(QYIndivCenterModel*)configureDefaultCellModelOfLeftString:(NSString*)leftString
                                rightString:(NSString*)rightString;

+(QYIndivCenterModel*)configureAvatarCellModelOfLeftString:(NSString*)leftString
                                                  imageUrl:(NSString*)imageUrl defaultImage:(UIImage*)defaultImage;


@end
