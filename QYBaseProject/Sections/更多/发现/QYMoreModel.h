//
//  QYMoreModel.h
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QYMoreCellStyle)
{
    QYMoreCellStyleDefault = 0,//默认
    QYMoreCellStyleAvatar = 1,//头像
};
@interface QYMoreModel : NSObject
@property (nonatomic, assign) QYMoreCellStyle moreCellStyle;
/**
 *  头像url
 */
@property (nonatomic, strong) NSString *imageUrl;
/**
 *  登录人姓名
 */
@property (nonatomic, strong) NSString *userName;
/**
 *  登录人公司名
 */
@property (nonatomic, strong) NSString *companyName;
/**
 *  默认cell图标
 */
@property (nonatomic, strong) UIImage *image;
/**
 *  默认cell标题
 */
@property (nonatomic, strong) NSString *modelTitle;
/**
 *  是否显示红点
 */
@property (nonatomic, assign) BOOL isShowBadge;

@property (nonatomic, assign) BOOL sex;
@property (nonatomic, strong) NSString *signName;
@property (nonatomic, strong) NSString *groupName;
@property (nonatomic, strong) NSString *job;
@property (nonatomic, strong) NSString *phone;


+(QYMoreModel *)configureAvatarCellOfImageUrl:(NSString *)imageUrl userName:(NSString *)userName companyName:(NSString *)companyName image:(UIImage*)image;

+(QYMoreModel *)configureDefaultCellOfImage:(UIImage *)image
                                modelTitle:(NSString *)modelTitle;
@end
