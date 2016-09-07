//
//  QYAnnexDownloadView.h
//  QYBaseProject
//
//  Created by 田 on 15/7/23.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYAnnexDownloadModel.h"
@interface QYAnnexDownloadView : UIView
/**
 *  需要传入navigationController
 */
@property(nonatomic,weak)UINavigationController *navigationController;
/**
 *  初始化附件下载view
 *
 *  @param modelArray 附件数据模型数组
 */
-(instancetype)initWithFrame:(CGRect)frame modelArray:(NSArray*)modelArray;
@end
