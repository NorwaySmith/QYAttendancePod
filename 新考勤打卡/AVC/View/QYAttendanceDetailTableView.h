//
//  QYAttendanceDetailTableView.h
//  QYBaseProject
//
//  Created by zhaotengfei on 16/6/7.
//  Copyright © 2016年 田. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QYAttendanceDetailTableView : UIView

//table数据
@property (nonatomic, strong)NSArray *dataArray;

@property (nonatomic ,copy)void (^ viewNotes)(NSDictionary *memoDictionary, BOOL isNoon);

@end
