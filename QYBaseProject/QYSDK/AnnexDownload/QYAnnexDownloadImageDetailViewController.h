//
//  QYAnnexDownloadImageDetailViewController.h
//  QYBaseProject
//
//  Created by 田 on 15/8/4.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYViewController.h"
#import "QYAnnexDownloadModel.h"

@interface QYAnnexDownloadImageDetailViewController : QYViewController
@property(nonatomic,strong)QYAnnexDownloadModel *annexDownloadModel;
/**
 *  开始下载附件
 */
-(void)startDownload;
@end
