//
//  QYSetViewController.m
//  QYBaseProject
//
//  Created by 田 on 15/6/10.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYSetViewController.h"

#import "QYTheme.h"
#import "QYAccountService.h"
#import "QYInitUI.h"
#import "QYAboutTXZLViewController.h"
#import "APService.h"
#import "QYRedDotHelper.h"
#import "QYFunctionExplainViewController.h"
#import "QYURLHelper.h"
#import "QYLoginSwitchUnitViewController.h"
#import "QYVersionHelper.h"
#import <QYAddressBook/QYABBasicDataHelper.h>
#import <NoticeMsgCBB/QYSMSMobanHelper.h>
#import "QYThePasswordModifyViewController.h"
#import <QYDIDIReminCBB/QYDiDiNewMsgHelper.h>
#import <NewsCenter/QYNewsNotificationMonitor.h>
#import <SDWebImage/SDImageCache.h>
#import <NewIM/QYIMDiskCacheManager.h>
#import "IOSTool.h"
#import "MBProgressHUD.h"
#import "QYABIconGengerator.h"
#import "QYSetSwitchCell.h"
#import "QYSetDefaultCell.h"
#import "QYSetVersionCell.h"
#import "QYShakeHelper.h"
#import "QYLoginNetworkApi.h"

#import "QYApplicationConfig.h"
#import <Meeting/QYMeetingMemoryBallManager.h>

//区间距
static CGFloat const SectionPadding = 6;


static NSString * SwitchCellIdentifier = @"SwitchCellIdentifier";
static NSString * DefaultCellIdentifier = @"DefaultCellIdentifier";
static NSString * VersionCellIdentifier = @"VersionCellIdentifier";

//退出登录alertView tag
static NSInteger QuitAlertViewTag = 1;
//清除缓存alertView tag
static NSInteger CleanCacheAlertViewTag = 2;


@interface QYSetViewController ()
<QYSetSwitchCellDelegate,
UIAlertViewDelegate>

@property(nonatomic,strong) NSArray *itemArray;
@property(nonatomic,strong) MBProgressHUD *cleanCacheHud;


@end


@implementation QYSetViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.title = @"设置";
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}


#pragma mark - life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self removeTableViewLine];
    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.tableView.backgroundColor = [UIColor themeListBackgroundColor];
    self.tableView.separatorColor = [UIColor appSeparatorColor];
    
    [self.tableView registerClass:[QYSetSwitchCell class] forCellReuseIdentifier:SwitchCellIdentifier];
    [self.tableView registerClass:[QYSetVersionCell class] forCellReuseIdentifier:VersionCellIdentifier];
    [self.tableView registerClass:[QYSetDefaultCell class] forCellReuseIdentifier:DefaultCellIdentifier];

    
    [self assembleData];
}
- (void)viewWillAppear:(BOOL)animated
{
    self.hidesBottomBarWhenPushed = YES;
}
-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI

-(void)removeTableViewLine
{
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] init];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return SectionPadding * 2;
    }
    
    return SectionPadding;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SectionPadding;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ThemeListHeightSingle;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_itemArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_itemArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QYSetModel *cellModel = _itemArray[indexPath.section][indexPath.row];
    if (cellModel.cellType == QYSetCellTypeDefault) {
        QYSetDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:DefaultCellIdentifier forIndexPath:indexPath];
        cell.cellModel = cellModel;
        return cell;
    }
    if (cellModel.cellType == QYSetCellTypeRightLabel) {
        QYSetVersionCell *cell = [tableView dequeueReusableCellWithIdentifier:VersionCellIdentifier forIndexPath:indexPath];
        cell.cellModel = cellModel;
        return cell;
        
    }
    if (cellModel.cellType == QYSetCellTypeRightSwitch) {
        QYSetSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:SwitchCellIdentifier forIndexPath:indexPath];
        cell.delegate = self;
        cell.cellModel = cellModel;
        return cell;
    }
   
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    QYSetModel *cellModel = _itemArray[indexPath.section][indexPath.row];

    NSString *item = cellModel.leftText;
    
    if ([item isEqualToString:@"功能介绍"]) {
        //NSLog(@"功能介绍");
        [self functionExplain];
    }
    if ([item isEqualToString:@"检查更新"]) {
        //NSLog(@"当前版本");
        [self updateVersions];
    }
    if ([item isEqualToString:@"关于"]) {
        //NSLog(@"关于");
        [self aboutTXZL];
    }
    if ([item isEqualToString:@"密码修改"]) {
        [self thePassWordModify];
    }
    if ([item isEqualToString:@"切换单位"]) {
        //NSLog(@"切换单位");
        [self cutCompany];
    }
    if ([item isEqualToString:@"退出登录"]) {
        UIAlertView *quitAppAlertView = [[UIAlertView alloc] initWithTitle:nil message:@"你确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        quitAppAlertView.tag = QuitAlertViewTag;
        [quitAppAlertView show];
    }
    if ([item isEqualToString:@"清除缓存"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确定要清除缓存吗？" message:@"根据缓存文件的大小，清除时间从几秒到几分钟不等，请耐心等待" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alertView.tag = CleanCacheAlertViewTag;
        [alertView show];
    }
}

#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //清除缓存
    if (alertView.tag == CleanCacheAlertViewTag) {
        if(buttonIndex == 1) {
            [self cleanCaches];
        }
    }
    
    //退出登录
    if (alertView.tag == QuitAlertViewTag) {
        if(buttonIndex == 1) {
            [self signOut];
        }
    }
}
#pragma mark - CustomDelegate
#pragma mark -- QYSetSwitchCellDelegate
-(void)switchCell:(QYSetSwitchCell *)cell switchStateChange:(BOOL)on {
    if (on) {
        [[QYShakeHelper shared] openShake];
    }else{
        [[QYShakeHelper shared] closeShake];
    }
}

#pragma mark - event response
#pragma mark - private methods
-(void)assembleData
{
    QYSetModel *functionModel = [[QYSetModel alloc] init];
    functionModel.cellType = QYSetCellTypeDefault;
    functionModel.leftText = @"功能介绍";
    
    QYSetModel *versionModel = [[QYSetModel alloc] init];
    versionModel.cellType = QYSetCellTypeRightLabel;
    versionModel.leftText = @"检查更新";
    versionModel.rightValue = [[QYVersionHelper shared] currVersion];
    versionModel.isShowBadge = [QYVersionHelper shared].isHaveVersion;
    
    QYSetModel *aboutModel = [[QYSetModel alloc] init];
    aboutModel.leftText = @"关于";
    
    NSArray *oneSectionArray;
    if(Channel == ChannelAppstore){
        //NSLog(@"ChannelAppstore");
        oneSectionArray = @[functionModel,aboutModel];
    }else if (Channel == ChannelBeta) {
        oneSectionArray = @[functionModel,versionModel,aboutModel];
    }
    
    
    
    QYSetModel *shakeModel = [[QYSetModel alloc] init];
    shakeModel.cellType = QYSetCellTypeRightSwitch;
    shakeModel.leftText = @"开启摇一摇";
    shakeModel.rightValue = @(![[QYShakeHelper shared] isCloseShake]);
    
    QYSetModel *cacheModel = [[QYSetModel alloc] init];
    cacheModel.cellType = QYSetCellTypeDefault;
    cacheModel.leftText = @"清除缓存";
    
    NSArray *twoSectionArray = @[shakeModel,cacheModel];
    
    
    QYSetModel *passwordModel = [[QYSetModel alloc] init];
    passwordModel.cellType = QYSetCellTypeDefault;
    passwordModel.leftText = @"密码修改";
    
    NSArray *threeSectionArray = @[passwordModel];
    
    
    QYSetModel *quitModel = [[QYSetModel alloc] init];
    quitModel.cellType = QYSetCellTypeDefault;
    quitModel.leftText = @"退出登录";
    
    NSArray *fourSectionArray;
    if ([[[QYAccountService shared] allAccounts] count] > 1) {
        QYSetModel *switchUnitModel = [[QYSetModel alloc] init];
        switchUnitModel.cellType = QYSetCellTypeDefault;
        switchUnitModel.leftText = @"切换单位";
        
        fourSectionArray = @[switchUnitModel,quitModel];
    } else {
        fourSectionArray = @[quitModel];
    }
    
    
    self.itemArray = @[oneSectionArray,twoSectionArray,threeSectionArray,fourSectionArray];

    [self.tableView reloadData];
}

/**
 *  清除缓存
 */
-(void)cleanCaches {
    if (_cleanCacheHud) {
        [_cleanCacheHud hide:NO afterDelay:0];
    }
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    self.cleanCacheHud = [[MBProgressHUD alloc] initWithWindow:window];
    _cleanCacheHud.labelText = @"正在清理缓存...";
    [window addSubview:_cleanCacheHud];
    
    _cleanCacheHud.removeFromSuperViewOnHide = YES;
    [_cleanCacheHud show:YES];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //清理网络缓存图片，异步
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
            //清理根据名字生成的默认图片
            QYABIconGengerator *iconGengerator=[[QYABIconGengerator alloc] init];
            [iconGengerator clearDiskCaches];
            //清除IM缓存
            [[QYIMDiskCacheManager shared] clearDiskCaches];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_cleanCacheHud hide:YES afterDelay:0.0];
                [QYDialogTool showDlg:@"清除完成"];
            });
        }];
    });
    
    
    
    
}
//测试代码
- (CGFloat)allCachesSize{
    CGFloat documentSize=[self folderSizeAtPath:[QYSandboxPath documentPath]];
    CGFloat tmpSize=[self folderSizeAtPath:[QYSandboxPath tmpPath]];
    return documentSize+tmpSize;
}
//单个文件的大小，测试代码
- (long long)fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M，测试代码
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}



/**
 * 功能介绍
 */
- (void)functionExplain
{
    QYFunctionExplainViewController *functionExplainVC = [[QYFunctionExplainViewController alloc] init];
    functionExplainVC.title = @"功能介绍";
    functionExplainVC.Url = [NSURL URLWithString:@"http://www.le-work.com/lework/index.html"];
    
    [self.navigationController pushViewController:functionExplainVC animated:YES];
}

/**
 * 主动更新版本
 */
- (void)updateVersions
{
    //NSLog(@"更新版本");
    [[QYVersionHelper shared] initiativeUpdate];
}



/**
 * 关于
 */
- (void)aboutTXZL
{
    QYAboutTXZLViewController *aboutTXZLVC = [[QYAboutTXZLViewController alloc] init];
    [self.navigationController pushViewController:aboutTXZLVC animated:YES];
}
/**
 * 修改密码
 */
- (void)thePassWordModify
{
    QYThePasswordModifyViewController *passwordModifyVC = [[QYThePasswordModifyViewController alloc] init];
    [self.navigationController pushViewController:passwordModifyVC animated:YES];
}

/**
 * 切换单位
 */
- (void)cutCompany
{
    QYLoginSwitchUnitViewController *switchUnitViewController = [[QYLoginSwitchUnitViewController alloc] init];
    [self.navigationController pushViewController:switchUnitViewController animated:YES];
    
    switchUnitViewController.completBlock = ^
    {
        @try {
            QYAccount *account = [[QYAccountService shared] defaultAccount];
            [QYLoginNetworkApi rememberLoginDeviceWithUserId:account.userId
                                                     success:^(NSString *responseString) {
                                                         //删除悬浮球
                                                         [[QYMeetingMemoryBallManager shared] removeMemoryBall];
                                                         //清除IM缓存
                                                         [[QYIMDiskCacheManager shared] clearDiskCaches];
                                                         [[QYRedDotHelper shared] resetData];
                                                         [[QYABBasicDataHelper shared] resetABData]; //基础数据
                                                         [[QYSMSMobanHelper shared] resetSMSMobanData];
                                                         [[QYDiDiNewMsgHelper shared] removeDataForNewRemind];//清除嘀嘀最新提醒缓存
                                                         [[QYNewsNotificationMonitor shared] removeDataForNewRemind];//清除分享号最新新闻缓存
                                                         [[QYInitUI shared] initUI:nil];
                                                     }
                                                     failure:^(NSString *alert) {
                                                         [QYDialogTool showDlg:NSLocalizedString(@"SSO_alertView_faildPrompt", nil)];
                                                     }];
            
            
        }
        @catch (NSException *exception) {
            //NSLog(@"exception: %@", exception);
        }

    };
}

/**
 * 退出登录
 */
-(void)signOut
{
    //删除悬浮球
    [[QYMeetingMemoryBallManager shared] removeMemoryBall];
    //清除IM缓存
    [[QYIMDiskCacheManager shared] clearDiskCaches];

    [[QYRedDotHelper shared] resetData]; //红点
    
    [[QYDiDiNewMsgHelper shared] removeDataForNewRemind];//清除嘀嘀最新提醒缓存
    [[QYNewsNotificationMonitor shared] removeDataForNewRemind];//清除分享号最新新闻缓存
    
    //退出登陆并且清空数据库
    [[QYABBasicDataHelper shared] resetABData]; //基础数据
    [[QYSMSMobanHelper shared] resetSMSMobanData];
    
    //推送
    [APService setTags:[NSSet set] alias:@"" callbackSelector:nil target:nil];
    
    //移除默认账户
    [[QYAccountService shared] removeDefaultAccount];
    
    //通知公告 手动 添加数据 处理
    //手动添加数据 是否有红点
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isClickHandWritCell"];

//    //暂不启用，嘀嘀回复不显示相关红点
//    //嘀嘀回复的红点手动置0
//    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"didiReplyUnReadCount"];
    
    [[QYAccountService shared] removeAllAccount];
    [[QYInitUI shared] initUI:nil];
}



#pragma mark - getters and setters

@end
