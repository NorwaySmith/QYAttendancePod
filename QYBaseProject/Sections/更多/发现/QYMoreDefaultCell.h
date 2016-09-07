//
//  QYMoreDefaultCell.h
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYMoreModel.h"

@interface QYMoreDefaultCell : UITableViewCell

@property (nonatomic,strong) QYMoreModel *moreModel;

@property (nonatomic,assign) long section;
@property (nonatomic,assign) long row;

@end
