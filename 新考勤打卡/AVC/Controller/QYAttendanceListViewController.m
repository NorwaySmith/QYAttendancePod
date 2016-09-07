//
//  QYAttendanceViewController.m
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/6.
//  Copyright © 2016年 田. All rights reserved.
//

#import "QYAttendanceListViewController.h"

#import "QYAttendanceListHeaderView.h"

#import "QYAttendanceListTableView.h"

#import "QYDeviceInfo.h"

#import "QYAttendanceApi.h"
//详情
#import "QYAttendanceDetailViewController.h"

#import "QYDialogTool.h"

#import "QYAttendanceListModel.h"

//#import <CoreLocation/CoreLocation.h>

#import "QYAccount.h"

#import "QYAccountService.h"

//空数据页面
#import "QYAttendanceListNoDataView.h"

#import "QYOldAlertView.h"

#import "QYAccountService.h"

#import "QYAccount.h"

//查看备注详情
#import "YLPopViewController.h"

//打卡完成界面
#import "QYNewPopViewController.h"
//headerView 高度
#import "MBProgressHUD.h"

#import "QYNoNetworkView.h"
#import "QYDevicePermission.h"

#define popWidth (float)[QYDeviceInfo screenWidth]/320*237
#define popHeight (float)[QYDeviceInfo screenWidth]/320*250

@interface QYAttendanceListViewController()<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UIAlertViewDelegate,UIAlertViewDelegate,BMKPoiSearchDelegate>

@property (nonatomic, strong)BMKLocationService *locationService;
//反地理编码
@property (nonatomic, strong) BMKGeoCodeSearch             *geoCodeSearch;


//头部视图
@property (nonatomic, strong)QYAttendanceListHeaderView *listHeader;

//列表
@property (nonatomic, strong)QYAttendanceListTableView *listTable;

//列表空数据
@property (nonatomic, strong)QYAttendanceListNoDataView *attendanceNoData;

//网络获取数据
@property (nonatomic, strong)NSDictionary *resultDictionary;

//当前人维度
@property (nonatomic ,assign)CLLocationDegrees personLatitude;

//当前人经度
@property (nonatomic ,assign)CLLocationDegrees personlongitude;

//打卡维度
@property (nonatomic ,assign)CLLocationDegrees decidedLatitude;

//打卡经度
@property (nonatomic ,assign)CLLocationDegrees decidedlongitude;

//打卡半径
@property (nonatomic, assign)int radiusMeter;

@property (nonatomic, assign)CLLocationDistance meters;

//考勤区还是外勤区
@property (nonatomic, strong)NSString *outOfRange;

@property (nonatomic, strong)MBProgressHUD *hud;
//是否需要弹出弹窗
@property(nonatomic,assign)BOOL isNeedPop;

@property(nonatomic,copy)NSString *typeString;

//用户打卡时的状态
@property(nonatomic,assign)QYSignType signType;

@property (nonatomic, assign)QYReverseGeoCodeType ReverseGeoCodeType;

//周边检索
@property (nonatomic, strong)BMKPoiSearch *poisearch;

@end

@implementation QYAttendanceListViewController

#pragma mark - life cycle
- (instancetype)init{
    if (self = [super init]){
        self.hidesBottomBarWhenPushed=YES;
        
        [self setupLocationManager];
        
        _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];

    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    _locationService.delegate=self;
    _geoCodeSearch.delegate=self;

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"QYAttendance_list_nav"] forBarMetrics:UIBarMetricsDefault];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    _locationService.delegate=nil;
    _locationService=nil;
    _geoCodeSearch.delegate=nil;
    _geoCodeSearch=nil;
    _poisearch.delegate=nil;
    _poisearch=nil;
    [super viewWillDisappear:animated];
 

}
- (void)viewDidLoad{
    
    [super viewDidLoad];
    [self setTitle:@"考勤打卡"];
    self.view.backgroundColor=[UIColor cImSeetingBackgroundColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"refrshDataAndLocationWhenSettingChanged" object:nil];
    
    [self configureMainView];
    
    [self addNotDataView];
    
    [self configBarButtonItem];
    
    //绑定设备逻辑(已经登录过自己的账号，并且使用过打卡功能，本地存一个NSUserdefault字段与本人的手机号绑定，每次到打卡列表校验手机号，如果提别人登录就不能再帮忙打卡了，黎新建的逻辑)
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    NSString *phone = [NSString stringWithFormat:@"%@",account.phone];
    if ([userDefault objectForKey:@"bundingPhoneNumber"]) {
        if ([phone isEqualToString:[userDefault objectForKey:@"bundingPhoneNumber"]]) {
            //当前登录人是该手机绑定的用户
            [self reloadData];
        }else{
            //这人想要替别人打卡，弹窗
            UIAlertView *alert =  [[UIAlertView alloc] initWithTitle:nil message:@"当前账号与已绑定的手机不符，无法进行打卡。如果更换了手机，请联系单位管理员" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alert.tag=104;
            [alert show];
        }
    }else{
        //首次进入该模块，未绑定登录人
        [userDefault setObject:phone forKey:@"bundingPhoneNumber"];
        [self reloadData];
    }
}
-(void)dealloc{
    //释放定时器
    [_listHeader.circularProgress pauseTimer];
    
    //停止定位服务
    [self.locationService stopUserLocationService];
}

#pragma mark - UI

- (void)configBarButtonItem{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = [UIFont themeRightButtonFont];
    [rightButton setTitle:@"查看" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(gotoDtail) forControlEvents:UIControlEventTouchUpInside];
    
    rightButton.frame = CGRectMake(0, 0, 50, 44);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    UIBarButtonItem *operationBar = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width=-10;
    //    QYAccount *account = [[QYAccountService shared] defaultAccount];
    //    if ([[NSString stringWithFormat:@"%@",account.userId] isEqualToString:[NSString stringWithFormat:@"%@",account.adminId]]) {
    //        //管理员
    //    self.navigationItem.rightBarButtonItems = @[spaceItem,operationBar,manageButtonOperationBar];
    self.navigationItem.rightBarButtonItems = @[spaceItem,operationBar];
    
    //    }else{
    //        self.navigationItem.rightBarButtonItem = operationBar;
    //    }
}

-(void)configureMainView{
    __weak QYAttendanceListViewController *bSelf = self;
    _listHeader = [[QYAttendanceListHeaderView alloc] initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth], (float)[QYDeviceInfo screenWidth]/320*240-64)];
    _listHeader.buttonClick=^(QYUSerSignState *type){
        if (type==QYUSerSignStateSignIn) {
            switch ([bSelf.resultDictionary[@"signIn"] intValue]) {
                case 0:
                    break;
                case 1:
                    [bSelf gotoJudgeSignIn:QYUSerSignStateSignIn];
                    break;
                case 2:
                    break;
                    
                default:
                    break;
            }
        }else if (type==QYUSerSignStateSignOut){
            switch ([bSelf.resultDictionary[@"signOut"] intValue]) {
                case 0:
                    break;
                case 1:
                    [bSelf gotoJudgeSignIn:QYUSerSignStateSignOut];
                    break;
                case 2:
                    break;
                    
                default:
                    break;
            }
            
        }
    };
    [self.view addSubview:_listHeader];
    
    _listTable = [[QYAttendanceListTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_listHeader.frame),[QYDeviceInfo screenWidth], [QYDeviceInfo screenHeight]- (float)[QYDeviceInfo screenWidth]/320*240+64)];
    _listTable.cellDetail=^(NSString *memo,NSString *pushCardTime, NSString *location){
        
        YLPopViewController *popView = [[YLPopViewController alloc] init];
        popView.contentViewSize = CGSizeMake(popWidth, popHeight);
        popView.Title = @"打卡备注";
        popView.placeHolder = @"";
        popView.textViewText=memo;
        popView.timeString=pushCardTime;
        popView.location=location;
        popView.wordCount = 50;//不设置则没有
        [popView addContentView];//最后调用
    };
    _listTable.refreshNewAttention=^(NSString *attType){
        NSString *alertMessage;
        if ([attType isEqualToString:@"10"]) {
            alertMessage =@"确定要重新进行上班打卡吗？";
        }else if ([attType isEqualToString:@"21"]){
            alertMessage =@"确定要重新进行下班打卡吗？";
        }else{
            alertMessage =@"确定要重新进行重新打卡吗？";
        }
        QYOldAlertView *alert = [[QYOldAlertView alloc] initWithTitle:nil message:alertMessage delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        alert.didSelectIndex=^(int index){
            if (index==1) {
                if (bSelf.meters <= bSelf.radiusMeter) {
                    //在打卡范围内
                    [bSelf signOutLogictypeString:attType :bSelf isInner:YES];
                }else{
                    //外勤
                    [bSelf signOutLogictypeString:attType :bSelf isInner:NO];
                }
                
            }
        };
    };
    [self.view addSubview:_listTable];
}
- (void) setupLocationManager {
    __weak QYAttendanceListViewController *bSelf = self;
    [[QYDevicePermission shared] systemLocationServiceCallBack:^(BOOL granted) {
        if (granted) {
            bSelf.locationService=[[BMKLocationService alloc]init];
            
            //定位频率,每隔多少米定位一次
            CLLocationDistance distance=10;//十米定位一次
            
            bSelf.locationService.distanceFilter=distance;
            //设置代理
//            bSelf.locationService.delegate=bSelf;
            //设置定位精度
            
            //启动跟踪定位
            [bSelf.locationService startUserLocationService];
        }else{
            UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:LocationServiceAlertTitle message:LocationServiceAlertMessage delegate:bSelf cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            alertView.tag=104;
            [alertView show];
        }
    }];
    
}
/**
 *  添加或删除无数据
 */
- (void)addNotDataView {
    // 初始化无数据视图
    self.attendanceNoData = [[QYAttendanceListNoDataView alloc]
                             initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth],
                                                      self.listTable.frame.size.height)];
    self.attendanceNoData.hidden = YES;
    self.attendanceNoData.type=QYAttedanceListDataTypeNotSetTheProgram;
    [self.listTable addSubview:self.attendanceNoData];
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
    __weak QYAttendanceListViewController *bSelf=self;
    NSArray *poiListArray =[[NSArray alloc] initWithArray:result.poiList];
    if (poiListArray.count<=0) {
        return;
    }
    BMKPoiInfo *poiInfo = poiListArray[0];
    
    if (bSelf.ReverseGeoCodeType==QYReverseGeoCodeTypeHeader) {
        if (bSelf.meters <= bSelf.radiusMeter) {
            bSelf.outOfRange = @"0";
            [bSelf.listHeader localMessageChangedCanLocation:YES location:poiInfo.name];
        }else{
            bSelf.outOfRange = @"1";
            [bSelf.listHeader localMessageChangedCanLocation:NO location:poiInfo.name];
        }
        
    }else if (bSelf.ReverseGeoCodeType==QYReverseGeoCodeTypePopView){
        dispatch_async(dispatch_get_main_queue(), ^{
            [bSelf.hud hide:YES];
            if (bSelf.isNeedPop) {
                NSString *popViewTitle;
                switch (bSelf.signType) {
                    case 0:
                        popViewTitle=@"外勤备注";
                        break;
                    case 1:
                        popViewTitle=@"迟到备注";
                        break;
                    case 2:
                        popViewTitle=@"早退备注";
                        break;
                        
                    default:
                        break;
                }
                YLPopViewController *popView = [[YLPopViewController alloc] init];
                popView.contentViewSize = CGSizeMake(popWidth, popHeight);
                popView.Title = popViewTitle;
                popView.placeHolder = @"请填写打卡备注 (选填)";
                popView.location=result.address;
                popView.wordCount = 50;//不设置则没有
                [popView addContentView];//最后调用
                popView.confirmBlock = ^(NSString *text) {
                    
                    [bSelf sendToAPiWithPosition:result.address  attType:bSelf.typeString memo:text];
                };
            }else{
                [bSelf sendToAPiWithPosition:result.address attType:bSelf.typeString memo:@""];
                
            }
        });
    }
}

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
//    if (poiResult) {
//        NSArray *poiListArray =[[NSArray alloc] initWithArray:poiResult.poiInfoList];
//        if (poiListArray.count<=0) {
//            return;
//        }
//        BMKPoiInfo *poiInfo = poiListArray[0];
//        
//        if (_ReverseGeoCodeType==QYReverseGeoCodeTypeHeader) {
//            if (_meters <= _radiusMeter) {
//                _outOfRange = @"0";
////                [_listHeader localMessageChangedCanLocation:YES location:poiInfo.name];
//            }else{
//                _outOfRange = @"1";
//                [_listHeader localMessageChangedCanLocation:NO location:poiInfo.name];
//            }
//            
//        }else if (_ReverseGeoCodeType==QYReverseGeoCodeTypePopView){
//            __weak QYAttendanceListViewController *bSelf=self;
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_hud hide:YES];
//                if (_isNeedPop) {
//                    NSString *popViewTitle;
//                    switch (_signType) {
//                        case 0:
//                            popViewTitle=@"外勤备注";
//                            break;
//                        case 1:
//                            popViewTitle=@"迟到备注";
//                            break;
//                        case 2:
//                            popViewTitle=@"早退备注";
//                            break;
//                            
//                        default:
//                            break;
//                    }
//                    
//                    YLPopViewController *popView = [[YLPopViewController alloc] init];
//                    popView.contentViewSize = CGSizeMake(popWidth, popHeight);
//                    popView.Title = popViewTitle;
//                    popView.placeHolder = @"请填写打卡备注 (选填)";
//                    popView.location=poiInfo.name;
//                    popView.wordCount = 50;//不设置则没有
//                    [popView addContentView];//最后调用
//                    popView.confirmBlock = ^(NSString *text) {
//                        
//                        [bSelf sendToAPiWithPosition:poiInfo.name  attType:bSelf.typeString memo:text];
//                    };
//                }else{
//                    [bSelf sendToAPiWithPosition:poiInfo.name attType:bSelf.typeString memo:@""];
//                    
//                }
//            });
//        }
//    }
}

#pragma mark - CLLocationManagerDelegate
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    _personLocation=userLocation.location;
    _personLatitude=userLocation.location.coordinate.latitude;
    _personlongitude=userLocation.location.coordinate.longitude;
    [self judgeLocationWithSystermLatitude:_decidedLatitude longitude:_decidedlongitude andNowlatitude:_personLocation.coordinate.latitude nowlongitude:_personLocation.coordinate.longitude];
}

#pragma mark UIAletViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==104) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if (alertView.tag==105){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - private methods
/**
 *  计算当前经纬度与设定经纬度距离
 *
 *  @param latitude     设定维度F
 *  @param longitude    设定经度
 *  @param nowlatitude  当前维度
 *  @param nowlongitude 当前经度
 */
-(void)judgeLocationWithSystermLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude andNowlatitude:(CLLocationDegrees)nowlatitude nowlongitude:(CLLocationDegrees)nowlongitude{
    
    if (latitude&&longitude&&nowlatitude&&nowlongitude) {
        //NSLog(@"\n位置已获取：经度：%f  维度：%f  \n打卡位置： 经度：%f   维度：%f",nowlongitude,nowlongitude,latitude,longitude);
    }
    //第一个坐标
    CLLocation *current=[[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    //第二个坐标
    CLLocation *before=[[CLLocation alloc] initWithLatitude:nowlatitude longitude:nowlongitude];
    //    // 计算距离
    _meters=[current distanceFromLocation:before];
    _ReverseGeoCodeType = QYReverseGeoCodeTypeHeader;
    if (!_geoCodeSearch) {
        _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
//        [_geoCodeSearch setDelegate:self];
    }
    [self citySearch];
}

/**
 *  签到签退执行逻辑
 *
 *  @param newLocation 点击时位置
 *  @param state        打卡类型  10上午上班签到   11下午上班签到   20上午下班签退 21下午下班签退
 */
-(void)gotoJudgeSignIn:(QYUSerSignState)state{
    
    NSString *typeString;
    NSString *alertMessage;
    
    switch (state) {
        case 0:
            typeString=@"10";
            alertMessage=@"你当前不在考勤范围内，是否进行外勤签到？";
            break;
        case 1:
            typeString=@"21";
            alertMessage=@"你当前不在考勤范围内，是否进行外勤签退？";
            break;
            
        default:
            break;
    }
    __weak QYAttendanceListViewController *bSelf = self;
    
    if (_meters <= _radiusMeter) {
        //在打卡范围内
        [self signOutLogictypeString:typeString :bSelf isInner:YES];
    }else{
        //外勤
        QYOldAlertView *alert = [[QYOldAlertView alloc] initWithTitle:@"提示" message:alertMessage delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        alert.didSelectIndex=^(int index){
            if (index==1) {
                //外勤不提醒迟到或者
                [bSelf signOutLogictypeString:typeString :bSelf isInner:NO];
            }
        };
    }
}

/**
 *  <#Description#>
 *
 *  @param state      签到签退 （外勤＋迟到／早退，优先提示外勤，其余不提示    备注也是，优先显示外勤，外勤的时候其余不显示）
 *  @param typeString 10 21
 *  @param bself
 *  @param isInner    外勤 还是内勤
 */
-(void)signOutLogictypeString:(NSString *)typeString :(QYAttendanceListViewController *)bself isInner:(BOOL)isInner{
    //下午签退
    if ([typeString isEqualToString:@"21"]) {
        //获取当前时间
        NSDictionary *dataDictionary = [QYAttendanceListModel getDayWeek];
        //获取下午签退时间
        NSString *anotherDay =[NSString stringWithFormat:@"%@",bself.resultDictionary[@"offTime"]];
        
        if (isInner) {
            BOOL signTime;
            //                时间校验对比
            if ([anotherDay isNotNil]) {
                signTime = [QYAttendanceListModel compareAndDecidedWhichFirstOneDay:dataDictionary[@"time"] withAnotherDay:anotherDay];
            }else{
                signTime=NO;
            }
            
            if (signTime) {
                //（内勤）在签退时间前签退，提示早退
                QYOldAlertView *alertNew =[[QYOldAlertView alloc] initWithTitle:@"提示" message:@"当前时间签退属于早退，确定要进行签退吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [alertNew show];
                
                alertNew.didSelectIndex=^(int newIndex){
                    if (newIndex==1) {
                        [bself signFunctiontypeString:typeString isNeedPop:YES signType:QYSignTypeEarly];
                    }
                };
            }else{
                //                    正常签退(正常时间签退)
                [bself signFunctiontypeString:typeString isNeedPop:NO signType:QYSignTypeNormal];
            }
        }else{
            //（外勤）签退提示早退（2016/08/19新建改，外勤）
            [bself signFunctiontypeString:typeString isNeedPop:YES signType:QYSignTypeOut];
            
        }
        
    }else{
        if (isInner) {
            //获取当前时间
            NSDictionary *dataDictionary = [QYAttendanceListModel getDayWeek];
            //获取下午签退时间
            NSString *anotherDay =[NSString stringWithFormat:@"%@",bself.resultDictionary[@"onTime"]];
            
            //                时间校验对比
            BOOL signTime;
            if ([anotherDay isNotNil]) {
                signTime = [QYAttendanceListModel compareAndDecidedWhichFirstOneDay:dataDictionary[@"time"] withAnotherDay:anotherDay];
            }else{
                signTime=YES;
            }
            if (!signTime) {
                //内勤，迟到
                [bself signFunctiontypeString:typeString isNeedPop:YES signType:QYSignTypeLate];
            }else{
                //内勤，正常
                [bself signFunctiontypeString:typeString isNeedPop:NO signType:QYSignTypeNormal];
            }
        }else{
            //                外勤，签到（考虑是否迟到）
            [bself signFunctiontypeString:typeString isNeedPop:YES signType:QYSignTypeOut];
        }
    }
}

/**
 *  签到签退按钮点击
 *
 *  @param newLocation 点击时位置
 *  @param state  打卡类型  10上午上班签到   11下午上班签到   20上午下班签退 21下午下班签退
 *  @param state  isNeedPop 是否需要弹窗（只有内勤，并且迟到或者早退时才有备注）
 *  @param signType  显示备注类型
 */
-(void)signFunctiontypeString:(NSString *)typeString isNeedPop:(BOOL)isNeedPop signType:(QYSignType)signType{
    __weak QYAttendanceListViewController *bSelf = self;
    
    bSelf.signType=signType;
    if (!bSelf.hud) {
        bSelf.hud = [[MBProgressHUD alloc] initWithView:bSelf.view];
        bSelf.hud.labelText=@"位置！获取中...";
        bSelf.hud.mode = MBProgressHUDModeText;
        [bSelf.view addSubview:bSelf.hud];
    }
    [bSelf.hud show:YES];
    bSelf.isNeedPop=isNeedPop;
    bSelf.typeString=typeString;
    bSelf.ReverseGeoCodeType = QYReverseGeoCodeTypePopView;
    if (!bSelf.geoCodeSearch) {
        bSelf.geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
//        [bSelf.geoCodeSearch setDelegate:bSelf];
    }
    [bSelf citySearch];
}

- (void)citySearch {
    if(!_poisearch){
    _poisearch = [[BMKPoiSearch alloc]init];
   
    _poisearch.delegate = self;
         }
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc]init];
    
    option.pageIndex = 0;
    
    option.pageCapacity = 20;
    option.location = (CLLocationCoordinate2D){_personLatitude, _personlongitude};
    
    option.keyword = @"写字楼";
    
    BOOL flag = [_poisearch poiSearchNearBy:option];
    
    if(flag){
        
        NSLog(@"周边检索发送成功");
        
    }else{
        
        NSLog(@"周边检索发送失败");
    }
    
    
}
-(void)sendToAPiWithPosition:(NSString *)position  attType:(NSString *)typeString memo:(NSString *)memo{
    __weak QYAttendanceListViewController *bSelf=self;
    
    if (position&&bSelf.personLocation) {
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"定位失败，请在“设置-隐私-定位服务”里授权乐工作获取您的位置信息。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alert.tag=105;
        [alert show];
        return;
    }
    NSString *localAttendanceTime;
    CLLocationCoordinate2D newSelectionLocation ;
    if ([QYAttendanceListModel DidGetSystermPower]) {
        //给予一个时间点
        if ([typeString isEqualToString:@"10"]) {
            localAttendanceTime = [QYAttendanceListModel GetRangeRandTimeWithTypeString:typeString needTime:self.resultDictionary[@"onTime"]];
        }else{
            localAttendanceTime = [QYAttendanceListModel GetRangeRandTimeWithTypeString:typeString needTime:self.resultDictionary[@"offTime"]];
        }
        NSLog(@"特权时间:%@",localAttendanceTime);
        position=[NSString stringWithFormat:@"%@",self.listHeader.dataDictionary[@"location"]];
        newSelectionLocation = (CLLocationCoordinate2D){[self.listHeader.dataDictionary[@"latitude"] doubleValue], [self.listHeader.dataDictionary[@"longitude"] doubleValue]};
        bSelf.outOfRange = @"0";
    }else{
        NSLog(@"暂无特权");
        localAttendanceTime=@"";
        newSelectionLocation = bSelf.personLocation.coordinate;
    }
    //位置获取成功，发送签到请求
    [QYAttendanceApi signInWithPosition:position Location:newSelectionLocation attType:typeString memo:memo outOfRange:(NSString *)bSelf.outOfRange systermPowerTime:localAttendanceTime succeed:^(NSString *responseString) {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        [bSelf reloadData];
        QYNewPopViewController *popView = [[QYNewPopViewController alloc] init];
        popView.attState=[NSString stringWithFormat:@"%@",dictionary[@"attState"]];
        popView.contentViewSize = CGSizeMake(popWidth, (float)[QYDeviceInfo screenWidth]/320*302+10);
        popView.dataDictionary=[QYAttendanceListModel splitNomalDataFormat:dictionary[@"createTime"]];
        [popView addContentView];//最后调用
    } failure:^(NSString *alert) {
        switch ([typeString intValue]) {
            case 10:
                [QYDialogTool showDlgAlert:[NSString stringWithFormat:@"签到失败"]];
                break;
            case 21:
                [QYDialogTool showDlgAlert:[NSString stringWithFormat:@"签退失败"]];
                break;
                
            default:
                break;
        }
    }];
    
}
#pragma mark - getters and setters

//获取数据
-(void)reloadData{
    
    __weak QYAttendanceListViewController *bSelf= self;
    [bSelf hideNoNetworkView];
    
    [QYAttendanceApi getAttendanceFirstPageMessageWithIdentifire:nil succeed:^(NSString *responseString) {
        NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding ] options:NSJSONReadingMutableContainers error:nil];
        //NSLog(@"resultDictionary:%@",resultDictionary);
        //有没有设置打卡，有单独的字段判断，暂时未设定，attendanceNoData展会的是未设置
        //今天是否为休息日
        //有打卡设置，并且今天非工作日，才有“美好的一天开始了，祝您工作愉快”
        
        if ([resultDictionary[@"hasPlan"] intValue] == 0) {
            bSelf.attendanceNoData.hidden=NO;
            bSelf.listHeader.signInStatueChanged=NO;
            bSelf.listHeader.signOutStatueChanged=NO;
            bSelf.listHeader.reLocationButton.hidden=YES;
            bSelf.listHeader.isHavePlan=NO;
        }else{
            bSelf.attendanceNoData.hidden=YES;
            bSelf.listHeader.isHavePlan=YES;
            bSelf.listTable.dataArray=resultDictionary[@"list"];
            bSelf.resultDictionary = [[NSDictionary alloc] initWithDictionary:resultDictionary];
            bSelf.decidedLatitude=(CLLocationDegrees)[resultDictionary[@"latitude"]doubleValue];
            bSelf.decidedlongitude=(CLLocationDegrees)[resultDictionary[@"longitude"] doubleValue];
            bSelf.radiusMeter=[resultDictionary[@"range"] intValue];
            bSelf.listHeader.dataDictionary=resultDictionary;
            //刷新签到签退按钮
            if ([resultDictionary[@"signIn"] intValue]>0) {
                bSelf.listHeader.signInStatueChanged=YES;
            }else{
                bSelf.listHeader.signInStatueChanged=NO;
            }
            if ([resultDictionary[@"signOut"] intValue]>0) {
                bSelf.listHeader.signOutStatueChanged=YES;
            }else{
                bSelf.listHeader.signOutStatueChanged=NO;
            }
            bSelf.listTable.isNeedAttendance=[resultDictionary[@"rest"] boolValue];
            bSelf.listHeader.reLocation=^(NSString *alert){
                [bSelf.locationService stopUserLocationService];
                [bSelf.locationService startUserLocationService];
            };
            //位置判断
            if (bSelf.decidedLatitude&&bSelf.decidedlongitude&&bSelf.personLatitude&&bSelf.personlongitude) {
                [bSelf judgeLocationWithSystermLatitude:bSelf.decidedLatitude longitude:bSelf.decidedlongitude andNowlatitude:bSelf.personLatitude nowlongitude:bSelf.personlongitude];
            }
        }
        
    } failure:^(NSString *alert) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [bSelf showNoNetworkView];
        });
    }];
}
//详情跳转
-(void)gotoDtail{
    if ([self.listHeader.dataDictionary[@"hasPlan"] intValue]==0) {
        return;
    }
    QYAttendanceDetailViewController *attendanceDetail = [[QYAttendanceDetailViewController alloc] init];
    [self.navigationController pushViewController:attendanceDetail animated:YES];
}

@end
