//
//  QYAttendanceDetailOnCellView.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYAttendanceEnum.h"

@interface QYAttendanceDetailOnCellView : UIView

@property(nonatomic, assign)QYAttendanceDetailOnCellViewType type;
@property (nonatomic, strong)NSDictionary *dataDictionary;

@end
