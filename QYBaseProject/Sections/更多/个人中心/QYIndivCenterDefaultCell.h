//
//  QYIndivCenterDefaultCell.h
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYIndivCenterModel.h"

@interface QYIndivCenterDefaultCell : UITableViewCell


@property (nonatomic,strong)QYIndivCenterModel *IndivCenterModel;

@property (nonatomic,assign) long section;
@property (nonatomic,assign) long row;

@end
