//
//  QYMoreModel.m
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreModel.h"

@interface QYMoreModel ()

@end

@implementation QYMoreModel
+(QYMoreModel*)configureAvatarCellOfImageUrl:(NSString*)imageUrl userName:(NSString*)userName companyName:(NSString*)companyName  image:(UIImage*)image{
    QYMoreModel *moreModel=[[QYMoreModel alloc] init];
    moreModel.imageUrl=imageUrl;
    moreModel.userName=userName;
    moreModel.companyName=companyName;
    moreModel.moreCellStyle=QYMoreCellStyleAvatar;
    moreModel.image=image;
    return moreModel;
}

+(QYMoreModel*)configureDefaultCellOfImage:(UIImage*)image modelTitle:(NSString*)modelTitle{
    QYMoreModel *moreModel=[[QYMoreModel alloc] init];
    moreModel.image=image;
    moreModel.modelTitle=modelTitle;
    moreModel.moreCellStyle=QYMoreCellStyleDefault;
    return moreModel;
}

@end
