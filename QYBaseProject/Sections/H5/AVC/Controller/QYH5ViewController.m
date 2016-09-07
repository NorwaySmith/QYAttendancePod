//
//  QYH5ViewController.m
//  QYBaseProject
//
//  Created by 田 on 15/8/5.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYH5ViewController.h"
#import "UIWebView+AFNetworking.h"
#import "IOSTool.h"
//#import "QYABSelectViewController.h"

//#import "QYABUserModel.h"
#import <QYAddressBook/QYABDb.h>
#import <QYAddressBook/QYABEnum.h>
#import <QYAddressBook/QYABPickerApi.h>
#import <QYAddressBook/QYABUserModel.h>
#import <QYAddressBook/QYABProtocol.h>
#import <QYAddressBook/QYABConstant.h>

#import "QYPhotoPickerHelper.h"
#import "QYH5WebView.h"
#import "QYH5ProgressView.h"
#import "QYURLHelper.h"
#import "WebViewJavascriptBridge.h"
#import "QYH5BlockButton.h"
#import "QYH5PathHelper.h"
#import <sys/utsname.h>
#import "QYH5Api.h"
#import "QYAccountService.h"
#import "QYRedDotHelper.h"

#import "QYH5DatePicker.h"
#import "YUDatePicker.h"
#import "QYNavigationViewController.h"

/**
 *  服务端协议，是否创建头部按钮
 */
static NSString *const HeaderButtonKey = @"onHeaderButton";
/**
 *  服务端协议，选择时间
 */
static NSString *const SelectDateTimeKey = @"selectDateTime";
/**
 *  服务端协议，选择人员，兼容老协议
 */
static NSString *const SelectUserKey = @"selectUser";
/**
 *  服务端协议，选择人员，新协议
 */
static NSString *const SelectMoreUserKey = @"selectMoreUser";
/**
 *  服务端协议，选择人员，单选
 */
static NSString *const SelectOneUserKey = @"selectOneUser";
/**
 *  服务端协议，退出H5，新接口上没有
 */
static NSString *const QuitQuestionKey = @"quitQuestion";
/**
 *  服务端协议，上传文件
 */
static NSString *const UploadFileKey = @"uploadFile";

/**
 *  服务端协议，已经有人的选人，暂时无用
 */
static NSString *const GetUserByIdKey = @"getUserById";
/**
 *  服务端协议，提示
 */
static NSString *const TipsKey = @"tips";
/**
 *  服务端协议，关闭当前页面
 */
static NSString *const FinishWebViewKey = @"finishWebView";
/**
 *  服务端协议，选择照片或拍照
 */
static NSString *const SelectPhotoDialogKey = @"selectPhotoDialog";
/**
 *  服务端协议，左侧按钮，暂时无用
 */
static NSString *const LeftButtonKey = @"leftButton";
/**
 *  服务端协议，右侧按钮，暂时无用
 */
static NSString *const RightButtonKey = @"rightButton";

/**
 *  服务端协议，隐藏头部
 */
static NSString *const TitleIsHideKey = @"titleIsHide";

/**
 *  得到登陆人员信息
 */
static NSString *const GetLoginUserInfo = @"getLoginUserInfo";
///////////右侧操作按钮样式///////////
/**
 *  服务端协议，右侧按钮是添加
 */
static NSString *const RightButtonTypeAdd = @"toAdd";
/**
 *  服务端协议，右侧按钮是文本
 */
static NSString *const RightButtonTypeText = @"text";
/**
 *  服务端协议，左侧按钮是返回
 */
static NSString *const RightButtonTypeBack = @"back";


/**
 *  js参数分隔符
 */
static NSString *const ParameterSeparated = @"::/";


/**
 *  @author 杨峰, 16-04-21 13:04:50
 *
 *  注册成功，返回登录页面
 */
static NSString *const RegistSuccessCallBack = @"RegistSuccessCallBack";



@interface QYH5ViewController ()<UIWebViewDelegate,UIActionSheetDelegate,QYH5WebViewProgressDelegate,QYABProtocol>


@property(nonatomic,strong)QYH5WebView *webView;
/**
 *  初始化控制器传入的Url
 */
@property(nonatomic,strong)NSURL *defaultUrl;
/**
 *  导航左按钮数据,暂时无用
 */
@property(nonatomic,strong)NSDictionary *leftButtonDictionary;
/**
 *  导航右按钮数据
 */
@property(nonatomic,strong)NSDictionary *rightButtonDictionary;
/**
 *  进度条
 */
@property(nonatomic,strong)QYH5ProgressView *progressView;
/**
 *  js桥
 */
@property(nonatomic,strong)WebViewJavascriptBridge* bridge;
/**
 *  H5轨迹管理
 */
@property(nonatomic,strong)QYH5PathHelper *pathHelper;

/**
 *  H5回调临时对象
 */
@property (nonatomic, strong) WVJBResponseCallback callback;

/**
 *  H5键临时对象
 */
@property (nonatomic, strong) NSString  *handleKey;

@property (nonatomic, strong) NSDate *selectDate;
@property (nonatomic, strong) YUDatePicker *datePicker;


@end

@implementation QYH5ViewController

#pragma mark - life cycle
-(void)dealloc
{
    _webView = nil;
//    [_bridge reset];
    _bridge = nil;
    _defaultUrl = nil;
    _leftButtonDictionary = nil;
    _rightButtonDictionary = nil;
    _progressView = nil;
    

}
- (id)initWithUrl:(NSURL *)url
{
    self = [super initWithNibName:nil bundle:nil];
    if (self)
    {
        self.hidesBottomBarWhenPushed = YES;
        _defaultUrl = url;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pathHelper = [[QYH5PathHelper alloc] init];
    [self configWebView];
    [self configProgressView];
    [self configLeftBarButton];
}

- (void)viewWillDisappear:(BOOL)animated {
    if (_datePicker) {
        [_datePicker hidden];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI
/**
 *  初始化webView
 */
-(void)configWebView
{
    self.webView = [[QYH5WebView alloc] initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth], [QYDeviceInfo screenHeight] - 64)];
    _webView.h5Delegate = self;
    _webView.scrollView.bounces = NO;
    [self.view addSubview:_webView];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:_defaultUrl];
    [_webView loadRequest:urlRequest];
    
    [self configJsBridge];
}

/**
 *  初始化js交互
 */
-(void)configJsBridge
{
    /**
     *  开启输出模式
     */
//    [WebViewJavascriptBridge enableLogging];
    
    /**
     *  需要在QYH5WebView中监测加载进度，所以webViewDelegate设置成_webView
     */
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView webViewDelegate:_webView handler:^(id data, WVJBResponseCallback responseCallback)
    {
        
    }];
    __weak QYH5ViewController *wself = self;

    /**
     *  人员单选事件监听
     */
    [_bridge registerHandler:SelectOneUserKey handler:^(id data, WVJBResponseCallback responseCallback)
    {
        [self.view endEditing:YES];
        
        self.callback = responseCallback;
        self.handleKey = SelectMoreUserKey;
        
        NSString *userIds = nil;
        if (data && [data isKindOfClass:[NSString class]])
        {
            userIds = (NSString *)data;
        }
        if ([userIds hasPrefix:@","]) {
            userIds = [userIds substringFromIndex:1];
        }
        
        if ([userIds hasSuffix:@","]) {
            userIds = [userIds substringToIndex:userIds.length-1];
        }
        
        NSMutableArray *users = [[NSMutableArray alloc] init];
        if (userIds) {
            [users addObjectsFromArray:[QYABDb groupUserWithUserIdstr:userIds]];
        }
        
        QYABPickerApi *picker = [[QYABPickerApi alloc] initSinglePickerWithDelegate:self permitModules:@[AddressBookUnits, AddressBookCommonUser] isShowHiddenPerson:NO moduleName:[[QYAccountService shared] combinedModuleName:AddressBookPicker_Base]];
        [picker setLockedUsers:nil];
        [picker show:QYABPickerDisplayModePush];
        
    }];

    /**
     *  选择时间
     */
    [_bridge registerHandler:SelectDateTimeKey handler:^(id data, WVJBResponseCallback responseCallback) {
        
        if (data && [data isKindOfClass:[NSDictionary class]]) {
            if ([data[@"format"] isEqualToString:@"yyyy-MM"]) {
                
                if (!_datePicker) {
                    _datePicker = [[YUDatePicker alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 300 + 80, [UIScreen mainScreen].bounds.size.width, 300)];
                }

                _datePicker.datePickerMode = UIYUDatePickerModeDateYYYYMM;
                
                NSDate *minDate = [NSDate dateWithTimeIntervalSince1970:0];
                _datePicker.minimumDate = minDate;
                if (self.selectDate) {
                    _datePicker.date = self.selectDate;
                }
                else {
                    _datePicker.date = [NSDate date];
                }
                _datePicker.showToolbar = YES;
                UIWindow *window = [UIApplication sharedApplication].keyWindow;
                [window addSubview:_datePicker];
                
                __weak QYH5ViewController *wSelf = self;
                _datePicker.datePickerChangeBlock = ^(NSDate *date) {
                    wSelf.selectDate = date;  //记录选中的时间
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = data[@"format"];
                    NSString *dateStr = [dateFormatter stringFromDate:date];
                    
                    NSDictionary *dic = @{@"isSuccess":[NSNumber numberWithBool:true],
                                          @"selectTime":dateStr};
                    NSString *json = [wself jsonWithDic:dic];
                    responseCallback(json);
                    wSelf.datePicker = nil;
                };
                _datePicker.datePickerCancelBlock = ^(void) {
                    wSelf.datePicker = nil;
                };
            }
            else {
                QYH5DatePicker *datePicker = [[QYH5DatePicker alloc] initWithDefaulDate:data[@"defaultTime"] datePickerMode:UIDatePickerModeDateAndTime format:data[@"format"]];
                [datePicker show];
                
                datePicker.datePickerChangeBlock = ^(NSString *date) {
                    NSDictionary *dic = @{@"isSuccess":[NSNumber numberWithBool:true],
                                          @"selectTime":date};
                    NSString *json = [wself jsonWithDic:dic];
                    responseCallback(json);
                };
            }
        }else{
            [QYDialogTool showDlg:@"error:服务器参数错误"];
        }
    }];

    /**
     *  提示
     */
    [_bridge registerHandler:TipsKey handler:^(id data, WVJBResponseCallback responseCallback) {

        if (data&&[data isKindOfClass:[NSDictionary class]])
        {
            float afterDelay = [data[@"timeout"] floatValue]/1000.0 == 0 ? 1 : [data[@"timeout"] floatValue]/1000.0;
            
            [QYDialogTool showDlg:wself.view withLabel:data[@"content"] afterDelay:afterDelay];
        }else{
            [QYDialogTool showDlg:@"error:服务器参数错误"];
        }
    }];
    /**
     * 多选人员，新协议
     */
    [_bridge registerHandler:SelectMoreUserKey handler:^(id data, WVJBResponseCallback responseCallback)
    {
        [self.view endEditing:YES];

        self.callback = responseCallback;
        self.handleKey = SelectMoreUserKey;
        
        NSString *userIds = nil;
        if (data && [data isKindOfClass:[NSString class]]) {
            userIds = (NSString *)data;
        }
        if ([userIds hasPrefix:@","]) {
            userIds = [userIds substringFromIndex:1];
        }
        
        if ([userIds hasSuffix:@","]) {
            userIds = [userIds substringToIndex:userIds.length-1];
        }
        
        NSMutableArray *users = [[NSMutableArray alloc] init];
        if (userIds) {
            [users addObjectsFromArray:[QYABDb groupUserWithUserIdstr:userIds]];
        }
        
        QYABPickerApi *picker = [[QYABPickerApi alloc] initMultiPickerWithDelegate:self permitModules:@[AddressBookUnits, AddressBookCommonUser, AddressBookCommonGroup] isShowHiddenPerson:NO maximumSelect:0 moduleName:[[QYAccountService shared] combinedModuleName:AddressBookPicker_Base]];
        
        [picker setSelectedUsers:users];
        [picker setLockedUsers:nil];
        [picker show:QYABPickerDisplayModePush];
        
//        QYABSelectViewController *selectViewController = [[QYABSelectViewController alloc] initWithSelectType:QYABSelectTypeMultiple showItems:@[@(AddressBookTypeUnits)] isShowHiddenPerson:YES];
//        
//        if (data && [data isKindOfClass:[NSString class]])
//        {
//            NSArray *selectUserIds = [data componentsSeparatedByString:@","];
//            NSMutableArray *selectUserArray = [[NSMutableArray alloc] init];
//            for (NSString *userId in selectUserIds)
//            {
//                if ([userId longLongValue] != 0)
//                {
//                    QYABUserModel *userModel = [[QYABUserModel alloc] init];
//                    userModel.userId = @([userId longLongValue]);
//                    [selectUserArray addObject:userModel];
//                }
//            }
//            [selectViewController setSelectUsers:selectUserArray];
//        }
//        [wself.navigationController pushViewController:selectViewController animated:YES];
//        
//        __weak QYABSelectViewController *wSelectViewController = selectViewController;
//        //选择完成回调
//        [selectViewController setSelectCompleteBlock:^(NSArray *userArray)
//        {
//            NSMutableArray *jsonArray = [[NSMutableArray alloc] init];
//            
//            for (QYABUserModel *userModel in userArray)
//            {
//                NSString *photoUrlString = [[QYURLHelper shared] getUrlWithModule:@"ydzjMobile" urlKey:@"headPictureView"];
//                NSString *photo = [NSString stringWithFormat:@"%@_clientType=wap&filePath=%@",photoUrlString,userModel.photo];
//                userModel.photo = photo;
//                NSDictionary *userDic = [userModel toDictionaryWithKeys:@[@"userId",@"userName",@"photo"]];
//                [jsonArray addObject:userDic];
//            }
//            NSDictionary *dic = @{@"isSuccess": [NSNumber numberWithBool:true],@"userList":jsonArray};
//            NSString *json = [[wself jsonWithDic:dic] stringByReplacingOccurrencesOfString:@"\"photo\"" withString:@"\"userPhoto\""];
//            responseCallback(json);
//            dispatch_async(dispatch_get_main_queue(), ^
//            {
//                [wSelectViewController.navigationController popViewControllerAnimated:YES];
//            });
//        }
//        selectCancel:^
//        {
//            dispatch_async(dispatch_get_main_queue(), ^
//            {
//                [wSelectViewController.navigationController popViewControllerAnimated:YES];
//            });
//        }];
    }];

    /**
     * 多选人员，老协议
     */
    [_bridge registerHandler:SelectUserKey handler:^(id data, WVJBResponseCallback responseCallback)
    {
        [self.view endEditing:YES];

        self.callback = responseCallback;
        self.handleKey = SelectUserKey;
        
        NSString *userIds = nil;
        if (data && [data isKindOfClass:[NSString class]])
        {
            userIds = (NSString *)data;
        }
        if ([userIds hasPrefix:@","]) {
            userIds = [userIds substringFromIndex:1];
        }
        
        if ([userIds hasSuffix:@","]) {
            userIds = [userIds substringToIndex:userIds.length-1];
        }
        
        NSMutableArray *users = [[NSMutableArray alloc] init];
        if (userIds) {
            [users addObjectsFromArray:[QYABDb groupUserWithUserIdstr:userIds]];
        }
        
        QYABPickerApi *picker = [[QYABPickerApi alloc] initMultiPickerWithDelegate:self permitModules:@[AddressBookUnits, AddressBookCommonUser, AddressBookCommonGroup] isShowHiddenPerson:NO maximumSelect:0 moduleName:[[QYAccountService shared] combinedModuleName:AddressBookPicker_Base]];
        
        [picker setSelectedUsers:users];
        [picker setLockedUsers:nil];
        [picker show:QYABPickerDisplayModePush];
        
//        QYABSelectViewController *selectViewController = [[QYABSelectViewController alloc] initWithSelectType:QYABSelectTypeMultiple showItems:@[@(AddressBookTypeUnits)] isShowHiddenPerson:YES];
//        
//        if (data && [data isKindOfClass:[NSString class]])
//        {
//            NSArray *selectUserIds = [data componentsSeparatedByString:@","];
//            NSMutableArray *selectUserArray = [[NSMutableArray alloc] init];
//            
//            for (NSString *userId in selectUserIds)
//            {
//                if ([userId longLongValue] != 0)
//                {
//                    QYABUserModel *userModel = [[QYABUserModel alloc] init];
//                    userModel.userId = @([userId longLongValue]);
//                    [selectUserArray addObject:userModel];
//                }
//            }
//            [selectViewController setSelectUsers:selectUserArray];
//        }
//        [wself.navigationController pushViewController:selectViewController animated:YES];
//        
//        __weak QYABSelectViewController *wSelectViewController = selectViewController;
//        //选择完成回调
//        [selectViewController setSelectCompleteBlock:^(NSArray *userArray)
//        {
//            NSMutableArray *userIdArray = [[NSMutableArray alloc] init];
//            NSMutableArray *userNameArray = [[NSMutableArray alloc] init];
//
//            for (QYABUserModel *userModel in userArray)
//            {
//                [userNameArray addObject:userModel.userName];
//                [userIdArray addObject:userModel.userId];
//            }
//            NSDictionary *dic = @{@"userIds": [userIdArray componentsJoinedByString:@","],
//                                  @"userNames":[userNameArray componentsJoinedByString:@","]};
//            NSString *json=[wself jsonWithDic:dic];
//            responseCallback(json);
//            dispatch_async(dispatch_get_main_queue(), ^
//            {
//                [wSelectViewController.navigationController popViewControllerAnimated:YES];
//            });
//        }
//        selectCancel:^
//        {
//            dispatch_async(dispatch_get_main_queue(), ^
//            {
//                [wSelectViewController.navigationController popViewControllerAnimated:YES];
//            });
//        }];
    }];

    /**
     *  关闭当前模块
     */
    [_bridge registerHandler:FinishWebViewKey handler:^(id data, WVJBResponseCallback responseCallback)
    {
        dispatch_async(dispatch_get_main_queue(), ^
        {
            [wself.navigationController popViewControllerAnimated:YES];
        });
    }];
    /**
     *  得到登陆人员信息
     */
    [_bridge registerHandler:GetLoginUserInfo handler:^(id data, WVJBResponseCallback responseCallback)
    {
        QYAccount *account = [[QYAccountService shared] defaultAccount];
        NSString *userInfo = [NSString stringWithFormat:@"{userId:%@}",account.userId];
        NSDictionary *dic = @{@"userInfo":userInfo};
        NSString *json = [wself jsonWithDic:dic];
        responseCallback(json);
    }];
    
    /**
     *  配置头部按钮，暂时使用shouldStartLoadWithRequest中的进行配置
     */
    /*
    [_bridge registerHandler:HeaderButtonKey handler:^(id data, WVJBResponseCallback responseCallback) {

    }];
    
   
    [_bridge registerHandler:RightButtonKey handler:^(id data, WVJBResponseCallback responseCallback) {
        QYH5BlockButton *rightButton = [QYH5BlockButton buttonWithType:UIButtonTypeCustom];
        rightButton.titleLabel.font=[UIFont systemFontOfSize:16];
        UIBarButtonItem *operationBar=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
        if ([wself.rightButtonDictionary[@"type"] isEqualToString:RightButtonTypeAdd]) {
            rightButton.frame=CGRectMake(0, 0, 50, 44);
            [rightButton setImage:[UIImage imageNamed:@"H5_addIcon"] forState:UIControlStateNormal];
        }else if ([wself.rightButtonDictionary[@"type"] isEqualToString:RightButtonTypeText]){
            [rightButton setTitle:wself.rightButtonDictionary[@"message"] forState:UIControlStateNormal];
            [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [rightButton setTitleColor:[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:210.0/255.0] forState:UIControlStateHighlighted];
            CGSize size = [wself.rightButtonDictionary[@"message"] sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
            rightButton.frame=CGRectMake(0, 0, size.width+15, 43);
        }
        wself.navigationItem.rightBarButtonItem=operationBar;
    
        rightButton.buttonClickBlock=^(UIButton *button){
        
        };
    }];
    
    [_bridge registerHandler:LeftButtonKey handler:^(id data, WVJBResponseCallback responseCallback) {

        QYH5BlockButton *leftButton = [QYH5BlockButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = [UIImage  themeBackButton];
        
        [leftButton setImage:img forState:UIControlStateNormal];
        [leftButton removeTarget:nil
                          action:NULL
                forControlEvents:UIControlEventAllEvents];
//        [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
        leftButton.frame = CGRectMake(0, 0, 30, 30);
        UIBarButtonItem *operationBar=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem =operationBar;
        leftButton.buttonClickBlock=^(UIButton *button){
            
        };
    }];
     */
    /**
     *  设置头部隐藏
     */
    [_bridge registerHandler:TitleIsHideKey handler:^(id data, WVJBResponseCallback responseCallback)
    {
        //判断是否为bool类型
        if (data)
        {
            [wself hideNavigationBar:[data boolValue]];
        }
        else
        {
            [QYDialogTool showDlg:@"error:服务器参数错误"];
        }
    }];
    /**
     *  上传图片
     */
    [_bridge registerHandler:SelectPhotoDialogKey handler:^(id data, WVJBResponseCallback responseCallback)
     {
        if (data&&[data isKindOfClass:[NSDictionary class]])
        {
            [[QYPhotoPickerHelper shared] showActionSheetInView:self.view
                                                 fromController:self
                                                     completion:^(UIImage *image)
             {
                 if (!image)
                 {
                     [QYDialogTool showDlg:@"图片不能为空！"];
                     return;
                 }
                 [QYH5Api upLoadImage:UIImagePNGRepresentation(image) urlString:data[@"uploadPath"] moduleCode:data[@"moduleCode"] success:^(NSString *responseString)
                 {
                     NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
                     NSError *err;
                     NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:&err];
                     NSDictionary *dic = [[NSDictionary alloc] initWithDictionary:array[0]];
                     //拼装上传url
                     //http://10.100.6.140:10000/fileServer/download?fileId=1231
                     NSString *imageUrlString = [NSString stringWithFormat:@"%@",dic[@"id"]];
                     NSDictionary *callBackDic = @{@"isSuccess": [NSNumber numberWithBool:true],@"id":imageUrlString};
                     NSString *json = [wself jsonWithDic:callBackDic];
                     responseCallback(json);
                 }
                 failure:^(NSString *alert)
                 {
                     [QYDialogTool showDlg:alert];
                 }
                 UpLoadproGress:^(float progress)
                 {
                     //NSLog(@"上传图片进度:%f",progress);
                 }];
             }
            cancelBlock:^
            {
                                                        
            }];
        }
        else
        {
            [QYDialogTool showDlg:@"error:服务器参数错误"];
        }
    }];
    //注册成功，返回登录页面
    [_bridge registerHandler:RegistSuccessCallBack handler:^(id data, WVJBResponseCallback responseCallback) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
/**
 *  初始化进度条
 */
-(void)configProgressView
{
    CGFloat progressBarHeight = 3.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, 0, navigaitonBarBounds.size.width, progressBarHeight);
    self.progressView = [[QYH5ProgressView alloc] initWithFrame:barFrame];
    [self.view addSubview:_progressView];
}
/**
 *  初始化左侧返回按钮
 */
-(void)configLeftBarButton
{
    self.navigationItem.rightBarButtonItem = nil;
    
    NSString *title = [(QYNavigationViewController *)self.navigationController getFrontViewControllerTitle];
    
    //左侧返回
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.backgroundColor = [UIColor clearColor];
    leftButton.titleLabel.font = [UIFont baseTextMiddle];
    [leftButton setImage:[UIImage imageNamed:@"base_navBack"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"base_navBackH"] forState:UIControlStateHighlighted];
    [leftButton setTitle:title forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.5] forState:UIControlStateHighlighted];
    leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 60, 30);
    UIBarButtonItem *operationLeftBar = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if ([QYDeviceInfo systemVersion] >= 7.0){
        negativeSpacer.width = -16;
    }else{
        negativeSpacer.width = -10;
    }
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, operationLeftBar];
    
    
//    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *img = [UIImage themeBackButton];
//    
//    [leftButton setImage:img forState:UIControlStateNormal];
//    [leftButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
//    [leftButton addTarget:self action:@selector(leftButtonClick) forControlEvents:UIControlEventTouchUpInside];
//    leftButton.frame = CGRectMake(0, 0, 30, 30);
//    UIBarButtonItem *operationBar = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
//    
//    UIBarButtonItem *leftSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//    
//    if ([[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue] >= 7.0)
//    {
//        leftSpace.width = -16;
//    }
//    else
//    {
//        leftSpace.width = -10;
//    }
//
//    self.navigationItem.leftBarButtonItems = @[leftSpace,operationBar];
}
/**
 *  初始化右上角按钮
 */
-(void)configRightBarButton
{
    self.navigationItem.rightBarButtonItem = nil;
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [rightButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [rightButton addTarget:self action:@selector(rightButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *operationBar = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    if ([_rightButtonDictionary[@"type"] isEqualToString:RightButtonTypeAdd])
    {
        rightButton.frame = CGRectMake(0, 0, 50, 44);
        [rightButton setImage:[UIImage imageNamed:@"H5_addIcon"] forState:UIControlStateNormal];
    }
    else if ([_rightButtonDictionary[@"type"] isEqualToString:RightButtonTypeText])
    {
        [rightButton setTitle:_rightButtonDictionary[@"message"] forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightButton setTitleColor:[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:210.0/255.0] forState:UIControlStateHighlighted];
        CGSize size = [_rightButtonDictionary[@"message"] sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(200, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
        rightButton.frame = CGRectMake(0, 0, size.width+15, 43);
    }
    self.navigationItem.rightBarButtonItem = operationBar;
}
#pragma mark - UIWebViewDelegate

- (void)webView:(QYH5WebView *)webView progress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *url=[request URL];
    
    NSString *urlString=[[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *separatoryArray = [urlString componentsSeparatedByString:ParameterSeparated];
    if ([separatoryArray count] > 1)
    {
        NSDictionary *parameterDic = [self dicWithJson:separatoryArray[1]];
        ///////////////////////////////兼容老模块///////////////////////////////////
        //创建顶部左右按钮
        if([urlString rangeOfString:HeaderButtonKey].location != NSNotFound)
        {
            [self configRightAndLeftBarButton:parameterDic];
            return NO;
        }
        //选择时间
        if([urlString rangeOfString:SelectDateTimeKey].location != NSNotFound)
        {
            [self selectDate:parameterDic];
            return NO;
        }
        //选择人员
        if([urlString rangeOfString:SelectUserKey].location != NSNotFound)
        {
            [self selectUser:parameterDic];
            return NO;
        }
        //选择人员，单选
        if([urlString rangeOfString:SelectOneUserKey].location != NSNotFound)
        {
            [self selecOnetUser:parameterDic];
            return NO;
        }
        //提示框
        if([urlString rangeOfString:TipsKey].location != NSNotFound)
        {
            [self showTips:parameterDic];
            return NO;
        }
        //退出
        if([urlString rangeOfString:QuitQuestionKey].location != NSNotFound)
        {
            [self closeViewController];
            return NO;
        }
        //关闭当前页面
        if([urlString rangeOfString:FinishWebViewKey].location != NSNotFound)
        {
            [self closeViewController];
            return NO;
        }
        //选择照片或者拍照
        if([urlString rangeOfString:SelectPhotoDialogKey].location!=NSNotFound)
        {
            [self showPhotoActionSheet:parameterDic];
            return NO;
        }
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    //默认设置为显示
    [self hideNavigationBar:NO];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_pathHelper pushURLRequest:webView.request];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loadSuccess('当前页面标示','未知参数');"]];

    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
   
    //禁止webView点击后的弹窗
    [self.webView stringByEvaluatingJavaScriptFromString:
     @"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:
     @"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //加载无网络页面
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"no_net" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [_webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
}
#pragma mark - CustomDelegate



#pragma mark - event response
/**
 *  左侧按钮点击事件
 */
-(void)leftButtonClick
{
    //如果js绑定返回事件，优先调用js返回
    NSString *method = (NSString *)[_leftButtonDictionary objectForKey:@"onClickMethod"];
    //不能执行pc端toBack方法，否则轨迹会乱
    if (method && ![method isEqualToString:@"toBack"] && ![method isEqualToString:@"back"] && ![method isEqualToString:@"goBack"] && ![method isEqualToString:@"gotoback"])
    {
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('当前页面标示','未知参数');",method]];
        return;
    }
    //出栈
    NSURLRequest *URLRequest = [_pathHelper popURLRequest];
    if (URLRequest)
    {
        [_webView loadRequest:URLRequest];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    [[QYRedDotHelper shared] allRedPointFromNetwork];
//    [[QYBadgeManage shared] accessToTheNumberOfNonReading];
    
//    else
//    {
//        if (_webView.canGoBack==YES)
//        {
//            [_webView goBack];
//        }
//        else
//        {
//            [self.navigationController popViewControllerAnimated:YES];
//        }
//    }
    
}
/**
 *  右侧按钮点击事件
 */
-(void)rightButtonClick
{
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"%@('当前页面标示','未知参数');",_rightButtonDictionary[@"onClickMethod"]]];
}
#pragma mark - JavascriptBridge
/**
 *  配置头部按钮
 *
 *  @param parameter 参数
 */
-(void)configRightAndLeftBarButton:(NSDictionary *)parameter
{
    _leftButtonDictionary = nil;
    _leftButtonDictionary = [[NSDictionary alloc] initWithDictionary:parameter[@"leftButton"]];
    _rightButtonDictionary = nil;
    _rightButtonDictionary = [[NSDictionary alloc] initWithDictionary:parameter[@"rightButton"]];
    [self configRightBarButton];
}
/**
 *  选择时间
 *
 *  @param parameter 参数
 */
-(void)selectDate:(NSDictionary *)parameter
{
    NSString *method = parameter[@"method"];
     NSString *format = @"yyyy-MM-dd HH:mm:ss";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = format;
    NSString *date = [dateFormatter stringFromDate:[NSDate date]];
    
    QYH5DatePicker *datePicker = [[QYH5DatePicker alloc] initWithDefaulDate:date datePickerMode:UIDatePickerModeDateAndTime format:format];
    [datePicker show];
    datePicker.datePickerChangeBlock = ^(NSString *date)
    {
        [self sendMesToJsMethod:method message:date];
    };
}
/**
 *  选择人员
 *
 *  @param parameter 参数
 */
-(void)selectUser:(NSDictionary*)parameter
{
    /*
    QYABSelectViewController *selectViewController = [[QYABSelectViewController alloc] initWithSelectType:QYABSelectTypeMultiple showItems:@[@(AddressBookTypeUnits)] isShowHiddenPerson:YES];
    NSArray *selectUserIds = [parameter[@"defaultUserIds"] componentsSeparatedByString:@","];
    NSMutableArray *selectUserArray = [[NSMutableArray alloc] init];
    for (NSString *userId in selectUserIds)
    {
        if ([userId longLongValue] != 0)
        {
            QYABUserModel *userModel = [[QYABUserModel alloc] init];
            userModel.userId = @([userId longLongValue]);
            [selectUserArray addObject:userModel];
        }
    }
    [selectViewController setSelectUsers:selectUserArray];
    [self.navigationController pushViewController:selectViewController animated:YES];
    //选择人员事件监控
    __weak QYABSelectViewController *wSelectViewController=selectViewController;
    [selectViewController setSelectCompleteBlock:^(NSArray *userArray)
    {
        NSMutableArray *jsonArray = [[NSMutableArray alloc] init];
        for (QYABUserModel *userModel in userArray)
        {
            NSString *photoUrlString = [[QYURLHelper shared] getUrlWithModule:@"ydzjMobile" urlKey:@"headPictureView"];
            NSString *photo = [NSString stringWithFormat:@"%@_clientType=wap&filePath=%@",photoUrlString,userModel.photo];
            userModel.photo = photo;
            NSString *userJson = [userModel toJSONStringWithKeys:@[@"userId",@"userName",@"photoUrl"]];
            [jsonArray addObject:userJson];
        }
        NSString *json = [NSString stringWithFormat:@"[%@]",[jsonArray componentsJoinedByString:@","]];
        [self sendMesToJsMethod:parameter[@"method"] message:json];
        [wSelectViewController.navigationController popViewControllerAnimated:YES];
    }
    selectCancel:^
    {
        [wSelectViewController.navigationController popViewControllerAnimated:YES];
    }];
     */
}
/**
 *  选择人员，单选
 *
 *  @param parameter 参数
 */
-(void)selecOnetUser:(NSDictionary *)parameter
{
    /*
    QYABSelectViewController *selectViewController = [[QYABSelectViewController alloc] initWithSelectType:QYABSelectTypeSingle showItems:@[@(AddressBookTypeUnits)] isShowHiddenPerson:YES];
    NSArray *selectUserIds = [parameter[@"defaultUserIds"] componentsSeparatedByString:@","];
    NSMutableArray *selectUserArray = [[NSMutableArray alloc] init];
    for (NSString *userId in selectUserIds)
    {
        if ([userId longLongValue] != 0)
        {
            QYABUserModel *userModel = [[QYABUserModel alloc] init];
            userModel.userId = @([userId longLongValue]);
            [selectUserArray addObject:userModel];
        }
    }
    [selectViewController setSelectUsers:selectUserArray];
    [self.navigationController pushViewController:selectViewController animated:YES];
    
     //选择人员事件监控
    __weak QYABSelectViewController *wSelectViewController = selectViewController;
    [selectViewController setSelectCompleteBlock:^(NSArray *userArray)
    {
        NSMutableArray *jsonArray = [[NSMutableArray alloc] init];
        for (QYABUserModel *userModel in userArray)
        {
            NSString *photoUrlString = [[QYURLHelper shared] getUrlWithModule:@"ydzjMobile" urlKey:@"headPictureView"];
            NSString *photo = [NSString stringWithFormat:@"%@_clientType=wap&filePath=%@",photoUrlString,userModel.photo];
            userModel.photo = photo;
            NSString *userJson = [userModel toJSONStringWithKeys:@[@"userId",@"userName",@"photo"]];
            [jsonArray addObject:[userJson stringByReplacingOccurrencesOfString:@"\"photo\"" withString:@"\"photoUrl\""]];
        }
        NSString *json = [NSString stringWithFormat:@"%@",[jsonArray componentsJoinedByString:@","]];
        [self sendMesToJsMethod:parameter[@"method"] message:json];
        [wSelectViewController.navigationController popViewControllerAnimated:YES];
    }
    selectCancel:^
    {
        [wSelectViewController.navigationController popViewControllerAnimated:YES];
    }];
     */
}
/**
 *  显示提示框
 *
 *  @param parameter 参数
 */
-(void)showTips:(NSDictionary*)parameter
{
    [QYDialogTool showDlg:parameter[@"message"]];
}
/**
 *  关闭当前页
 */
-(void)closeViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}
/**
 *  拍照
 *
 *  @param parameter 参数
 */
-(void)showPhotoActionSheet:(NSDictionary*)parameter
{
    [[QYPhotoPickerHelper shared] showActionSheetInView:self.view fromController:self completion:^(UIImage *image)
    {
                                                 
    }
    cancelBlock:^
    {

    }];
}
/**
 * 隐藏导航栏
 *
 *  @param parameter 参数
 */
-(void)hideNavigationBar:(BOOL)isHidden
{
    if (isHidden)
    {
        [super.navigationController setNavigationBarHidden:YES animated:NO];
        self.webView.frame = self.view.bounds;
    }
    else
    {
        [super.navigationController setNavigationBarHidden:NO animated:NO];
        self.webView.frame = CGRectMake(0, 0, [QYDeviceInfo screenWidth], [QYDeviceInfo screenHeight]-64);
    }
}


/**
 *  调用js函数
 *
 *  @param method  方法名
 *  @param message 参数
 */
-(void)sendMesToJsMethod:(NSString *)method message:(NSString *)message
{
    //发送劫持
    if ([[QYNetworkInfo shared] connectedToNetwork])
    {
        //网络状态正常
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"onSuccess('%@','%@');",method,message]];
    }
    else
    {
        //加载无网络页面
        [QYDialogTool showDlg:@"网络错误"];
    }
    
}

#pragma mark - private methods
/**
 *  解析json数据
 *
 *  @param jsonString json数据
 *
 *  @return 字典
 */
- (NSDictionary *)dicWithJson:(NSString *)jsonString
{
    if (jsonString == nil)
    {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        //NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
-(NSString*)jsonWithDic:(NSDictionary *)dic
{
    if (dic == nil)
    {
        return nil;
    }
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&err];
    if(err)
    {
        //NSLog(@"json解析失败：%@",err);
        return nil;
    }
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return str;
    
}
/**
 *  格式化时间
 *
 *  @param theDate 要格式的时间
 *
 *  @return 格式化后的时间
 */
- (NSString*)dateFormat:(NSString*)theDate
{
    NSDateFormatter *iosDateFormater = [[NSDateFormatter alloc] init];
    iosDateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [iosDateFormater dateFromString:theDate];
    iosDateFormater.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    return [iosDateFormater stringFromDate:date];
}

#pragma mark - QYABPickerDelegate
- (void)pickerDidFinishedSelectedWithUsers:(NSArray *)users {
    if (self.handleKey) {
        NSString *json = @"";
        if ([self.handleKey isEqualToString:SelectUserKey]) {
            NSMutableArray *userIdArray = [[NSMutableArray alloc] init];
            NSMutableArray *userNameArray = [[NSMutableArray alloc] init];
            
            for (QYABUserModel *userModel in users)
            {
                [userNameArray addObject:userModel.userName];
                [userIdArray addObject:userModel.userId];
            }
            NSDictionary *dic = @{@"userIds": [userIdArray componentsJoinedByString:@","],
                                  @"userNames":[userNameArray componentsJoinedByString:@","]};
            json=[self jsonWithDic:dic];
        }
        else if ([self.handleKey isEqualToString:SelectMoreUserKey]) {
            NSMutableArray *jsonArray = [[NSMutableArray alloc] init];
            for (QYABUserModel *userModel in users)
            {
                NSString *photoUrlString = [[QYURLHelper shared] getUrlWithModule:@"ydzjMobile" urlKey:@"headPictureView"];
                NSString *photo = [NSString stringWithFormat:@"%@_clientType=wap&filePath=%@",photoUrlString,userModel.photo];
                userModel.photo = photo;
                NSDictionary *userDic = [userModel toDictionaryWithKeys:@[@"userId",@"userName",@"photo"]];
                [jsonArray addObject:userDic];
            }
            NSDictionary *dic = @{@"isSuccess": [NSNumber numberWithBool:true],@"userList":jsonArray};
            json = [[self jsonWithDic:dic] stringByReplacingOccurrencesOfString:@"\"photo\"" withString:@"\"userPhoto\""];
        }
        else if([self.handleKey isEqualToString:SelectOneUserKey]) {
        
        }
        
        if (self.callback) {
            self.callback(json);
        }
    }
}


@end
