//
//  QYAnnexDownloadCell.h
//  QYBaseProject
//
//  Created by 田 on 15/7/23.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYAnnexDownloadModel.h"
@class QYAnnexDownloadCell;
@protocol QYAnnexDownloadCellProtocol <NSObject>
@optional

- (void)operationButtonClick:(QYAnnexDownloadCell *)cell;
@end

@interface QYAnnexDownloadCell : UITableViewCell
@property(nonatomic,assign)id <QYAnnexDownloadCellProtocol>delegate;

@property(nonatomic,strong)QYAnnexDownloadModel *annexDownloadModel;
@end
