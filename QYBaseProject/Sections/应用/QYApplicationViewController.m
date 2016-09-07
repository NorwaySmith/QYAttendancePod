//
//  QYApplicationViewController.m
//  QYBaseProject
//
//  Created by dzq on 15/7/30.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYApplicationViewController.h"
#import "QYApplicationCell.h"
#import "QYApplicationViewModel.h"
#import "QYApplicationModel.h"
#import "QYOldAlertView.h"
#import <Meeting/QYMeetingListViewController.h>
#import <QYMovingPunchTheClock/QYNewPunchTheClockViewController.h>
#import <QYCommonNumber/QYCommonPhoneViewController.h>
#import <NoticeMsgCBB/QYVoiceNotification.h>

#import <NoticeMsgCBB/QYTZListViewController.h>

#import <NoticeCBB/QYNoticeListViewController.h>

#import "QYURLHelper.h"
#import "QYAccountService.h"
#import "QYTabBarController.h"
#import "QYNavigationViewController.h"
#import "AppDelegate.h"

#import "QYArtificialTransferringViewController.h"
#import "QYH5ViewController.h"              //html5
#import "QYURLHelper.h"

//V网
//#import "QYVWangInitializationViewController.h"
//#import "QYVWangSpeedDialingViewController.h"
#import <VNetSpeedCall/QYVWangInitializationViewController.h>
#import <VNetSpeedCall/QYVWangSpeedDialingViewController.h>

//红点
#import "QYRedDotHelper.h"
#import <QYAddressBook/QYAddressHeader.h>


//#import "QYABDb.h"
//#import "QYABSelectViewController.h"


#import <QYDIDIReminCBB/QYDiDiListViewController.h>
#import <QYDIDIReminCBB/QYDiDiNewRemindViewController.h>

#import "MobClick.h"
#import "IOSTool.h"
#import "Html5PlusLogViewController.h"
#import "Html5PlusWorkflowViewController.h"
#import "Html5PlusCrmViewController.h"
#import "QYAttendanceListViewController.h"

//日程
#import "Html5PlusScheduleViewController.h"
#import "Html5PlusTaskViewController.h"

#define SECTION_ITEM_SIZE0  ([UIScreen mainScreen].bounds.size.width - 3*1 - 1)/4.0

#define SECTION_ITEM_SIZE1  [UIScreen mainScreen].bounds.size.width == 414 ? ([UIScreen mainScreen].bounds.size.width - 3*0.5)/4.0:([UIScreen mainScreen].bounds.size.width - 3*1)/4.0



#define LOGO_IMAGEVIEW_HEIGHT [UIScreen mainScreen].bounds.size.width * (185.0/320.0)

#define NavigationBarHight 64.0f    //导航bar高度

@interface QYApplicationViewController()<UICollectionViewDataSource,UICollectionViewDelegate,QYApplicationCellDelegate,UITableViewDelegate,UITableViewDataSource>

//是否显示红点
//@property (nonatomic) BOOL isShowBadge;

@property (nonatomic,strong) QYApplicationViewModel *viewModel;

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UITableView *bgScrollView;

@property (nonatomic,strong) UIImageView *headerView;


@end

@implementation QYApplicationViewController

static NSString *const reuseIdentifier = @"Cell";

#pragma mark - life cycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (id)init
{
    self = [super init];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        [self initializeViewModel];
        
        //标题样式
        NSDictionary *navbarTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor whiteColor],NSForegroundColorAttributeName,
                                                   [UIFont themeBoldNavTitleFont],NSFontAttributeName,nil];
        [[UINavigationBar appearance] setTitleTextAttributes:navbarTitleTextAttributes];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"工作"];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage themeNavBg] forBarMetrics:UIBarMetricsDefault];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"工作"];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_collectionView reloadData];
}

/**
 *  初始化viewModel，监测viewModel数据变化，更新UI
 */
- (void)initializeViewModel {
    _viewModel = [[QYApplicationViewModel alloc] init];     //创建数据对象
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showBadge:) name:kQYRedDotChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moduleChange:) name:@"moduleChange" object:nil];

    
    [self initializeViewModel];
    [self createScrollView];
    
    [self createCollectionView];
}

- (void)createScrollView
{
    self.bgScrollView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.bgScrollView.backgroundColor = [UIColor clearColor];
    self.bgScrollView.delegate = self;
    self.bgScrollView.dataSource = self;
    //设置contentInset属性（上左下右 的值）
    self.bgScrollView.contentInset = UIEdgeInsetsMake(LOGO_IMAGEVIEW_HEIGHT, 0, 0, 0);
    self.bgScrollView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.bgScrollView];
    
}

- (void)createCollectionView
{
    _headerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -LOGO_IMAGEVIEW_HEIGHT, [UIScreen mainScreen].bounds.size.width, LOGO_IMAGEVIEW_HEIGHT)];
    _headerView.image = [UIImage imageNamed:@"work_Logo"];
    _headerView.contentMode = UIViewContentModeScaleAspectFill;  //重点（不设置将只会被纵向拉伸）
    _headerView.autoresizesSubviews = YES;
    [_bgScrollView addSubview:_headerView];
    
    float itemSize;
    if ([UIScreen mainScreen].bounds.size.width == 320) {
        itemSize = SECTION_ITEM_SIZE0;
    }
    else {
        itemSize = SECTION_ITEM_SIZE1;
    }
    
    float height;
    long row;
    float lineheight;
    if ([_viewModel.modelArray count]%4 == 0)
    {
        row = [_viewModel.modelArray count]/4;
        height = row * (itemSize *1.13);
    }
    else
    {
        row = [_viewModel.modelArray count]/4 + 1;
        height = row * (itemSize * 1.13);
        lineheight = ([UIScreen mainScreen].bounds.size.width == 414 ? (row - 1) : row) * 0.5;
    }
    
    float collectionViewHeight = ceilf(height) + lineheight;
    
    UICollectionViewFlowLayout *CVlayout = [[UICollectionViewFlowLayout alloc] init];
    
    CVlayout.minimumLineSpacing = [UIScreen mainScreen].bounds.size.width != 414 ? 1.0: 0.5;              //V: item 间隙
    CVlayout.minimumInteritemSpacing = [UIScreen mainScreen].bounds.size.width != 414 ? 1.0: 0.5;         //H: item 间隙
    CVlayout.itemSize = CGSizeMake(itemSize, itemSize * 1.13);
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width == 320 ?0.5 :0.0, 0, [UIScreen mainScreen].bounds.size.width == 320 ? ([UIScreen mainScreen].bounds.size.width - 1) : [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width == 320 ? collectionViewHeight + 1.5 :collectionViewHeight) collectionViewLayout:CVlayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor themeSeparatorLineColor];
    [_bgScrollView addSubview:_collectionView];
    
    [self.collectionView registerClass:[QYApplicationCell class] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundView = [UIView new];
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_viewModel.modelArray count] % 4 == 0)
    {
        return [_viewModel.modelArray count];
    }
    
    //解决空cell 点击问题
    if ([_viewModel.modelArray count]%4 != 0)
    {
        int count = 4 - [_viewModel.modelArray count]%4;
        for (int i = 0; i < count; i++)
        {
            QYApplicationModel *didiModel = [[QYApplicationModel alloc] init];
            [_viewModel.modelArray addObject:didiModel];
        }
    }
    
    return [_viewModel.modelArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QYApplicationCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.delegae = self;
    
    QYApplicationModel *model = _viewModel.modelArray[indexPath.item];
    cell.itemIndex = indexPath.row;
    cell.modelCount = _viewModel.modelArray.count;
    cell.applicationModel = model;
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

//选择
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [self clickEvent:indexPath.row];
}

//取消选择
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//点中时，持续状态
- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    QYApplicationModel *model = _viewModel.modelArray[indexPath.item];
    QYApplicationCell *cell = (QYApplicationCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([model.title isNotNil]){
        cell.backgroundColor = [UIColor colorWithRed:236.0/255 green:236.0/255 blue:236.0/255 alpha:1.0];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
}


- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    QYApplicationCell *cell = (QYApplicationCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat y = scrollView.contentOffset.y; //根据实际选择加不加上NavigationBarHight（44、64 或者没有导航条）
    if (y < -LOGO_IMAGEVIEW_HEIGHT)
    {
        CGRect frame = _headerView.frame;
        frame.origin.y = y;
        frame.size.height =  -y;            //contentMode = UIViewContentModeScaleAspectFill时，高度改变宽度也跟着改变
        _headerView.frame = frame;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 43.0;
}

#pragma mark - CustomDelegate

#pragma mark - event response
/**
 *  红点获取成功后调用
 */
- (void)showBadge:(NSNotification *)notification {
    [self initializeViewModel];
    
    [self.collectionView reloadData];
}
/**
 *  @author 杨峰, 16-04-13 10:04:28
 *
 *  模块变化时
 */
- (void)moduleChange:(NSNotification *)notification {
    [self initializeViewModel];
    
    [_headerView removeFromSuperview];
    [_collectionView removeFromSuperview];
    [self createCollectionView];
    [self.collectionView reloadData];
}


#pragma mark ---- QYApplicationCellDelegate
- (void)collectionViewCellAction:(long)cellIndex
{
    [self clickEvent:cellIndex];
}

//点击 item 触发的方法
- (void)clickEvent:(long)index
{
    if (index >= [_viewModel.modelArray count]) {
        return;
    }
    
    QYApplicationModel *model = _viewModel.modelArray[index];
    
    if ([model.title isEqualToString:kLgz_app_notice]) {
        //公告
        QYNoticeListViewController *noticeListVC = [[QYNoticeListViewController alloc] init];
        [self.navigationController pushViewController:noticeListVC animated:YES];
    }
    else if ([model.title isEqualToString:kLgz_app_punchCard]) {
        //移动打卡
        //        QYNewPunchTheClockViewController *punchViewController = [[QYNewPunchTheClockViewController alloc]init];
        QYAttendanceListViewController *punchViewController = [[QYAttendanceListViewController alloc]init];
                punchViewController.title = kLgz_app_punchCard;
        [self.navigationController pushViewController:punchViewController animated:YES];
    }
    else if ([model.title isEqualToString:kLgz_app_log]) {
        //日志
        Html5PlusLogViewController *vc = [[Html5PlusLogViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([model.title isEqualToString:kLgz_app_approve]) {
        //审批
        Html5PlusWorkflowViewController *vc = [[Html5PlusWorkflowViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        //NSLog(@"0");
    }
    else if ([model.title isEqualToString:@"日程"]) {
        //日程
        Html5PlusScheduleViewController *vc = [[Html5PlusScheduleViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        //NSLog(@"0");
    }
    else if ([model.title isEqualToString:@"任务"]) {
        //任务
        Html5PlusTaskViewController *vc = [[Html5PlusTaskViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        //NSLog(@"0");
    }

    else if ([model.title isEqualToString:kLgz_app_surveyQuestion]) {
        //问卷
        QYAccount *account = [[QYAccountService shared] defaultAccount];
        
        NSString *webURL = [[QYURLHelper shared] getUrlWithModule:@"question" urlKey:@"question"];
        
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@userId=%@&companyId=%@&_clientType=wap",webURL,account.userId,account.companyId]];
        
        QYH5ViewController *h5ViewController = [[QYH5ViewController alloc] initWithUrl:url];
        
        [self.navigationController pushViewController:h5ViewController animated:YES];
    }
    else if ([model.title isEqualToString:kLgz_app_onLineLessono]) {
        //在线课堂
        QYAccount *account = [[QYAccountService shared] defaultAccount];
        NSString *webURL = [[QYURLHelper shared] getUrlWithModule:@"onlineExam" urlKey:@"onlineExam"];
        NSURL *url=[NSURL URLWithString:[NSString stringWithFormat:@"%@userId=%@&companyId=%@&_clientType=wap",webURL,account.userId,account.companyId]];
        QYH5ViewController *h5ViewController=[[QYH5ViewController alloc] initWithUrl:url];
        h5ViewController.navigationItem.title = kLgz_app_onLineLessono;
        
        [self.navigationController pushViewController:h5ViewController animated:YES];
    }
    else if ([model.title isEqualToString:kLgz_app_voice]) {
        //语音通知
        QYTZListViewController *listVC = [[QYTZListViewController alloc] init];
        listVC.notificationType = YYTZNotificationVoice;
        [self.navigationController pushViewController:listVC animated:YES];
        
    }
    else if ([model.title isEqualToString:kLgz_app_meetting]) {
        //电话会议
        QYMeetingListViewController *meetingListViewController = [[QYMeetingListViewController alloc] init];
        [self.navigationController pushViewController:meetingListViewController animated:YES];
    }
    else if ([model.title isEqualToString:kLgz_app_commonPhone]) {
        //常用号码
        QYCommonPhoneViewController *vc = [[QYCommonPhoneViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([model.title isEqualToString:kLgz_app_crm]) {
        //CRM
        Html5PlusCrmViewController *crmVC = [[Html5PlusCrmViewController alloc] init];
        [self.navigationController pushViewController:crmVC animated:YES];
    }
    
    //    else if (index == 10)
    //    {
    //        //v网
    //        QYAccount *account = [[QYAccountService shared] defaultAccount];
    //        if ([account.vnum isEqualToString:@"(null)"] || [account.vnum isEqualToString:@""] || account.vnum == nil)
    //        {
    //            QYVWangInitializationViewController *VWangInitializationVC = [[QYVWangInitializationViewController alloc] init];
    //            VWangInitializationVC.hidesBottomBarWhenPushed = YES;
    //            [self.navigationController pushViewController:VWangInitializationVC animated:YES];
    //            return;
    //        }
    //        QYVWangSpeedDialingViewController *vWangViewController = [[QYVWangSpeedDialingViewController alloc]init];
    //        [self.navigationController pushViewController:vWangViewController animated:YES];
    //    }
}




#pragma mark - private methods
#pragma mark - getters and setters





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark --IM实现



#pragma mark QYNewWebDelegate

//调查问卷 选择人员
- (void)shouldPresentNewWepViewController:(id)presentViewController  didSelectedAddressBook:(NSArray *)selectedArray  type:(NSArray *)typeArray  isRadio:(BOOL)isRadio permissionDic:(NSDictionary *)perDic selectUser:(void (^)(NSArray *userArray))userBlock
{
    //        通讯录集成修改
    /*
     QYABSelectViewController *selectViewController=[[QYABSelectViewController alloc] initWithSelectType:QYABSelectTypeMultiple showItems:@[@(AddressBookTypeUnits),
     @(AddressBookTypeGroup)] isShowHiddenPerson:YES];
     [selectViewController setSelectUsers:selectedArray];
     QYNavigationViewController *selectNav=[[QYNavigationViewController alloc] initWithRootViewController:selectViewController];
     [presentViewController presentViewController:selectNav animated:YES completion:nil];
     
     __weak QYNavigationViewController *wSelectNav=selectNav;
     [selectViewController setSelectCompleteBlock:^(NSArray *userArray)
     {
     
     userBlock(userArray);
     [wSelectNav dismissViewControllerAnimated:YES completion:nil];
     }
     selectCancel:^
     {
     [wSelectNav dismissViewControllerAnimated:YES completion:nil];
     }];
     */
    
}

/*
 *@brief 调查问卷通过人员id获取人员信息
 */
-(NSMutableArray *)findPersonMessageById:(NSArray *)userId selectUser:(void (^)(NSArray *userArray))userMessageBlock
{
    NSMutableArray *userArray = [QYABDb usersWithUserIds:[userId componentsJoinedByString:@","]];
    userMessageBlock(userArray);
    
    return nil;
}

@end
