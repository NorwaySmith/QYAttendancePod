//
//  QYAddDIDIModel.h
//  QYBaseProject
//
//  Created by 董卓琼 on 15/11/30.
//  Copyright © 2015年 田. All rights reserved.
//

/**
 *  嘀嘀模块 新建嘀嘀对象
 */

#import "JSONModel.h"

@interface QYAddDIDIModel : JSONModel

@property (nonatomic,  copy) NSString<Optional> *content;             //消息内容
@property (nonatomic,strong) NSNumber<Optional> *contentEidtable;     //消息内容是否可以编辑
@property (nonatomic,strong) NSNumber<Optional> *contentType;         //消息类型
@property (nonatomic,strong) NSNumber<Optional> *contentTypeEditable; //消息类型是否可以编辑

@property (nonatomic,  copy) NSString<Optional> *fromWhere;           //来源
@property (nonatomic,  copy) NSString<Optional> *moduleName;          //模块

@property (nonatomic,strong) NSNumber<Optional> *remindType;          //提醒方式
@property (nonatomic,strong) NSNumber<Optional> *remindTypeEditable;  //提醒类型是否可以编辑

@property (nonatomic,  copy) NSString<Optional> *systemName;          //项目名

@property (nonatomic,  copy) NSString<Optional> *userIds;             //用户ID
@property (nonatomic,strong) NSNumber<Optional> *userIdsEditable;     //用户ID是否可以编辑

@end
