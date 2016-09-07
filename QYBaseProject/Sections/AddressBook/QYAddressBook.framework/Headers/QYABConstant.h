//
//  QYABConstant.h
//  QYBaseProject
//
//  Created by 田 on 16/1/6.
//  Copyright © 2016年 田. All rights reserved.
//
/**
 *  通讯录配置、通用常量
 */

#import "QYABEnum.h"
#import "QYABProtocol.h"
#ifndef QYABConstant_h
#define QYABConstant_h
/**
 *  根据key从语系文件中查询
 */
#define QYABLocaleString(key)  NSLocalizedStringFromTable(key, @"AddressBook", nil)

#pragma mark - config



#define AddressBookUnits                 @"单位通讯录"
#define AddressBookPrivate               @"个人通讯录"
#define AddressBookGroup                 @"群   组"
#define AddressBookCommonUser            @"可能联系人"
#define AddressBookPossibleUser          @"常用联系人"
#define AddressBookCommonGroup           @"常用群组"

//选择人员模块名
#define AddressBookPicker_Base           @"AddressBookPicker_Base"
#define AddressBookPicker_IM             @"AddressBookPicker_IM"            // IM模块
#define AddressBookPicker_DIDI           @"AddressBookPicker_DIDI"          // 嘀嘀提醒
#define AddressBookPicker_NoticeMsg      @"AddressBookPicker_NoticeMsg"     // 语音通知
#define AddressBookPicker_Questionnaire  @"AddressBookPicker_Questionnaire" // 问卷
#define AddressBookPicker_Conference     @"AddressBookPicker_Conference"    // 电话会议
#define AddressBookPicker_Recommend      @"AddressBookPicker_Recommend"     // 推荐
#define AddressBookPicker_WorkFlow       @"AddressBookPicker_WorkFlow"      // 审批
#define AddressBookPicker_Log            @"AddressBookPicker_Log"           // 日志
#define AddressBookPicker_quicklyDi      @"AddressBookPicker_quicklyDi"     // 快嘀

//QYABQuickPickerViewController
#define kTableviewConfigurationSectionKey   @"ConfigurationSection"
#define kTableviewCommonUserSectionKey      @"CommonUserSection"
#define kTableviewCommonGroupSectionKey     @"CommonGroupSection"
#define kTableviewCellConfigurationIdentify @"ConfigurationCellIdentify"
#define kTableviewCellCommonUserIdentify    @"CommonUserCellIdentify"
#define kTableviewCellCommonGroupIdentify   @"CommonGroupCellIdentify"
#define kTableviewCellErrorIdentify         @"ErrorCellIdentify"
#define KTableViewCellSearchResultIdentify  @"SearchResultCellIdentify"

//人员选择，常用联系人数及群组个数 限定
#define kMaxCommonUserCount                 10
#define kMaxCommonGroupCount                5

/**
 *  电话会议新设计 调整已选人页面文字   2016-01-27
 */
#define kMeetingSelectedViewControllerTitle             @"再次发起会议"
#define KMeetingSelectedViewControllerAddUserString     @"添加新参会人"
#define KMeetingSelectedViewControllerAlertString       @"至少需要选择一名参会人"
#define kMeetingSelectedViewControllerTitleFromIM       @"发起电话会议"

#pragma mark - notification
/**
 *  基础数据更新完成
 */
#define kABBasicDataDoneNotification       @"com.quanya.basicDataDone"
/**
 *  基础数据更新失败
 */
#define kABBasicDataFaildNotification       @"com.quanya.basicDataFaild"

/**
 *  个人通讯录更新完成
 */
#define kABLocalPhoneDoneNotification       @"com.quanya.localPhoneDoneNotification"


/**
 *  群组中数据改变
 */
#define kABGroupChangeNotification       @"com.quanya.groupChange"
/**
 *  个人中心中更新自己的数据
 */
#define kABUpdateSelfNotification        @"com.quanya.updateSelf"
/**
 *  选择群租变化通知
 */
#define SELECT_GROUP_UPDATE @"SELECT_GROUP_UPDATE"

#endif
