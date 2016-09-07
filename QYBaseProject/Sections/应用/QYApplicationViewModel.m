//
//  QYApplicationViewModel.m
//  QYBaseProject
//
//  Created by 田 on 15/6/13.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYApplicationViewModel.h"
#import "QYApplicationModel.h"
#import "QYRedDotHelper.h"
#import "QYAccountService.h"

@implementation QYApplicationViewModel

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        [self assembleData];
    }
    return self;
}

- (void)assembleData {
    self.modelArray = [[NSMutableArray alloc] init];
    
    //  1、公告
    QYApplicationModel *noticeModel;
    
    QYRedDotModel *noticeRedDotModel =[[QYRedDotHelper shared] redDotModelWithModuleCode:QYRedDotStorageNotify];
    if (noticeRedDotModel.type == QYRedPointTypeNumbers) {
        NSString *badgeValue = nil;
        if (noticeRedDotModel.redPointNum > 0) {
            badgeValue = [NSString stringWithFormat:@"%ld",(long)noticeRedDotModel.redPointNum];
        }
        noticeModel = [[QYApplicationModel alloc] initWithTitle:kLgz_app_notice
                                                           icon:[UIImage imageNamed:@"app_notice"]
                                                     badgeValue:badgeValue badge:NO];
    } else {
        BOOL badge = NO;
        if (noticeRedDotModel.redPointNum > 0) {
            badge = YES;
        }
        noticeModel = [[QYApplicationModel alloc] initWithTitle:kLgz_app_notice
                                                           icon:[UIImage imageNamed:@"app_notice"]
                                                     badgeValue:nil
                                                          badge:badge];
    }
    
    //  2、打卡
    QYApplicationModel *punchCardModel = [[QYApplicationModel alloc] initWithTitle:kLgz_app_punchCard
                                                                              icon:[UIImage imageNamed:@"app_punchCard"]
                                                                        badgeValue:nil badge:NO];
    
    //  3、日志
    QYApplicationModel *html5plusLogModel =
    [[QYApplicationModel alloc] initWithTitle:kLgz_app_log
                                         icon:[UIImage imageNamed:@"app_log"]
                                   badgeValue:nil
                                        badge:NO];
    
    //  4、审批
    QYApplicationModel *html5plusWorkflowModel;
    QYRedDotModel *workflowRedDotModel =[[QYRedDotHelper shared] redDotModelWithModuleCode:QYRedDotStorageWorkflow];
    if (workflowRedDotModel.type == QYRedPointTypeNumbers) {
        NSString *badgeValue = nil;
        if (workflowRedDotModel.redPointNum > 0) {
            badgeValue = [NSString stringWithFormat:@"%ld",(long)workflowRedDotModel.redPointNum];
        }
        html5plusWorkflowModel = [[QYApplicationModel alloc] initWithTitle:kLgz_app_approve icon:[UIImage imageNamed:@"app_approve"] badgeValue:badgeValue badge:NO];
    } else {
        BOOL badge = NO;
        if (workflowRedDotModel.redPointNum > 0) {
            badge = YES;
        }
        html5plusWorkflowModel = [[QYApplicationModel alloc] initWithTitle:kLgz_app_approve icon:[UIImage imageNamed:@"app_approve"] badgeValue:nil badge:badge];
    }
    
    //  5、问卷
    QYRedDotModel *wenjuanRedDotModel =[[QYRedDotHelper shared] redDotModelWithModuleCode:QYRedDotStorageQuestion];
    QYApplicationModel *htmlModel;
    NSString *badgeValue = nil;
    if (wenjuanRedDotModel.type == QYRedPointTypeNumbers) {
        if (wenjuanRedDotModel.redPointNum > 0) {
            badgeValue = [NSString stringWithFormat:@"%ld",(long)wenjuanRedDotModel.redPointNum];
        }
        htmlModel = [[QYApplicationModel alloc] initWithTitle:kLgz_app_surveyQuestion
                                                         icon:[UIImage imageNamed:@"app_surveyQuestion"]
                                                   badgeValue:badgeValue badge:NO];
    }
    else if (wenjuanRedDotModel.type == QYRedPointTypeDelete) {
        htmlModel = [[QYApplicationModel alloc] initWithTitle:kLgz_app_surveyQuestion
                                                         icon:[UIImage imageNamed:@"app_surveyQuestion"]
                                                   badgeValue:badgeValue badge:NO];
    }
    else {
        BOOL badge = NO;
        if (wenjuanRedDotModel.redPointNum > 0) {
            badge = YES;
        }
        htmlModel = [[QYApplicationModel alloc] initWithTitle:kLgz_app_surveyQuestion
                                                         icon:[UIImage imageNamed:@"app_surveyQuestion"]
                                                   badgeValue:nil badge:badge];
    }
    
    //  6、在线课堂
    QYApplicationModel *onlineLesson = [[QYApplicationModel alloc] initWithTitle:kLgz_app_onLineLessono icon:[UIImage imageNamed:@"onLineLessono"] badgeValue:nil badge:NO];
    
    //  7、语音通知
    QYApplicationModel *tzModel =
    [[QYApplicationModel alloc] initWithTitle:kLgz_app_voice
                                         icon:[UIImage imageNamed:@"app_voice"]
                                   badgeValue:nil
                                        badge:NO];
    //  8、电话会议
    QYApplicationModel *meettingModel =
    [[QYApplicationModel alloc] initWithTitle:kLgz_app_meetting
                                         icon:[UIImage imageNamed:@"app_meetting"]
                                   badgeValue:nil
                                        badge:NO];
    //  9、常用号码
    QYApplicationModel *commonPhoneModel =
    [[QYApplicationModel alloc] initWithTitle:kLgz_app_commonPhone
                                         icon:[UIImage imageNamed:@"app_commonPhone"]
                                   badgeValue:nil
                                        badge:NO];
    //  10、CRM
    QYApplicationModel *crmModel = [[QYApplicationModel alloc] initWithTitle:kLgz_app_crm icon:[UIImage imageNamed:@"app_crm"] badgeValue:nil badge:NO];
    
    
//    停用模块
//        0、V网速拨
//        QYApplicationModel *vWangModel = [[QYApplicationModel alloc] initWithTitle:@"V网速拨" icon:[UIImage imageNamed:@"app_v"] badgeValue:nil badge:NO];
//        7、短信通
//        QYApplicationModel *smsModel = [[QYApplicationModel alloc] initWithTitle:@"短信通"
//                                                                            icon:[UIImage imageNamed:@"app_sms"]
//                                                                      badgeValue:nil badge:NO];
//        8、人工转接
//        QYApplicationModel *rengongzhuanjie = [[QYApplicationModel alloc] initWithTitle:@"人工转接" icon:[UIImage imageNamed:@"app_peopleservice"] badgeValue:nil badge:NO];
//    
//        //顺序
//        [_modelArray addObjectsFromArray:@[noticeModel,                     //  公告
//                                           html5plusWorkflowModel,          //  审批
//                                           meettingModel,                   //  电话会议
//                                           html5plusLogModel,               //  日志
//                                           punchCardModel,                  //  打卡
//                                           onlineLesson,                    //  在线课堂
//                                           htmlModel,                       //  问卷
//                                           tzModel,                         //  语音通知
//                                           crmModel,                        //  CRM
//                                           commonPhoneModel,                 //  常用号码
//    //停用模块
//    //                                       vWangModel,                    //  V网速拨
//    //                                       smsModel,                      //  短信通
//    //                                       rengongzhuanjie,               //  人工转接
//                                           ]];
    /**
     *  @author 杨峰, 16-04-13 10:04:54
     *
     *  新的调整 (公告、电话会议、语音通知、常用号码不可配，一直显示)(配置中不包含的模块显示，包含的模块根据cOpen判断是否显示)
     */
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    //  1、公告
    [_modelArray addObject:noticeModel];
    //  2、审批
    if ([[account.userRoleMap objectForKey:@"approve"] isKindOfClass:[NSDictionary class]]) {
        if ([[[account.userRoleMap objectForKey:@"approve"] objectForKey:@"cOpen"] intValue] == 1) {
            [_modelArray addObject:html5plusWorkflowModel];
        }
    }else{
        [_modelArray addObject:html5plusWorkflowModel];
    }
    //  3、电话会议
    [_modelArray addObject:meettingModel];
    //  4、日志
    if ([[account.userRoleMap objectForKey:@"worklog"] isKindOfClass:[NSDictionary class]]) {
        if ([[[account.userRoleMap objectForKey:@"worklog"] objectForKey:@"cOpen"] intValue] == 1) {
            [_modelArray addObject:html5plusLogModel];
        }
    }else{
        [_modelArray addObject:html5plusLogModel];
    }
    //  5、打卡
    if ([[account.userRoleMap objectForKey:@"attendance"] isKindOfClass:[NSDictionary class]]) {
        if ([[[account.userRoleMap objectForKey:@"attendance"] objectForKey:@"cOpen"] intValue] == 1) {
            [_modelArray addObject:punchCardModel];
        }
    }else{
        [_modelArray addObject:punchCardModel];
    }
    //  6、在线课堂
    if ([[account.userRoleMap objectForKey:@"exam"] isKindOfClass:[NSDictionary class]]) {
        if ([[[account.userRoleMap objectForKey:@"exam"] objectForKey:@"cOpen"] intValue] == 1) {
            [_modelArray addObject:onlineLesson];
        }
    }else{
        [_modelArray addObject:onlineLesson];
    }
    //  7、问卷
    if ([[account.userRoleMap objectForKey:@"question"] isKindOfClass:[NSDictionary class]]) {
        if ([[[account.userRoleMap objectForKey:@"question"] objectForKey:@"cOpen"] intValue] == 1) {
            [_modelArray addObject:htmlModel];
        }
    }else{
        [_modelArray addObject:htmlModel];
    }
    //  8、语音通知
    [_modelArray addObject:tzModel];
    //  9、CRM
    if ([[account.userRoleMap objectForKey:@"crm"] isKindOfClass:[NSDictionary class]]) {
        if ([[[account.userRoleMap objectForKey:@"crm"] objectForKey:@"cOpen"] intValue] == 1) {
            [_modelArray addObject:crmModel];
        }
    }else{
        [_modelArray addObject:crmModel];
    }
    //  10、常用号码
    [_modelArray addObject:commonPhoneModel];
    
    //  11、日程
    QYApplicationModel *html5plusscheduleModel =
    [[QYApplicationModel alloc] initWithTitle:@"日程"
                                         icon:[UIImage imageNamed:@"app_approve"]
                                   badgeValue:nil
                                        badge:NO];
    [_modelArray addObject:html5plusscheduleModel];

    //  11、任务
    QYApplicationModel *html5plusTaskModel =
    [[QYApplicationModel alloc] initWithTitle:@"任务"
                                         icon:[UIImage imageNamed:@"app_approve"]
                                   badgeValue:nil
                                        badge:NO];
    [_modelArray addObject:html5plusTaskModel];

}


@end

/*
approve =     {
    cOpen = 1;
    groups = 0;
    menu = 0;
    uOpen = 1;
};
attendance =     {
    cOpen = 0;
    groups = 0;
    menu = 0;
    uOpen = 0;
};
businessmeeting =     {
    cOpen = 0;
    groups = 0;
    menu = 0;
    uOpen = 0;
};
exam =     {
    cOpen = 0;
    groups = 0;
    menu = 0;
    uOpen = 0;
};
meeting =     {
    cOpen = 0;
    groups = 0;
    menu = 0;
    uOpen = 0;
};
news =     {
    cOpen = 0;
    groups = 0;
    menu = 0;
    uOpen = 0;
};
notifyManger =     {
    cOpen = 0;
    groups = 0;
    menu = 0;
    uOpen = 0;
};
notifyView =     {
    cOpen = 1;
    groups = 0;
    menu = 0;
    uOpen = 1;
};
roleGroup =     {
    cOpen = 1;
    groups = 0;
    menu = 0;
    uOpen = 0;
};
salary =     {
    cOpen = 1;
    groups = 0;
    menu = 0;
    uOpen = 1;
};
sms =     {
    cOpen = 1;
    groups = 0;
    menu = 0;
    uOpen = 1;
};
tzt =     {
    cOpen = 0;
    groups = 0;
    menu = 0;
    uOpen = 0;
};
workflow =     {
    cOpen = 0;
    groups = 0;
    menu = 0;
    uOpen = 0;
};
ydzj =     {
    cOpen = 0;
    groups = 0;
    menu = 0;
    uOpen = 0;
};
*/
