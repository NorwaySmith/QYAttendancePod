//
//  QYAnnexDownloadHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/8/4.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYAnnexDownloadHelper.h"
#import "AFDownloadRequestOperation.h"
#import "IOSTool.h"
@interface QYAnnexDownloadHelper()
@property(nonatomic,strong)AFDownloadRequestOperation *operation;

@end
@implementation QYAnnexDownloadHelper
+ (QYAnnexDownloadHelper *)shared
{
    static dispatch_once_t pred;
    static QYAnnexDownloadHelper *sharedInstance = nil;
    
    dispatch_once(&pred, ^
                  {
                      sharedInstance = [[self alloc] init];
                  });
    
    return sharedInstance;
}

-(NSString*)targetPath:(QYAnnexDownloadModel*)annexDownloadModel{
    NSString *path = [[QYSandboxPath documentPath] stringByAppendingPathComponent:@"annex"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        BOOL isSuccess = [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        //NSLog(@"%d",isSuccess);
    }
    return [NSString stringWithFormat:@"%@/%@",path,annexDownloadModel.attachmentName];
}
-(void)startDownload:(QYAnnexDownloadModel*)annexDownloadModel{
    _annexDownloadState=AnnexDownloadStateDownloadIng;
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:annexDownloadModel.url]];
    self.operation=[[AFDownloadRequestOperation alloc] initWithRequest:request targetPath:[self targetPath:annexDownloadModel] shouldResume:YES];
    __weak QYAnnexDownloadHelper *wself=self;

    [_operation setProgressiveDownloadProgressBlock:^(AFDownloadRequestOperation *operation, NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        if (wself.downloadProgressiveBlock) {
            wself.downloadProgressiveBlock(totalBytesReadForFile,totalBytesExpectedToReadForFile);
        }
    }];
    [_operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (wself.downloadSuccessBlock) {
            wself.downloadSuccessBlock([wself targetPath:annexDownloadModel]);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [QYDialogTool showDlg:@"网络错误，请检查网络"];
        if (wself.downloadFailureBlock) {
            wself.downloadFailureBlock([wself targetPath:annexDownloadModel]);
        }
    }];
    [_operation start];

}
-(void)pause{
    _annexDownloadState=AnnexDownloadStatePause;

    [_operation pause];
}
-(BOOL)isExist:(QYAnnexDownloadModel*)annexDownloadModel{
    NSString *filePath=[self targetPath:annexDownloadModel];
    BOOL isExist=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    return isExist;
}

@end
