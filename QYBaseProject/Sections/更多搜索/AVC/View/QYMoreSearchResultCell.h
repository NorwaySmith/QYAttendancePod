//
//  QYMoreSearchResultCell.h
//  QYBaseProject
//
//  Created by lin on 15/6/25.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QYMoreSearchCompanyModel.h"

@interface QYMoreSearchResultCell : UITableViewCell

@property (nonatomic, strong) QYMoreSearchCompanyModel * companyModel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;

@end
