//
//  QYNewsListViewController.h
//  QYBaseProject
//
//  Created by quanya on 15-6-30.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYTableViewController.h"

/**
 *  分享号栏目，标记已读成功
 */
static NSString *ShareNumberColumnMarkAlreadyRead = @"ShareNumberColumnMarkAlreadyRead";

@interface QYNewsListViewController : QYTableViewController

//判断是不是点击推送进入
@property (nonatomic , assign) BOOL isPushEnter;


@end
