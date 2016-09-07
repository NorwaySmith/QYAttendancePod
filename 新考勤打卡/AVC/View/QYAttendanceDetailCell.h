//
//  QYAttendanceDetailCell.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYAttendanceDetailCell : UITableViewCell

@property (nonatomic, strong)NSDictionary *dataDictionary;

/**
 *  详情查看备注
 */
@property (nonatomic ,copy)void (^detailMemo)(NSDictionary *memoDictionary ,BOOL isNoon);
@end
