//
//  QYMoreViewModel.m
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYMoreViewModel.h"
#import "QYMoreModel.h"
#import "QYAccountService.h"
#import "QYABIconGengerator.h"

#import <QYAddressBook/QYABDb.h>
#import <QYAddressBook/QYABUserModel.h>
#import "QYVersionHelper.h"
@interface QYMoreViewModel()

@end

@implementation QYMoreViewModel
-(instancetype)init{
    self=[super init];
    if (self) {
        //有新版本通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(haveNewVersion)
                                                     name:HaveNewVersionNotification
                                                   object:nil];
    }
    return self;
}
-(NSArray *)assembleData
{
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    
    QYABUserModel *userModel = [QYABDb userWithUserId:account.userId];
    
    // 0:女  1:男
    QYABIconGengerator *generator = [[QYABIconGengerator alloc] init];
    UIImage *headImage = [generator getHeaderIconFromName:userModel.userName];

    
    NSArray *oneSectionArray = @[
                               [QYMoreModel configureAvatarCellOfImageUrl:@"" userName:account.userName companyName:account.companyName image:headImage]];
    NSArray *twoSectionArray = @[[QYMoreModel configureDefaultCellOfImage:[UIImage imageNamed:@"statistics"] modelTitle:@"使用统计"]];
    
    NSArray *threeSectionArray = @[[QYMoreModel configureDefaultCellOfImage:[UIImage imageNamed:@"payStub"] modelTitle:@"工资条"]];
    
    NSArray *fourSectionArray = @[[QYMoreModel configureDefaultCellOfImage:[UIImage imageNamed:@"recommendAndFeedback"] modelTitle:@"推荐给朋友"] ,[QYMoreModel configureDefaultCellOfImage:[UIImage imageNamed:@"feedBack"] modelTitle:@"问题反馈"]];
    
    QYMoreModel *setModel=[QYMoreModel configureDefaultCellOfImage:[UIImage imageNamed:@"set"] modelTitle:@"设置"];
    setModel.isShowBadge = _isHaveNewVersion;
     NSArray *fiveSectionArray = @[setModel];
    
//    NSArray *fiveSectionArray = @[[QYMoreModel configureDefaultCellOfImage:[UIImage imageNamed:@"搜索"] modelTitle:@"更多搜索"]];
    
   return  @[oneSectionArray,twoSectionArray,threeSectionArray,fourSectionArray,fiveSectionArray];
}
/**
 *  有新版本时的通知
 */
-(void)haveNewVersion{
    //显示红点
    _isHaveNewVersion = YES;
    
    if ([_delegate respondsToSelector:@selector(moreViewNeedReload)]) {
        [_delegate moreViewNeedReload];
    }
    
}
@end
