//
//  QYTabBarController.m
//  QYBaseProject
//
//  Created by 田 on 15/6/4.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYTabBarController.h"
#import "QYApplicationViewController.h"
#import "QYMoreViewController.h"
#import "QYNavigationViewController.h"
#import "QYTheme.h"
#import <CallNumberCBB/QYCallNumberViewController.h>
#import <CallNumberCBB/QYCallNumberDb.h>
#import "IOSTool.h"
#import "QYRedDotHelper.h"
#import <QYAddressBook/QYAddressHeader.h>
#import "QYURLHelper.h"
#import <NewsCenter/QYNewsListViewController.h>
#import <NewsCenter/QYNewsNotificationMonitor.h>
#import "MBProgressHUD.h"
#import <QYDIDIReminCBB/QYDiDiListViewController.h>
#import <QYDIDIReminCBB/QYDiDiNewMsgHelper.h>
#import <QYDIDIReminCBB/QYDiDiNewRemindViewController.h>
#import <QYDIDIReminCBB/QYDiDiReplyDetailViewController.h>

#import <QYAddressBook/QYABUnitDetailViewController.h>
#import <QYAddressBook/QYABEnum.h>
#import "UIImageView+Round.h"
#import "QYVersionHelper.h"
#import <QYDIDIReminCBB/QYDiDiShakeViewController.h>
#import <QYDIDIReminCBB/QYDiDiRemindHeader.h>
#import <NewIM/QYIMListViewController.h>
#import <NewIM/QYIMChatViewController.h>
#import <NewIM/QYIMProtocol.h>
#import <NewIM/QYIMChatUserModel.h>
#import <NewIM/QYIMConstant.h>
#import <NewIM/QYIMListViewModel.h>
#import "QYPushHelper.h"
#import "QYAccountService.h"
#import "QYNotificationView.h"

@interface QYTabBarController ()

<UITabBarControllerDelegate,
QYIMProtocol,
QYIMListViewModelDelegate,
QYABProtocol>

/**
 *  应用
 */
@property (nonatomic, strong) QYApplicationViewController *applicationViewController;
/**
 *  应用导航控制器
 */
@property (nonatomic, strong) QYNavigationViewController *applicationViewNavigationController;

/**
 *  我
 */
@property (nonatomic, strong) QYMoreViewController *moreViewController;
/**
 *  我导航控制器
 */
@property (nonatomic, strong) QYNavigationViewController *moreVNavigationController;

/**
 *  嘀嘀列表
 */
@property (nonatomic, strong) QYDiDiListViewController *didiListViewController;
/**
 *  嘀嘀列表导航控制器
 */
@property (nonatomic, strong) QYNavigationViewController *didiListNavigationController;

/**
 *  通讯录
 */
@property (nonatomic, strong) QYABViewController *ABViewController;
/**
 *  通讯录导航控制器
 */
@property (nonatomic, strong) QYNavigationViewController *ABViewNavigationController;

/**
 *  IM列表
 */
@property (nonatomic, strong) QYIMListViewController *imViewController;
/**
 *  IM列表导航控制器
 */
@property (nonatomic, strong) QYNavigationViewController *imViewNavigationController;

/**
 *  更多红点
 */
@property (nonatomic, strong) UIImageView *moreLabelBadgeIconView;

@end

@implementation QYTabBarController

/**
 *  得到当前tabbar
 *
 *  @return 当前程序tabbar
 */
+ (QYTabBarController *)currTabBar{
    QYTabBarController *tabBarController = (QYTabBarController *)[UIApplication sharedApplication].delegate.window.rootViewController;
    if ([tabBarController isKindOfClass:[QYTabBarController class]]){
        return tabBarController;
    }
    return nil;
}
#pragma mark - life cycle

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setDelegate:self];
        [[self tabBar] setTranslucent:NO];
        //配置viewControllers
        [self setupViewControllers];
        //监听红点改变通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updateNotificationBadgeVisibility)
                                                     name:kQYRedDotChangeNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //改变TabBar分割线颜色
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,[UIColor colorWithRed:214.0/255 green:214.0/255 blue:214.0/255 alpha:1.0].CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc] init]];
    
    
    //嘀嘀提醒成功
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(theNewAlertSucess)
                                                 name:NewAlertSuccessForDIDI
                                               object:nil];
    
    //分享号点击栏目标记已读成功后调用
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(theNewsReading)
                                                 name:ShareNumberColumnMarkAlreadyRead
                                               object:nil];
    
    
    //分享号获取红点推送并缓存最新新闻成功后调用
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(theLatesNews)
                                                 name:LatestNewsSuccessForNEW
                                               object:nil];
    
    //跳转嘀嘀列表
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoDidiList)
                                                 name:GotoDidiListNotification
                                               object:nil];
    
    
    
    //有新版本通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(haveNewVersion)
                                                 name:HaveNewVersionNotification
                                               object:nil];
    
    //监测接收消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRemoteNotification:) name:QYPushHelperDidReceiveRemoteNotification object:nil];
    
}

/** View激将显示时 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //改变TabBar背景图片
    self.tabBar.backgroundImage = [UIImage imageNamed:@"base_TarBar_Bg"];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITabBarControllerDelegate
/**
 *  tabBarController 已经选中某viewController
 */
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    //点击更多时，版本更新红点消失
    if (viewController == _moreVNavigationController){
        self.moreLabelBadgeIconView.hidden = YES;
    }
}
#pragma mark - CustomDelegate
#pragma mark - event response
#pragma mark - private methods
/**
 * 配置ViewControllers
 */
-(void)setupViewControllers{
    //IM
    self.imViewController = [[QYIMListViewController alloc] init];
    self.imViewNavigationController = [[QYNavigationViewController alloc] initWithRootViewController:self.imViewController];
    self.imViewController.imProtocol = self;
    self.imViewNavigationController.navigationBar.translucent = NO;
    UIImage *imTabBarImage = [UIImage imageNamed:@"base_tab_imIcon"];
    UIImage *imTabBarSelectImage = [UIImage imageNamed:@"base_tab_imIconS"];
    self.imViewNavigationController.tabBarItem.image = [imTabBarImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.imViewNavigationController.tabBarItem.selectedImage = imTabBarSelectImage;
    self.imViewController.title = NSLocalizedString(@"tab_imTitle", @"");
    
    //嘀嘀
    self.didiListViewController = [[QYDiDiListViewController alloc] init];
    self.didiListNavigationController = [[QYNavigationViewController alloc] initWithRootViewController:self.didiListViewController];
    self.didiListNavigationController.navigationBar.translucent = NO;
    UIImage *callTabBarImage = [UIImage imageNamed:@"base_tab_didiIcon"];
    UIImage *cellTabBarSelectImage = [UIImage imageNamed:@"base_tab_didiIconS"];
    self.didiListNavigationController.tabBarItem.image = [callTabBarImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.didiListNavigationController.tabBarItem.selectedImage = cellTabBarSelectImage;
    self.didiListViewController.title = NSLocalizedString(@"tab_didiTitle", @"");
    
    //工作
    self.applicationViewController = [[QYApplicationViewController alloc] init];
    self.applicationViewNavigationController = [[QYNavigationViewController alloc] initWithRootViewController:self.applicationViewController];
    _applicationViewNavigationController.navigationBar.translucent = NO;
    UIImage *applicationTabBarImage = [UIImage imageNamed:@"base_tab_workIcon"];
    UIImage *applicationTabBarSelectImage = [UIImage imageNamed:@"base_tab_workIconS"];
    _applicationViewNavigationController.tabBarItem.image = [applicationTabBarImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _applicationViewNavigationController.tabBarItem.selectedImage = applicationTabBarSelectImage;
    self.applicationViewController.title = NSLocalizedString(@"tab_workTitle", @"");
    
    //发现
    self.moreViewController = [[QYMoreViewController alloc] initWithStyle:UITableViewStyleGrouped];
    self.moreVNavigationController = [[QYNavigationViewController alloc] initWithRootViewController:self.moreViewController];
    _moreVNavigationController.navigationBar.translucent = NO;
    UIImage *moreTabBarImage = [UIImage imageNamed:@"base_tab_moreIcon"];
    UIImage *moreTabBarSelectImage = [UIImage imageNamed:@"base_tab_moreIconS"];
    _moreVNavigationController.tabBarItem.image = [moreTabBarImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _moreVNavigationController.tabBarItem.selectedImage = moreTabBarSelectImage;
    self.moreViewController.title = NSLocalizedString(@"tab_moreTitle", @"");
    
    //通讯录 （单位 个人 群组）
    self.ABViewController =
    [[QYABViewController alloc] initWithShowItems:@[@(AddressBookTypeUnits),
                                                    @(AddressBookTypePrivate),
                                                    @(AddressBookTypeGroup)]];
    _ABViewController.delegate = self;
    [QYCallNumberDb createDatabaseTable];
    _ABViewNavigationController.navigationBar.translucent = NO;
    self.ABViewNavigationController = [[QYNavigationViewController alloc] initWithRootViewController:self.ABViewController];
    UIImage *bookIcon = [[UIImage imageNamed:@"base_tab_addressBookIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *bookSelectIcon = [[UIImage imageNamed:@"base_tab_addressBookIconS"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _ABViewNavigationController.tabBarItem.image = [bookIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    _ABViewNavigationController.tabBarItem.selectedImage = bookSelectIcon;
    self.ABViewController.title = NSLocalizedString(@"tab_addressBookTitle", @"");
    
    
    [self setViewControllers:@[_imViewNavigationController,
                               _didiListNavigationController,
                               _applicationViewNavigationController,
                               _ABViewNavigationController,
                               _moreVNavigationController]];
    
    //tabBar前景色
    self.tabBar.tintColor = [UIColor themeTabbarSelectedColor];
    //调整标签颜色
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:[UIColor themeTabbarSelectedColor],                                                                                                              NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    self.selectedIndex = 3;
    
    [self addNotificationBadgeIcon];
}

/**
 *  从任何界面跳转进嘀嘀
 */
-(void)gotoDidiList {
    QYNavigationViewController *navViewController=self.selectedViewController;
    if (navViewController.presentedViewController) {
        [navViewController dismissViewControllerAnimated:NO completion:nil];
    }
    [navViewController popToRootViewControllerAnimated:NO];
    self.selectedViewController=_didiListNavigationController;
    
}

#pragma mark -- 红点绘制及操作
/**
 *  更多红点绘制
 */
- (void)addNotificationBadgeIcon{
    //更多（发现）
    self.moreLabelBadgeIconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    self.moreLabelBadgeIconView.backgroundColor = [UIColor redColor];
    self.moreLabelBadgeIconView.hidden = YES;
    [self.moreLabelBadgeIconView createRoundIconViewDiameter:8 obj:_moreLabelBadgeIconView];
    [self.tabBar addSubview:self.moreLabelBadgeIconView];
    
    //更新位置
    [self updateNotificationBadgeIconPosition];
    //可见度
    [self updateNotificationBadgeVisibility];
}

/**
 *  更新更多红点位置
 */
- (void)updateNotificationBadgeIconPosition{
    CGFloat horizontalOffset = 0.0;
    CGFloat tabBarContentWidth = self.tabBar.frame.size.width - (horizontalOffset * 2);
    CGFloat tabItemWidth = tabBarContentWidth / self.tabBar.items.count;
    //更多（发现）
    CGFloat moreTabCenter = horizontalOffset + ((4 + 0.5) * tabItemWidth);
    CGFloat moreHorizontalPosition = moreTabCenter - (-5);
    CGRect moreRect = self.moreLabelBadgeIconView.frame;
    moreRect.origin.x = ceilf(moreHorizontalPosition);
    moreRect.origin.y = ceilf(8);
    self.moreLabelBadgeIconView.frame = moreRect;
}

/**
 *  红点显示处理
 */
- (void)updateNotificationBadgeVisibility {
    NSInteger DDCount = [[QYRedDotHelper shared] redDotModelWithModuleCode:QYRedDotStorageDidi].redPointNum;
    QYRedDotModel *workRedDotModel = [[QYRedDotHelper shared] redDotModelWithModuleCode:QYRedDotStorageWork];
    if (DDCount > 0){
        if (DDCount >= 100) {
            _didiListNavigationController.tabBarItem.badgeValue = @"...";
        }else{
            _didiListNavigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)DDCount];
        }
    }else{
        _didiListNavigationController.tabBarItem.badgeValue = nil;
    }
    
    //工作
    if (workRedDotModel.redPointNum > 0) {
        if (workRedDotModel.redPointNum >= 100) {
            _applicationViewNavigationController.tabBarItem.badgeValue = @"...";
        }else{
            _applicationViewNavigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)workRedDotModel.redPointNum];
        }
    }else{
        _applicationViewNavigationController.tabBarItem.badgeValue = nil;
    }
}

#pragma mark - QYABProtocol
/**
 *  进入IM
 *
 *  @param userModel 人员实体
 */
- (void)gotoIMWithUserModel:(QYABUserModel *)userModel{
    //新建单聊跳转
    QYIMChatUserModel *chatUserModel = [[QYIMChatUserModel alloc] init];
    chatUserModel.userId = userModel.userId;
    chatUserModel.userName = userModel.userName;
    
    QYIMListViewModel *viewModel = [[QYIMListViewModel alloc] init];
    viewModel.delegate = self;
    [viewModel newChatWithUserArray:@[chatUserModel]];
}

/**
 *  跳转到新增嘀嘀页面
 *
 *  @param userModel 人员实体
 */
- (void)gotoDIDIOnlyOneWithUserModel:(QYABUserModel *)userModel  nav:(UINavigationController *)nav {
    QYDiDiNewRemindViewController *newRemindVC = [[QYDiDiNewRemindViewController alloc] init];
    newRemindVC.userModel = userModel;
    newRemindVC.isPeopleDetails = YES;
    [nav pushViewController:newRemindVC animated:YES];
}

/**
 *  跳转到拨号页面
 *
 *  @param userModel 人员实体
 */
- (void)gotoCallNumViewController{
    QYCallNumberViewController *callNumberViewController = [[QYCallNumberViewController alloc] init];
    callNumberViewController.delegate = self;
    [self.ABViewController.navigationController pushViewController:callNumberViewController animated:YES];
}
#pragma mark - Notification
/**
 *  嘀嘀最新提醒获取成功后调用，收到新提醒推送时也调用
 */
- (void)theNewAlertSucess{
    [[NSNotificationCenter defaultCenter] postNotificationName:IM_ReceiveNewMessageRefreshUI object:nil];
}

/**
 *  分享号点击栏目标记已读成功后调用
 */
- (void)theNewsReading{
    [[NSNotificationCenter defaultCenter] postNotificationName:IM_ReceiveNewMessageRefreshUI object:nil];
}

/**
 *  分享号获取红点推送并缓存最新新闻成功后调用
 */
- (void)theLatesNews{
    [[NSNotificationCenter defaultCenter] postNotificationName:IM_ReceiveNewMessageRefreshUI object:nil];
}

/**
 *  有新版本时的通知
 */
-(void)haveNewVersion{
    //显示红点
    self.moreLabelBadgeIconView.hidden = NO;
}

/**
 *  接收推送消息
 *
 *  @param notification NSNotification对象
 */
-(void)receiveRemoteNotification:(NSNotification *)notification{
   
    //如果defaultAccount为空，说明用户未登录，收到推送不作处理
    if (![[QYAccountService shared] defaultAccount]) {
        return;
    }
    
    QYPushResult *pushResult = [notification object];

    //应用中心模块红点更新
    if (pushResult.extras != nil && [pushResult.extras isKindOfClass:[NSDictionary class]]){
        NSString *modeName = pushResult.extras[@"mt"];
        
        if ([modeName isEqualToString:@"DiDi"]){
            //嘀嘀应用内弹出提示
            NSString *dateStr =[QYTimeTool stringWithDate:[QYTimeTool dateWithString:pushResult.extras[@"t"] format:@"MMddHHmm"] format:@"M月d日 HH:mm"];
            NSString *detail=[NSString stringWithFormat:@"%@ %@",pushResult.extras[@"n"],dateStr];
            UIImage *icon=[UIImage imageNamed:@"notificationView_didi"];
            QYNotificationView *notificationView=[QYNotificationView
                                                  showWithText:pushResult.content
                                                  detail:detail
                                                  image:icon
                                                  duration:6
                                                  tapBlock:^(QYNotificationView *notificationView) {
                                                      [self gotoDidiDetailWithMsgId:[notificationView.extend integerValue]];
                                                  }];
            
            notificationView.extend = pushResult.extras[@"id"];
        }
    }
}


#pragma mark - QYIMListViewModelDelegate
/**
 *  创建单聊成功，跳转到聊天会话
 *
 *  @param chatId 单聊的chatId，对方的userId
 */
- (void)createSingleChatSuccessWithChatId:(NSNumber *)chatId {
    NSArray *vc = self.imViewNavigationController.viewControllers;
    NSMutableArray *viewControllers = [NSMutableArray array];
    if (vc && vc.count > 0){
        [viewControllers addObject:vc[0]];
        //单聊的chatId是对方的userId
        QYIMChatViewController *imChatVC = [[QYIMChatViewController alloc] init];
        imChatVC.chatId = chatId;
        [viewControllers addObject:imChatVC];
        imChatVC.imProtocol=self;
        [self.imViewNavigationController setViewControllers:viewControllers animated:NO];
    }
    self.selectedViewController = _imViewNavigationController;
    [_ABViewController.navigationController popToRootViewControllerAnimated:NO];
}



#pragma mark - QYChatDelegate
/**
 *  IM协议接口函数，根据userId，查出单个人员相关信息
 *
 *  @param userId 人员Id
 *
 *  @return 人员对象
 */
- (QYIMChatUserModel *)userWithUserId:(NSString *)userId{
    QYABUserModel *userModel = [QYABDb userWithUserId:userId];
    if (userModel){
        QYIMChatUserModel *chatUser = [[QYIMChatUserModel alloc] init];
        chatUser.userName = userModel.userName;
        chatUser.userId = userModel.userId;
        chatUser.sex = userModel.sex;
        NSString *urlString1 = [[QYURLHelper shared] getUrlWithModule:@"ydzjMobile" urlKey:@"headPictureView"];
        chatUser.photo = [NSString stringWithFormat:@"%@_clientType=wap&filePath=%@",urlString1,userModel.photo];
        
        return chatUser;
    }else{
        return nil;
    }
}

/**
 *  根据userId集合得到QYChatUser数组
 *
 *  @param userIds 用户id集合，以逗号分开
 *
 *  @return User集合
 */
- (NSMutableArray *)usersWithUserIds:(NSString*)userIds{
    NSMutableArray *chatUserArray = [QYABDb usersWithUserIds:userIds];
    NSMutableArray *muArray = [[NSMutableArray alloc]init];
    
    [chatUserArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        QYABUserModel *userModel = obj;
        
        QYIMChatUserModel *chatUser = [[QYIMChatUserModel alloc] init];
        chatUser.userName = userModel.userName;
        chatUser.userId = userModel.userId;
        chatUser.sex = userModel.sex;
        NSString *urlString1 = [[QYURLHelper shared] getUrlWithModule:@"ydzjMobile" urlKey:@"headPictureView"];
        chatUser.photo = [NSString stringWithFormat:@"%@_clientType=wap&filePath=%@",urlString1,userModel.photo];
        
        [muArray addObject:chatUser];
    }];
    
    return muArray;
}

/**
 *  将要选择人员
 *
 *  @param presentViewController presentViewController 选择人员需要弹出在这个控制器上
 *  @param alreadySelectUsers    userArray 选择的人员QYChatUser
 *  @param userBlock
 */
- (void)shouldPresentViewController:(id)presentViewController
                  alreadySelectUser:(NSArray *)alreadySelectUsers
                         selectUser:(void (^)(NSArray *userArray))userBlock{
    
}

/**
 *  进入企业内刊、分享号、新闻中心
 */
- (void)goToNew {
    QYNewsListViewController *newsListVC = [[QYNewsListViewController alloc] init];
    [_imViewNavigationController pushViewController:newsListVC animated:YES];
}

/**
 *  根据模块类型返回模块信息(分享号专用)
 *
 *  @param moduleType 模块类型
 *  @param moduleInfo 模块信息
 */
- (void)moduleInfoWithModuleTypeIsNEWS:(NSString *)moduleType moduleInfo:(void (^)(NSDictionary *))moduleInfo
{
    if ([moduleType isEqualToString:NEWS])
    {
        //从最后一条数据保存中获取
        NSDictionary *moduleDic = [[QYNewsNotificationMonitor shared] getDataForNewRemind];
        if (moduleDic)
        {
            moduleInfo(moduleDic);
        }
        else
        {
            NSDictionary *moduleDicDefault = @{@"name":@"企业内刊",
                                               @"image":@"chat_share",
                                               @"content":@"",
                                               @"sendTime":@"",
                                               };
            moduleInfo(moduleDicDefault);
        }
    }
}

#pragma mark - 跳转
/**
 *  进入嘀嘀详情
 *
 *  @param msgId 嘀嘀消息id
 */
-(void)gotoDidiDetailWithMsgId:(NSInteger)msgId{
    QYNavigationViewController *navigationViewController=(QYNavigationViewController*)self.selectedViewController;
    self.selectedViewController=_didiListNavigationController;
    QYDiDiReplyDetailViewController *detailViewController=[[QYDiDiReplyDetailViewController alloc] init];
    [detailViewController configDetailWithMsgId:msgId];
    [navigationViewController popToRootViewControllerAnimated:NO];
    
    [_didiListNavigationController pushViewController:detailViewController animated:YES];

}
/**
 *  IM跳转到嘀嘀新建
 *
 *  @return userModel 人员实体
 */
- (void)gotoDIDIFromIMWithUserModel:(QYABUserModel *)userModel{
    QYDiDiNewRemindViewController *newRemindVC = [[QYDiDiNewRemindViewController alloc] init];
    newRemindVC.userModel = userModel;
    newRemindVC.isPeopleDetails = YES;
    [self.imViewController.navigationController pushViewController:newRemindVC animated:YES];
}


@end
