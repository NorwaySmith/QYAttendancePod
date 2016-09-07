//
//  QYUserRoleHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/6/15.
//  Copyright (c) 2015年 田. All rights reserved.
//



#import "QYUserRoleHelper.h"
#import "QYAccountService.h"
#import "QYMenuModel.h"

static NSString * const UserRoleHelperKey = @"com.quanya.UserRoleHelperKey";

@implementation QYUserRoleHelper
+ (QYUserRoleHelper *)shared
{
    static dispatch_once_t pred;
    static QYUserRoleHelper *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

/**
 *  设置权限字典
 *
 *  @param accounts 多个账户
 */
- (void)createUserRoles:(NSArray *)userRoles{
    [[NSUserDefaults standardUserDefaults] setObject:userRoles forKey:UserRoleHelperKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)getChildModile:(QYMenuModel*)menuModel moduleArray:(NSMutableArray*)allModuleArray{
    [allModuleArray addObject:menuModel];
    NSArray *childModileArray=menuModel.childModile;
        if ([childModileArray count]>0) {
            for (QYMenuModel  *childModile in childModileArray) {
                [self getChildModile:childModile moduleArray:allModuleArray];
            }
        }
}

- (UserRoleType)userRolesWithModuleId:(NSString *)moduleId{
    NSArray *userRoles=[self currCompanyUserRoleMap];
    //所有模块数组
    NSMutableArray *allModuleArray=[[NSMutableArray alloc] init];
    for (QYMenuModel  *menuModel in userRoles) {
        [self getChildModile:menuModel moduleArray:allModuleArray];
    }
    
    
    for (QYMenuModel  *menuModel in allModuleArray) {
        if ([menuModel.moduleId longLongValue] ==[moduleId longLongValue]) {
            if (menuModel.cOpen&&menuModel.uOpen) {
                return UserRoleTypeHave;
            }
            //公司权限
            if (!menuModel.cOpen) {
                return UserRoleTypeNoneUnit;
            }
            //个人权限
            if (!menuModel.uOpen) {
                return UserRoleTypeNonePersonal;
            }
        }
 
    }
    return UserRoleTypeNotExist;
}

//是否显示当前模块
- (BOOL)showModuleWithModuleId:(NSString *)moduleId{
    NSArray *userRoles=[self currCompanyUserRoleMap];
    //所有模块数组
    NSMutableArray *allModuleArray=[[NSMutableArray alloc] init];
    for (QYMenuModel  *menuModel in userRoles) {
         [self getChildModile:menuModel moduleArray:allModuleArray];
    }
    for (QYMenuModel  *menuModel in allModuleArray) {
        if ([menuModel.moduleId longLongValue] ==[moduleId longLongValue]) {
            return  menuModel.menu;
        }
    }
    return YES;
}

//当前公司的用户权限数组
-(NSArray*)currCompanyUserRoleMap{
    QYAccount *account=[[QYAccountService shared] defaultAccount];
    NSArray *userRoles=[[NSUserDefaults standardUserDefaults] objectForKey:UserRoleHelperKey];
    for (NSDictionary *userRoleMap in userRoles) {
        if ([userRoleMap[@"companyId"] isEqualToString:account.companyId]) {
            NSMutableDictionary *muDic=[[NSMutableDictionary alloc] initWithDictionary:userRoleMap];
            [muDic removeObjectForKey:@"companyId"];
            NSMutableArray *allArray=[[NSMutableArray alloc] init];
            
            
            NSArray *values=[muDic[@"userRoleMap"] allValues];
            for (NSArray *moduleArray in values) {
                for (NSDictionary *menuDic in moduleArray) {
                    [allArray addObject:menuDic];
                }
            }
            
            
           NSMutableArray *menuArray= [QYMenuModel arrayOfModelsFromDictionaries:allArray];
           //排序
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:YES];//其中，price为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
            [menuArray sortUsingDescriptors:sortDescriptors];
            return menuArray;
        }
    }
    return nil;
}


-(NSArray*)moduleArray{
    NSArray *menuArray=[self currCompanyUserRoleMap];

    return menuArray;
}
 /*
 <__NSArrayM 0x7fc7f0dbc470>(
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 
 </JSONModelArray>
 [menu]: 1
 [order]: 3
 [moduleName]: 通知公告
 [moduleId]: 46
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 {
 cOpen = 1;
 code = "recievemanager ";
 groups = "";
 menu = 1;
 moduleId = 33;
 moduleName = "\U6536\U6587\U7ba1\U7406";
 order = 0401;
 uOpen = 1;
 },
 {
 cOpen = 1;
 code = sendManager;
 groups = "";
 menu = 1;
 moduleId = 34;
 moduleName = "\U53d1\U6587\U7ba1\U7406";
 order = 0402;
 uOpen = 1;
 },
 {
 cOpen = 1;
 code = partmentGetTogether;
 groups = "";
 menu = 1;
 moduleId = 35;
 moduleName = "\U516c\U6587\U5f52\U6863";
 order = 0403;
 uOpen = 1;
 },
 
 </JSONModelArray>
 [menu]: 1
 [order]: 4
 [moduleName]: 公文管理
 [moduleId]: 8
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 
 </JSONModelArray>
 [menu]: 1
 [order]: 8
 [moduleName]: 新闻中心
 [moduleId]: 16
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 
 </JSONModelArray>
 [menu]: 1
 [order]: 9
 [moduleName]: 调查问卷
 [moduleId]: 17
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 
 </JSONModelArray>
 [menu]: 1
 [order]: 10
 [moduleName]: 部门专栏
 [moduleId]: 18
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 
 </JSONModelArray>
 [menu]: 1
 [order]: 10
 [moduleName]: 日志管理
 [moduleId]: 29
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 
 </JSONModelArray>
 [menu]: 1
 [order]: 11
 [moduleName]: 即时消息
 [moduleId]: 26
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 {
 cOpen = 1;
 code = sendByMe;
 groups = "";
 menu = 1;
 moduleId = 43;
 moduleName = "\U6211\U53d1\U8d77\U7684";
 order = 1201;
 uOpen = 1;
 },
 {
 cOpen = 1;
 code = doByMe;
 groups = "";
 menu = 1;
 moduleId = 44;
 moduleName = "\U6211\U627f\U529e\U7684";
 order = 1202;
 uOpen = 1;
 },
 {
 cOpen = 1;
 code = changeByMe;
 groups = "";
 menu = 1;
 moduleId = 45;
 moduleName = "\U6211\U8f6c\U4ea4\U7684";
 order = 1203;
 uOpen = 1;
 },
 
 </JSONModelArray>
 [menu]: 1
 [order]: 12
 [moduleName]: 任务管理
 [moduleId]: 42
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 {
 cOpen = 1;
 code = waiting;
 groups = "";
 menu = 1;
 moduleId = 22;
 moduleName = "\U5f85\U5ba1\U6279";
 order = 1301;
 uOpen = 1;
 },
 {
 cOpen = 1;
 code = approved;
 groups = "";
 menu = 1;
 moduleId = 23;
 moduleName = "\U5df2\U5ba1\U6279";
 order = 1302;
 uOpen = 1;
 },
 
 </JSONModelArray>
 [menu]: 1
 [order]: 13
 [moduleName]: 我的审批
 [moduleId]: 21
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 
 </JSONModelArray>
 [menu]: 1
 [order]: 15
 [moduleName]: 日程
 [moduleId]: 28
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 
 </JSONModelArray>
 [menu]: 1
 [order]: 18
 [moduleName]: 知识库
 [moduleId]: 31
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 
 </JSONModelArray>
 [menu]: 1
 [order]: 19
 [moduleName]: 移动打卡
 [moduleId]: 32
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 
 </JSONModelArray>
 [menu]: 1
 [order]: 20
 [moduleName]: 报表统计
 [moduleId]: 48
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 {
 cOpen = 1;
 code = domisread;
 groups = "";
 menu = 1;
 moduleId = 53;
 moduleName = "\U5f85\U9605\U8bfb";
 order = 3;
 uOpen = 1;
 },
 {
 cOpen = 1;
 code = domreaded;
 groups = "";
 menu = 1;
 moduleId = 54;
 moduleName = "\U5df2\U9605\U8bfb";
 order = 3;
 uOpen = 1;
 },
 
 </JSONModelArray>
 [menu]: 1
 [order]: 21
 [moduleName]: 公文阅读
 [moduleId]: 49
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 
 </JSONModelArray>
 [menu]: 1
 [order]: 24
 [moduleName]: 我的申请
 [moduleId]: 50
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>,
 <QYMenuModel>
 [groups]:
 [childModile]: <JSONModelArray[QYMenuModel]>
 {
 cOpen = 1;
 code = myDaily;
 groups = "";
 menu = 1;
 moduleId = 58;
 moduleName = "\U6211\U7684\U65e5\U5fd7";
 order = 59;
 uOpen = 1;
 },
 {
 cOpen = 1;
 code = shareDaily;
 groups = "";
 menu = 1;
 moduleId = 59;
 moduleName = "\U5171\U4eab\U65e5\U5fd7";
 order = 60;
 uOpen = 1;
 },
 
 </JSONModelArray>
 [menu]: 1
 [order]: 58
 [moduleName]: 工作日志
 [moduleId]: 57
 [cOpen]: 1
 [uOpen]: 1
 </QYMenuModel>
 )
 
 */
@end
