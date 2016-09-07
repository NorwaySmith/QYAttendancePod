//
//  QYAnnexDownloadHelper.h
//  QYBaseProject
//
//  Created by 田 on 15/8/4.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYAnnexDownloadModel.h"
//下载状态
typedef NS_ENUM(NSUInteger, AnnexDownloadState)
{
    AnnexDownloadStateDownloadIng = 0,//下载中
    AnnexDownloadStatePause = 1//暂停
};
@interface QYAnnexDownloadHelper : NSObject
/**
 *  下载成功
 */
@property(nonatomic,copy)void (^downloadSuccessBlock)(NSString *filePath);
/**
 *  下载失败
 */
@property(nonatomic,copy)void (^downloadFailureBlock)(NSString *filePath);
/**
 *  下载进度
 */
@property(nonatomic,copy)void (^downloadProgressiveBlock)(long long  totalBytesRead,long long  totalBytesExpected);
/**
 *  附件当前状态
 */
@property(nonatomic,assign)AnnexDownloadState annexDownloadState;
/**
 *  得到附件路径
 *
 *  @param annexDownloadModel
 *
 *  @return 附件路径
 */
-(NSString*)targetPath:(QYAnnexDownloadModel*)annexDownloadModel;
/**
 *  开始下载
 *
 *  @param annexDownloadModel
 */
-(void)startDownload:(QYAnnexDownloadModel*)annexDownloadModel;
/**
 *  是否存在，如果存在说明已经下载
 *
 *  @param annexDownloadModel
 *
 *  @return 是否存在
 */
-(BOOL)isExist:(QYAnnexDownloadModel*)annexDownloadModel;
/**
 *  暂停
 */
-(void)pause;
@end
