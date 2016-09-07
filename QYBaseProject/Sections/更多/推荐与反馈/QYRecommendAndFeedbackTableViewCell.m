//
//  QYRecommendAndFeedbackTableViewCell.m
//  QYBaseProject
//
//  Created by dzq on 15/6/30.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYRecommendAndFeedbackTableViewCell.h"
#import "QYTheme.h"


@interface QYRecommendAndFeedbackTableViewCell()

//@property (nonatomic,strong) UIImageView *logoImageView;
//@property (nonatomic,strong) UILabel *titleLabel;
//@property (nonatomic,strong) UIImageView *nextImageView;

@end


@implementation QYRecommendAndFeedbackTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.textLabel.font = [UIFont themeCellTextLabelFont];
    }
    return self;
}


- (void)setRecommendAndFeedback:(QYRecommendAndFeedbackModel *)recommendAndFeedback
{
    _recommendAndFeedback = recommendAndFeedback;
    
    //给cell中UI赋值
    self.imageView.image = _recommendAndFeedback.logoImage;
    
    self.textLabel.text = _recommendAndFeedback.titleStr;
    
}



@end
