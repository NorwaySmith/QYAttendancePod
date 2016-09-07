//
//  QYAnnexDownloadModel.h
//  QYBaseProject
//
//  Created by 田 on 15/7/23.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <Foundation/Foundation.h>
//attachmentName = "\U4efb\U52a1\U7ba1\U74060701.txt";
//fileSize = "249.00B";
//suffix = filetxt;
//url = "http://101.200.31.143:80/filemanager/downfile.action?_clientType=wap&attachmentId=1538";
//viewUrl = "http://101.200.31.143:80/filemanager/htmlPreviewWap.action?_clientType=wap&attachId=1538";
@interface QYAnnexDownloadModel : NSObject
/**
 *  附件名
 */
@property(nonatomic,copy)NSString *attachmentName;
/**
 *  附件大小
 */
@property(nonatomic,copy)NSString *fileSize;
/**
 *  附件后缀
 */
@property(nonatomic,copy)NSString *suffix;
/**
 *  附件下载url
 */
@property(nonatomic,copy)NSString *url;
/**
 *  附件预览url
 */
@property(nonatomic,copy)NSString *viewUrl;

@end
