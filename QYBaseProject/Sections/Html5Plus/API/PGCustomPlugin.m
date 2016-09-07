//
//  PluginTest.m
//  HBuilder-Hello
//
//  Created by zhaotengfei on 15/9/24.
//  Copyright (c) 2015年 田. All rights reserved.//

#import "PDRCore.h"
#import "PDRCoreAppManager.h"
#import "PGCustomPlugin.h"
#import <QYAddressBook/QYAddressHeader.h>
#import <QYDIDIReminCBB/QYDiDiNewRemindViewController.h>

//#import "QYABSelectViewController.h"
//#import "QYABUserModel.h"
//#import "QYSelectGroupViewController.h"
//#import "QYABGroupModel.h"

#import "QYAccount.h"
#import "QYAccountService.h"
#import "QYH5DatePicker.h"
#import "QYNavigationViewController.h"
#import "QYNetworkHelper.h"
#import "QYNetworkJsonProtocol.h"
#import "QYPhotoPickerHelper.h"
#import "QYURLHelper.h"
#import <MBProgressHUD/MBProgressHUD.h>

static NSString *ModelCode = @"ydzjMobile";

@interface PGCustomPlugin ()

@property(nonatomic, strong) NSTimer *timer;

@property(nonatomic, strong) QYNetworkHelper *networkHelper;

@end

@implementation PGCustomPlugin

//------------------------------------------------------------------------self--------------------------------------------------------------------------------------------

//选择人员
- (void)selectUsers:(PGMethod *)commands {
  if (commands) {
    //顺序为项目bridge中定义的参数顺序
    // CallBackid 异步方法的回调id，H5+ 会根据回调ID通知JS层运行结果成功或者失败
    NSString *cbId = [commands.arguments objectAtIndex:0];
    // userArrayString 用“,”分割
    NSString *userIds = [NSString stringWithFormat:@"%@",[commands.arguments objectAtIndex:1]];
    //是否为单选
    NSString *isSimpleCheck = [commands.arguments objectAtIndex:2];

      if ([userIds isNotNil]) {
          if ([userIds hasPrefix:@","]) {
              userIds = [userIds substringFromIndex:1];
          }
          
          if ([userIds hasSuffix:@","]) {
              userIds = [userIds substringToIndex:userIds.length - 1];
          }
      }else{
          userIds=@"";
      }

    [self personSelectWithUserIds:userIds callbackId:cbId];
  }
}
//选择时间
- (void)selectDateTime:(PGMethod *)commands {
  if (commands) {
    // CallBackid 异步方法的回调id，H5+ 会根据回调ID通知JS层运行结果成功或者失败
    NSString *cbId = [commands.arguments objectAtIndex:0];
    //默认时间
    NSString *defaultTime =
        [[commands.arguments objectAtIndex:1] objectAtIndex:0];
    NSString *defaultFormat =
        [[commands.arguments objectAtIndex:1] objectAtIndex:1];

    [self personSelectTime:defaultTime andcbId:cbId format:defaultFormat];
  }
}
//选择日期
- (void)showDateTimeHalf:(PGMethod *)commands {
  if (commands) {
    // CallBackid 异步方法的回调id，H5+ 会根据回调ID通知JS层运行结果成功或者失败
    NSString *cbId = [commands.arguments objectAtIndex:0];
    //默认时间
    NSString *defaultTime =
        [[commands.arguments objectAtIndex:1] objectAtIndex:0];
    NSString *defaultFormat =
        [[commands.arguments objectAtIndex:1] objectAtIndex:1];
    [self personSelectTime:defaultTime andcbId:cbId format:defaultFormat];
  }
}

//选择部门
- (void)selectGroup:(PGMethod *)commands {
  if (commands) {
    // CallBackid 异步方法的回调id，H5+ 会根据回调ID通知JS层运行结果成功或者失败
    NSString *cbId = [commands.arguments objectAtIndex:0];
    //已选群组
    NSString *defaultGroup = [commands.arguments objectAtIndex:1];
    //是否单选
    NSString *isSimpleCheck = [commands.arguments objectAtIndex:2];

    [self personSelectGroup:defaultGroup
                    andcbId:cbId
              isSimpleCheck:[isSimpleCheck boolValue]];
  }
}

//获取用户信息
- (NSData *)getLoginUserInfo:(PGMethod *)commands {
  QYAccount *account = [QYAccountService shared].defaultAccount;
  NSDictionary *userMessageDictionary = [[NSDictionary alloc]
      initWithObjects:[NSArray arrayWithObjects:account.userId,
                                                account.userName,
                                                account.groupId, nil]
              forKeys:[NSArray arrayWithObjects:@"userId", @"userName",
                                                @"groupId", nil]];

  //    NSDictionary *userMessageDictionary = [[NSDictionary alloc]
  //    initWithObjects:[NSArray
  //    arrayWithObjects:@"29115650",@"王红军",@"88599",nil] forKeys:[NSArray
  //    arrayWithObjects:@"userId",@"userName",@"groupId",nil]];
  //    groupId = 88599;
  //    userId = 29115650;
  //    userName = "王红军";
  return [self resultWithJSON:userMessageDictionary];
}

//接口配置化
- (NSData *)getBaseUrlPath:(PGMethod *)commands {
  if (commands) {
    //         //CallBackid 异步方法的回调id，H5+
    //         会根据回调ID通知JS层运行结果成功或者失败
    //        NSString* cbId = [commands.arguments objectAtIndex:0];
    //        //获取接口配置化moduleName
    NSString *configureStringmoduleName = [commands.arguments objectAtIndex:0];
    //获取接口配置化methodName
    NSString *configureStringmethodName = [commands.arguments objectAtIndex:1];

    NSString *configureURL =
        [[QYURLHelper shared] getUrlWithModule:configureStringmoduleName
                                        urlKey:configureStringmethodName];
    return [self resultWithString:configureURL];
  } else {
    return [self resultWithNull];
  }
}

//返回
- (NSData *)goBackDesk:(PGMethod *)commands {
  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goBackDesk"
                                                        object:nil];
  });
  return [self resultWithNull];
}

- (NSData *)appReady:(PGMethod *)commands {
  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"appReady"
                                                        object:nil];
  });
  return [self resultWithNull];
}

- (NSData *)log:(PGMethod *)commands {
  //NSLog(@"%@", [commands.arguments firstObject]);
  return [self resultWithNull];
}

- (void)goLogin:(PGMethod *)commands {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSString *adminName = [commands.arguments objectAtIndex:1];
    NSString *loginPwd = [commands.arguments objectAtIndex:2];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (param) {
      if (adminName) {
        [param setObject:adminName forKey:@"adminName"];
      }
      if (loginPwd) {
        [param setObject:loginPwd forKey:@"loginPwd"];
      }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goLogin"
                                                        object:self
                                                      userInfo:param];
  });
}
/**
 *  关闭键盘
 *
 *  @param commands
 */
- (void)closeKeyboard:(PGMethod *)commands {
  dispatch_async(dispatch_get_main_queue(), ^{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closeKeyboard"
                                                        object:nil];
  });
}

- (void)personSelectTime:(NSString *)defaultTime
                 andcbId:(NSString *)cbId
                  format:(NSString *)format {
    QYH5DatePicker *datePicker;
    if ([format isEqualToString:@"yyyy-MM-dd HH:mm:ss"]) {
        datePicker= [[QYH5DatePicker alloc]
                     initWithDefaulDate:defaultTime ? defaultTime : @""
                     datePickerMode:UIDatePickerModeDateAndTime
                     format:format];
    }else if([format isEqualToString:@"yyyy-MM-dd"]){
        datePicker= [[QYH5DatePicker alloc]
                     initWithDefaulDate:defaultTime ? defaultTime : @""
                     datePickerMode:UIDatePickerModeDate
                     format:format];
    }else if ([format isEqualToString:@"HH:mm:ss"]){
        datePicker= [[QYH5DatePicker alloc]
                     initWithDefaulDate:defaultTime ? defaultTime : @""
                     datePickerMode:UIDatePickerModeTime
                     format:format];
    }else{
        datePicker= [[QYH5DatePicker alloc]
                     initWithDefaulDate:defaultTime ? defaultTime : @""
                     datePickerMode:UIDatePickerModeDateAndTime
                     format:format];
    }

  [datePicker show];
  datePicker.datePickerChangeBlock = ^(NSString *date) {
    // 如果使用Array方式传递参数
    NSDictionary *dataSelectDictionary = [[NSDictionary alloc]
        initWithObjects:[NSArray arrayWithObjects:format, date, nil]
                forKeys:[NSArray arrayWithObjects:@"format", @"date", nil]];
    PDRPluginResult *result =
        [PDRPluginResult resultWithStatus:PDRCommandStatusOK
                      messageAsDictionary:dataSelectDictionary];

    [self toCallback:cbId withReslut:[result toJSONString]];
  };
}

- (void)personSelectWithUserIds:(NSString *)userIds
                     callbackId:(NSString *)callbackId {
  dispatch_async(dispatch_get_main_queue(), ^{
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    if (param) {
      if (userIds) {
        [param setObject:userIds forKey:@"userIds"];
      }
      if (callbackId) {
        [param setObject:callbackId forKey:@"callbackId"];
      }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"callUserPicker"
                                                        object:self
                                                      userInfo:param];
  });
}

- (void)personSelectWithUsers:(NSString *)data
                      andcbId:(NSString *)cbId
                isSimpleCheck:(BOOL)isSimpleCheck {
  /*
  QYABSelectViewController *selectViewController = [[QYABSelectViewController
  alloc] initWithSelectType:isSimpleCheck
  showItems:@[@(AddressBookTypeUnits),@(AddressBookTypeGroup)]
  isShowHiddenPerson:YES];

  if (data && [data isKindOfClass:[NSString class]])
  {
      NSArray *selectUserIds = [data componentsSeparatedByString:@","];
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
  }
  //    //NSLog(@"sda:%@",[self getCurrentRootViewController]);
  QYNavigationViewController *selectNav = [[QYNavigationViewController alloc]
  initWithRootViewController:selectViewController];
  [self presentViewController:selectNav animated:YES completion:nil];

  //选择完成回调
  [selectViewController setSelectCompleteBlock:^(NSArray *userArray)
  {
      NSMutableArray *personDetialDataArray = [[NSMutableArray alloc] init];
      for (QYABUserModel *userModel in userArray)
      {
          NSString *urlString = [[QYURLHelper shared]
  getUrlWithModule:@"ydzjMobile" urlKey:@"headPictureView"];
          NSString *photoUrlString;
          if ([userModel.photo isNotNil]) {
              photoUrlString = [NSString
  stringWithFormat:@"%@_clientType=wap&filePath=%@", urlString,
  userModel.photo];
          }else{
              photoUrlString = @"";
          }


          NSDictionary *dic = [[NSDictionary alloc] initWithObjects:[NSArray
  arrayWithObjects:userModel.userName,userModel.userId,userModel.photo, @"",nil]
  forKeys:[NSArray arrayWithObjects:@"userName",@"userId",
  @"userPhoto",@"picType",nil]];
          [personDetialDataArray addObject:dic];
      }

      PDRPluginResult *result = [PDRPluginResult
  resultWithStatus:PDRCommandStatusOK messageAsArray: personDetialDataArray];
      [self toCallback:cbId withReslut:[result toJSONString]];

     [self dismissViewControllerAnimated:YES completion:nil];
  }
  selectCancel:^
  {
      [self dismissViewControllerAnimated:YES completion:nil];
  }];
   */
}

- (void)personSelectGroup:(NSString *)defaultGroup
                  andcbId:(NSString *)cbId
            isSimpleCheck:(BOOL)isSimpleCheck {
  NSArray *selectedGroupArray;
  if (defaultGroup) {
    selectedGroupArray = [NSArray
        arrayWithArray:[defaultGroup componentsSeparatedByString:@","]];
  }

  QYSelectGroupViewController *unknowDetailVC = [
      [QYSelectGroupViewController alloc]
      initWithSelectGropuArray:selectedGroupArray
      inSingleChoose:isSimpleCheck
      finishSelectArrays:^(NSArray *finishSelectArray) {
//        NSLog(@"选择群组的人员个数:%lu",
//              (unsigned long)finishSelectArray.count);
        NSMutableArray *personDetialDataArray = [[NSMutableArray alloc] init];

        [finishSelectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx,
                                                        BOOL *stop) {
          QYABGroupModel *model = obj;
          NSDictionary *dic = [[NSDictionary alloc]
              initWithObjects:[NSArray arrayWithObjects:model.groupId,
                                                        model.groupName, nil]
                      forKeys:[NSArray arrayWithObjects:@"groupId",
                                                        @"groupName", nil]];
          [personDetialDataArray addObject:dic];
        }];

        // 如果使用Array方式传递参数
        PDRPluginResult *result =
            [PDRPluginResult resultWithStatus:PDRCommandStatusOK
                               messageAsArray:personDetialDataArray];

        [self toCallback:cbId withReslut:[result toJSONString]];

        [self dismissViewControllerAnimated:YES completion:nil];
      }
      cancelSelect:^(NSString *cancelString) {
        [self dismissViewControllerAnimated:YES completion:nil];
      }];
  QYNavigationViewController *nav = [[QYNavigationViewController alloc]
      initWithRootViewController:unknowDetailVC];
  [self presentViewController:nav animated:YES completion:nil];
}
//------------------------------------------------------------------------end--------------------------------------------------------------------------------------------
- (void)localMessage:(PGMethod *)commands {
  if (commands) {
    // CallBackid 异步方法的回调id，H5+ 会根据回调ID通知JS层运行结果成功或者失败
    _locationCbId = nil;
    _locationCbId = [commands.arguments objectAtIndex:0];
    if (!_locService) {
      _locService = nil;
      _locService = [[BMKLocationService alloc] init];
      _locService.delegate = self;
    }
    [_locService startUserLocationService];
  }
}

- (void)stopUserLocationService:(PGMethod *)commands {
  if (commands) {
    //这里关闭locationservice
    [_locService stopUserLocationService];
    _locService = nil;
    _isSearchNearSuccess = NO;
    _codeSearch.delegate = nil;
    _codeSearch = nil;
  }
}
/**
 *在将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser {
  //NSLog(@"将要开启定位");
}

/**
 *在停止定位后，会调用此函数
 */
- (void)didStopLocatingUser {
  //NSLog(@"停止定位");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
  //NSLog(@"用户方向更新");
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
  @try {
    //NSLog(@"用户位置更新后");
    CLLocationCoordinate2D coordinate;
    coordinate = userLocation.location.coordinate;
    BMKLocationViewDisplayParam *displayParam;
    displayParam.locationViewImgName = @"chat_MapSelect";

    if (!_isSearchNearSuccess) {
      _isSearchNearSuccess = YES;
      //_mapView.centerCoordinate = coordinate;

      if (userLocation.location != nil) {
        BMKReverseGeoCodeOption *codeOption =
            [[BMKReverseGeoCodeOption alloc] init];
        codeOption.reverseGeoPoint = coordinate;

        _codeSearch = [[BMKGeoCodeSearch alloc] init];
        _codeSearch.delegate = self;

        BOOL flag = [_codeSearch reverseGeoCode:codeOption];
        if (flag) {
          //NSLog(@"反编译检索发送成功");
        } else {
          //NSLog(@"反编译检索发送失败");
        }
      }
    }
  } @catch (NSException *exception) {
    //NSLog(@"excepton: %@", exception);
  }
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error {
  //NSLog(@"定位失败");
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeResult *)result
                        errorCode:(BMKSearchErrorCode)error {
  @try {
    if (error == BMK_SEARCH_NO_ERROR) {
      //在此处理正常结果
      //NSLog(@"%@", result.address);
      [_locService stopUserLocationService];
      _isSearchNearSuccess = NO;

      PDRPluginResult *plugResult =
          [PDRPluginResult resultWithStatus:PDRCommandStatusOK
                            messageAsString:result.address];
      [self toCallback:_locationCbId withReslut:[plugResult toJSONString]];
    } else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD) {
      //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
      // result.cityList;
      //NSLog(@"起始点有歧义");
    } else {
      //NSLog(@"抱歉，未找到结果");
    }
  } @catch (NSException *exception) {
    //NSLog(@"excepton: %@", exception);
  }
}
- (void)sendDidi:(PGMethod *)commands {
  //NSLog(@"commands===%@", commands.arguments);
  NSString *jsonString = commands.arguments[1];

  NSData *jsonData =
      [commands.arguments[1] dataUsingEncoding:NSUTF8StringEncoding];
  NSError *errer;
  NSDictionary *dict =
      [NSJSONSerialization JSONObjectWithData:jsonData
                                      options:NSJSONReadingMutableContainers
                                        error:&errer];

  QYAddDIDIModel *addDiDiModel =
      [[QYAddDIDIModel alloc] initWithDictionary:dict error:&errer];

  QYDiDiNewRemindViewController *newRemindVC =
      [[QYDiDiNewRemindViewController alloc] init];
  newRemindVC.addDiDiModel = addDiDiModel;

  QYNavigationViewController *nav = [[QYNavigationViewController alloc]
      initWithRootViewController:newRemindVC];
  [self presentViewController:nav animated:YES completion:nil];
}

/**
 *  拍照
 *
 *  @param commands
 */
- (void)takePhoto:(PGMethod *)commands {
  NSString *cbId = [commands.arguments objectAtIndex:0];

  [[QYPhotoPickerHelper shared]
      showActionSheetInView:self.rootViewController.view
      fromController:self.rootViewController
      completion:^(UIImage *image) {
        //        0、需要设置一个定时器
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(countAction)
                                                userInfo:nil
                                                 repeats:YES];

        //        1、图片上传到指定的服务器
        [self uploadPhotoActionWithImage:image
            Success:^(NSString *alert, NSString *jsonData) {
              //        2、上传成功，服务器返回的json数据重新给js服务端，给予提示
              PDRPluginResult *plugResult =
                  [PDRPluginResult resultWithStatus:PDRCommandStatusOK
                                    messageAsString:jsonData];
              [self toCallback:cbId withReslut:[plugResult toJSONString]];
              [self dismissViewControllerAnimated:YES completion:nil];
            }
            failure:^(NSString *alert) {
              [self toCallback:cbId withReslut:@"上传失败"];
              [self dismissViewControllerAnimated:YES completion:nil];
            }];

        //        3、规定时间内拿不到上传返回的json数据强制去掉加载框，给予提示

      }
      cancelBlock:^{
        [self dismissViewControllerAnimated:YES completion:nil];
      }];
}

//监控上传的时间
- (void)countAction {
  static int count;
  count++;
  if (count >= 20) {
    [_networkHelper hideHUD];
    count = 0;
    [_timer invalidate];
  }
}

//上传图片
- (void)uploadPhotoActionWithImage:(UIImage *)image
                           Success:(void (^)(NSString *alert,
                                             NSString *jsonData))success
                           failure:(void (^)(NSString *alert))failure {
  QYAccount *account = [[QYAccountService shared] defaultAccount];
  if (!image) {
    [QYDialogTool showDlg:@"图片不能为空！"];
    return;
  }

  [self uploadUserPhoto:image
      userId:account.userId
      companyId:account.companyId
      fileName:@"fileupload"
      success:^(NSString *responseString) {
        success(@"上传成功", responseString);
      }
      failure:^(NSString *alert) {
        failure(@"上传失败");
      }];
}

//上传头像
- (void)uploadUserPhoto:(UIImage *)image
                 userId:(NSString *)userId
              companyId:(NSString *)companyId
               fileName:(NSString *)fileName
                success:(void (^)(NSString *responseString))success
                failure:(void (^)(NSString *alert))failure {
  //    NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode
  //    urlKey:@"headPictureUpload"];
  NSString *urlString = @"http://218.206.244.202:38080/fileServer/upload?";
  //    NSString *urlString = @"http://10.100.6.140:10000/fileServer/upload?";
  //NSLog(@"urlString==%@", urlString);

  NSDictionary *parameters = @{
    @"userId" : userId,
    @"companyId" : companyId,
    @"moduleCode" : @"crm",
    @"origin" : @"app"
  };

  _networkHelper = [[QYNetworkHelper alloc] init];
  _networkHelper.parseDelegate = [QYNetworkJsonProtocol new];

  [_networkHelper showHUDAtView:nil message:@"正在上传中..."];

  [_networkHelper upload:urlString
      fileData:UIImagePNGRepresentation(image)
      fileName:fileName
      mimeType:@"image/png"
      parameters:parameters
      success:^(QYNetworkResult *result) {
        if (result.statusCode == NetworkResultStatusCodeSuccess) {
          success(result.result);
        } else if (result.statusCode == NetworkResultStatusCodeNoData) {
          success(result.result);
        } else {
          failure(result.errMessage);
        }
      }
      failure:^(NetworkErrorType errorType) {
        if (errorType == NetworkErrorTypeNoNetwork) {
          failure(ErrorNoNetworkAlert);
        }
        if (errorType == NetworkErrorType404) {
          NSString *errMessage =
              [NSString stringWithFormat:@"%s :404", __FUNCTION__];
          failure(Error404Alert);
        }
      }];
}

/**
 *  显示等待框
 *
 *  @param commands text
 */
- (void)showWaiting:(PGMethod *)commands {
  NSString *message = [commands.arguments firstObject];
  UIWindow *window = [UIApplication sharedApplication].delegate.window;
  //    [MBProgressHUD showHUDAddedTo:window animated:YES];
  MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
  hud.removeFromSuperViewOnHide = YES;
  [window addSubview:hud];
  if (message) {
    hud.labelText = message;
  }
  [hud show:YES];
}
/**
 *  关闭等待框
 *
 *  @param commands
 */
- (void)closeWaiting:(PGMethod *)commands {
  UIWindow *window = [UIApplication sharedApplication].delegate.window;
  [MBProgressHUD hideAllHUDsForView:window animated:YES];
}
@end
