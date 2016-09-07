//
//  QYVersionHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/6/10.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYVersionHelper.h"
#import "QYVersionNetworkApi.h"
#import "QYAccountService.h"
#import "QYVersionModel.h"
//#import "QYBadgeManage.h"

static NSInteger const StrongAlertViewTag = 1;
static NSInteger const AlertViewTag = 2;
static NSInteger const InitiativeAlertViewTag = 3;

static NSString *const VersionUpdateTimeKey = @"com.quanya.CBB.QYVersionHelper.VersionUpdateTimeKey";

@interface QYVersionHelper()

@property(nonatomic,strong)QYVersionModel *versionModel;
//主动更新的model
@property(nonatomic,strong)QYVersionModel *initiativeVersionModel;

@end

@implementation QYVersionHelper

+ (QYVersionHelper *)shared
{
    static dispatch_once_t pred;
    static QYVersionHelper *sharedInstance = nil;
    
    dispatch_once(&pred, ^
    {
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
//当前build号
-(NSString *)currBuild
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    return [infoDict objectForKey:@"CFBundleVersion"];
}
//当前版本号
-(NSString *)currVersion
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    return [infoDict objectForKey:@"CFBundleShortVersionString"];
}

//开始更新
- (void)update
{
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    if (!account)
    {
        return;
    }
    //不为空说明已请求过更新数据
    if (_versionModel)
    {
        [self updateDone];
        return;
    }
    NSInteger versionCode = [[self currBuild] integerValue];
    NSAssert(versionCode > 0, @"error :Build需是一个大于0的正整数！");
   
    //更新请求
    [QYVersionNetworkApi updateVersion:versionCode
                                userId:account.userId
                             companyId:account.companyId
                               showHud:NO
                               success:^(NSString *responseString)
    {
        NSError *error = nil;
        self.versionModel = [[QYVersionModel alloc] initWithString:responseString error:&error];
        if (_versionModel)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:HaveNewVersionNotification object:nil];
            self.isHaveVersion=YES;
            [self updateDone];
        }
        else
        {
            self.isHaveVersion=NO;
        }
    }
    failure:^(NSString *alert)
    {
        self.isHaveVersion=NO;
    }];
}
//更新完成，弹出提示
-(void)updateDone
{
    if (_versionModel.isStrong)
    {
        //强制更新，每次程序变为激活状态必弹
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"你当前使用的版本V%@太out了，请下载新版本体验吧。",[self currVersion]] message:_versionModel.versionContent delegate:self cancelButtonTitle:@"立即更新" otherButtonTitles:nil];
        alertView.tag = StrongAlertViewTag;
        [alertView show];
    }
    else
    {
        if ([self isShowAlertViewWhenNotStrong])
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本V%@，是否立即更新？",_versionModel.versionName] message:_versionModel.versionContent delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"立即更新", nil];
            alertView.tag = AlertViewTag;
            [alertView show];
    
            [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:VersionUpdateTimeKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

//当没有强制更新的时候是否弹出alert
-(BOOL)isShowAlertViewWhenNotStrong
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastUpdateDate = [userDefaults objectForKey:VersionUpdateTimeKey];
    if (!lastUpdateDate)
    {
        return YES;
    }
    if (![self isToday:lastUpdateDate])
    {
        return YES;
    }
    return NO;
}
#pragma mark - 日历获取在9.x之后的系统使用currentCalendar会出异常。在8.0之后使用系统新API。
- (NSCalendar *)currentCalendar {
    if ([NSCalendar respondsToSelector:@selector(calendarWithIdentifier:)]) {
        return [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    }
    return [NSCalendar currentCalendar];
}
//是否今天
- (BOOL)isToday:(NSDate*)otherDate
{
    NSCalendar *calendar = [self currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1. 获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components :unit fromDate :[NSDate date]];
    // 2. 获得 self 的年月日
    NSDateComponents *selfCmps = [calendar components :unit fromDate : otherDate ];
    
    return (selfCmps.year == nowCmps.year) &&
           (selfCmps.month == nowCmps.month) &&
           (selfCmps.day == nowCmps.day );
    
}
//点击更新，跳转到浏览器
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //强制更新
    if (alertView.tag == StrongAlertViewTag)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_versionModel.versionSrc]];
        //强制更新，继续弹出
        [self updateDone];
    }
    //不强制更新
    if (alertView.tag == AlertViewTag)
    {
        if(buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_versionModel.versionSrc]];
        }
    }
    //用户主动更新
    if (alertView.tag==InitiativeAlertViewTag)
    {
        if(buttonIndex==1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_initiativeVersionModel.versionSrc]];
        }
    }
    
    //更多（app更新）
    if (buttonIndex == 1)
    {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:@"0" forKey:@"moreAppUpdate"];
    }
}



/**
 *  用户主动更新新版本
 */
- (void)initiativeUpdate
{
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    if (!account)
    {
        return;
    }

    NSInteger  versionCode = [[self currBuild] integerValue];
    NSAssert(versionCode > 0, @"error :Build需是一个大于0的正整数！");
    [QYVersionNetworkApi updateVersion:versionCode userId:account.userId companyId:account.companyId showHud:YES success:^(NSString *responseString)
    {
        NSError *error = nil;
        self.initiativeVersionModel = [[QYVersionModel alloc] initWithString:responseString error:&error];
        
        [self initiativeUpdateShowAlert];
       
    }
    failure:^(NSString *alert)
    {
        [QYDialogTool showDlg:alert];
    }];

}
-(void)initiativeUpdateShowAlert
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"发现新版本V%@，是否立即更新？",_initiativeVersionModel.versionName] message:_initiativeVersionModel.versionContent delegate:self cancelButtonTitle:@"暂不更新" otherButtonTitles:@"立即更新", nil];
    alertView.tag = InitiativeAlertViewTag;
    [alertView show];

}

@end
