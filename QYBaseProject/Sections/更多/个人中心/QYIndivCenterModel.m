//
//  QYIndivCenterModel.m
//  QYBaseProject
//
//  Created by 田 on 15/6/9.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYIndivCenterModel.h"

@implementation QYIndivCenterModel

+(QYIndivCenterModel *)configureDefaultCellModelOfLeftString:(NSString *)leftString
                                                 rightString:(NSString *)rightString
{
    QYIndivCenterModel *model = [[QYIndivCenterModel alloc] init];
    model.rightString = rightString;
    //NSLog(@"model.rightString====%@",model.rightString);
    model.leftString = leftString;
    model.indivCenterCellStyle = QYMoreCellStyleDefault;
    return model;

}

+(QYIndivCenterModel *)configureAvatarCellModelOfLeftString:(NSString *)leftString
                                                  imageUrl:(NSString *)imageUrl defaultImage:(UIImage *)defaultImage;
{
    QYIndivCenterModel *model = [[QYIndivCenterModel alloc] init];
    model.leftString = leftString;
    model.imageUrl = imageUrl;
    model.indivCenterCellStyle = QYMoreCellStyleAvatar;
    model.defaultImage = defaultImage;
    
    return model;
}


@end
