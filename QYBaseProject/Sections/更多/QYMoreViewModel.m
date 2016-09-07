//
//  QYMoreViewModel.m
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreViewModel.h"
#import "QYMoreModel.h"
@implementation QYMoreViewModel
-(NSArray*)assembleData{
    NSArray *oneSectionArray=@[
                               [QYMoreModel configureAvatarCellOfImageUrl:@"" userName:@"用户名" companyName:@"公司名" image:[UIImage imageNamed:@"more_photoMan"]]];
    NSArray *twoSectionArray=@[
                               [QYMoreModel configureDefaultCellOfImage:[UIImage imageNamed:@"more_tuijian"] modelTitle:@"推荐与反馈"],
                               [QYMoreModel configureDefaultCellOfImage:[UIImage imageNamed:@"more_setting"] modelTitle:@"设置"]];
   return  @[oneSectionArray,twoSectionArray];
}

@end
