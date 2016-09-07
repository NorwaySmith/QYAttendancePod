//
//  QYAnnexDownloadImageDetailViewController.m
//  QYBaseProject
//
//  Created by 田 on 15/8/4.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYAnnexDownloadImageDetailViewController.h"
#import "QYTheme.h"
#import "Masonry.h"
#import "QYAnnexDownloadIconHelper.h"
#import "QYAnnexDownloadHelper.h"
#import "UIImageView+WebCache.h"
/**
 *  附件图标
 */
static CGFloat const iconImageView_top_padding = 0;
static CGFloat const iconImageView_left_padding = 0;
static CGFloat const iconImageView_bottom_padding = 80;

static CGFloat const bottomView_left_padding = 0;
static CGFloat const bottomView_bottom_padding = 0;

static CGFloat const progressLabel_top_padding = 8;
static CGFloat const progressLabel_left_padding = 30;
static CGFloat const progressLabel_height = 20;

static CGFloat const progressView_top_padding = 8;
static CGFloat const progressView_left_padding = 30;
static CGFloat const progressView_right_padding = 10;
static CGFloat const progressView_height = 2;

static CGFloat const startButton_right_padding = 30;
static CGFloat const startButton_height = 25;

static CGFloat const stateLabel_top_padding = 8;
static CGFloat const stateLabel_left_padding = 30;
static CGFloat const stateLabel_height = 20;

static CGFloat const downloadButton_height = 40;
static CGFloat const downloadButton_width = 145;

static NSString *const stateLabelUnDownload = @"下载";
static NSString *const stateLabelDownloading = @"下载中...";
static NSString *const stateLabelDownloadDone = @"打开附件";
static NSString *const stateLabelDownloadPause = @"已暂停";

@interface QYAnnexDownloadImageDetailViewController()<UIDocumentInteractionControllerDelegate>

@property(nonatomic,strong)UIImageView *iconImageView;

/**
 *  下部操作
 */
@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UIProgressView *progressView;
@property(nonatomic,strong)UIButton *startButton;
@property(nonatomic,strong)UILabel *progressLabel;
/**
 *  下载状态
 */
@property(nonatomic,strong)UILabel *stateLabel;

@property(nonatomic,strong)UIButton *downloadButton;
@property(nonatomic,strong)QYAnnexDownloadHelper *annexDownloadHelper;
@property(nonatomic,strong)UIDocumentInteractionController *documentInteractionController;
@end
@implementation QYAnnexDownloadImageDetailViewController
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"打开附件";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI
-(void)configUI{
    self.view.backgroundColor=[UIColor blackColor];
    
    self.iconImageView=[[UIImageView alloc] init];
    _iconImageView.backgroundColor=[UIColor blackColor];
    _iconImageView.image=[UIImage imageNamed:@"Annex_small_unknown"];
    [_iconImageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:_iconImageView];
    
    self.bottomView=[[UIView alloc] init];
    _bottomView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:_bottomView];
    

    self.progressView=[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.progress=0;
    [_bottomView addSubview:_progressView];
    
    self.startButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_startButton setImage:[UIImage imageNamed:@"Annex_startDownload"] forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_startButton];
    
    self.progressLabel=[[UILabel alloc] init];
    _progressLabel.font=[UIFont baseTextMiddle];
    _progressLabel.textColor=[UIColor themeAnnexSizeColor];
    _progressLabel.textAlignment=NSTextAlignmentCenter;
    _progressLabel.backgroundColor=[UIColor clearColor];
    _progressLabel.text=@"0K/0K";
    [_bottomView addSubview:_progressLabel];
    
    self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downloadButton setBackgroundImage:[UIImage imageNamed:@"Annex_download_bg"] forState:UIControlStateNormal];
    [_downloadButton setBackgroundImage:[UIImage imageNamed:@"Annex_download_bgH"] forState:UIControlStateHighlighted];
    [_downloadButton setTitle:@"下载" forState:UIControlStateNormal];
    [_downloadButton setTitleColor:[UIColor baseTextBlack] forState:UIControlStateNormal];
    [_downloadButton addTarget:self action:@selector(downloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_downloadButton];
    
    self.stateLabel = [[UILabel alloc] init];
    _stateLabel.font = [UIFont baseTextMiddle];
    _stateLabel.textColor = [UIColor themeAnnexTitleColor];
    _stateLabel.textAlignment = NSTextAlignmentCenter;
    _stateLabel.backgroundColor = [UIColor clearColor];
    _stateLabel.text = stateLabelUnDownload;
    [_bottomView addSubview:_stateLabel];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(@(iconImageView_top_padding));
         make.left.equalTo(@(iconImageView_left_padding));
         make.right.equalTo(@(iconImageView_left_padding));
         make.bottom.equalTo(@(-iconImageView_bottom_padding));
    }];
    
    
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.height.equalTo(@(iconImageView_bottom_padding));
         make.left.equalTo(@(bottomView_left_padding));
         make.right.equalTo(@(bottomView_left_padding));
         make.bottom.equalTo(@(bottomView_bottom_padding));
    }];
    
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(@(progressLabel_top_padding));
         make.left.equalTo(@(progressLabel_left_padding));
         make.right.equalTo(@(-progressLabel_left_padding));
         make.height.equalTo(@(progressLabel_height));
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(_progressLabel.mas_bottom).offset(progressView_top_padding);
         make.left.equalTo(@(progressView_left_padding));
         make.right.equalTo(_startButton.mas_left).offset(-progressView_right_padding);
         make.height.equalTo(@(progressView_height));
    }];
    
    [_startButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerY.equalTo(_progressView.mas_centerY);
         make.right.equalTo(@(-startButton_right_padding));
         make.width.equalTo(@(startButton_height));
         make.height.equalTo(@(startButton_height));
    }];
    [_stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(_progressView.mas_bottom).offset(stateLabel_top_padding);
         make.right.equalTo(@(-stateLabel_left_padding));
         make.left.equalTo(@(stateLabel_left_padding));
         make.height.equalTo(@(stateLabel_height));
    }];
    
    [_downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.centerX.equalTo(_bottomView.mas_centerX);
         make.centerY.equalTo(_bottomView.mas_centerY);
         make.width.equalTo(@(downloadButton_width));
         make.height.equalTo(@(downloadButton_height));
     }];
    
}
#pragma mark - UITableViewDelegate
#pragma mark - CustomDelegate
- (UIViewController *) documentInteractionControllerViewControllerForPreview:
(UIDocumentInteractionController *) controller {
    return self.navigationController;
}
#pragma mark - event response
-(void)startButtonClick:(id)sender{
    /**
     *  下载中
     */
    if (_annexDownloadHelper.annexDownloadState==AnnexDownloadStateDownloadIng) {
        [self downloadPauseUI];
        
        [_annexDownloadHelper pause];
        return;
    }
    /**
     *  暂停下载
     */
    if (_annexDownloadHelper.annexDownloadState==AnnexDownloadStatePause) {
        [self downloadingUI];
        
        [_annexDownloadHelper startDownload:_annexDownloadModel];
        return;
    }
    
}
-(void)downloadButtonClick:(id)sender{
    [self startDownload];
}
/**
 *  开始下载附件
 */
-(void)startDownload{
    if ([_annexDownloadHelper isExist:_annexDownloadModel]) {
        return;
    }
    [self downloadingUI];
    /**
     *  开始下载
     */
    [_annexDownloadHelper startDownload:_annexDownloadModel];
    
    __weak QYAnnexDownloadImageDetailViewController *wself=self;
    /**
     *  下载失败
     */
    _annexDownloadHelper.downloadFailureBlock=^(NSString *filePath){
        [wself restoreDefaultUI];
    };
    /**
     *  下载成功
     */
    _annexDownloadHelper.downloadSuccessBlock=^(NSString *filePath){
        [wself hideBottom];
    };
    /**
     *  下载进度
     */
    _annexDownloadHelper.downloadProgressiveBlock=^(long long  totalBytesRead,long long  totalBytesExpected){
        
        wself.progressLabel.text=[NSString stringWithFormat:@"%lldK/%lldK",totalBytesRead/1024,totalBytesExpected/1024];
        wself.progressView.progress=((CGFloat)totalBytesRead)/((CGFloat)totalBytesExpected);
    };
}
#pragma mark - private methods
/**
 *  下载暂停时界面控制
 */
-(void)downloadPauseUI{
    [_downloadButton setBackgroundImage:nil forState:UIControlStateNormal];
    _progressView.hidden=NO;
    _progressLabel.hidden=NO;
    _startButton.hidden=NO;
    [_startButton setImage:[UIImage imageNamed:@"Annex_startDownload"] forState:UIControlStateNormal];
    _stateLabel.text=stateLabelDownloadPause;

}
/**
 *  下载成功时隐藏下部工具栏
 */
-(void)hideBottom{
    _bottomView.hidden=YES;
    [_iconImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@(0));
    }];
}
/**
 *  图片为下载时的默认状态
 */
-(void)restoreDefaultUI{
    _iconImageView.hidden=NO;
    _bottomView.hidden=NO;
    _downloadButton.hidden=NO;
    _progressView.hidden=YES;
    _progressLabel.hidden=YES;
    _startButton.hidden=YES;
    _stateLabel.hidden=YES;
    _stateLabel.text=stateLabelDownloading;

}
/**
 *  下载中界面控制
 */
-(void)downloadingUI{
    _iconImageView.hidden=NO;
    _downloadButton.hidden=YES;
    _progressLabel.hidden=NO;
    _progressView.hidden=NO;
    _startButton.hidden=NO;
    _stateLabel.hidden=NO;
    _stateLabel.text=stateLabelDownloading;
    [_startButton setImage:[UIImage imageNamed:@"Annex_pauseDownload"] forState:UIControlStateNormal];
}
#pragma mark - getters and setters
-(void)setAnnexDownloadModel:(QYAnnexDownloadModel *)annexDownloadModel{
    _annexDownloadModel=annexDownloadModel;
    [self configUI];
    self.annexDownloadHelper=[[QYAnnexDownloadHelper alloc] init];
    if ([_annexDownloadHelper isExist:_annexDownloadModel]) {
        [self hideBottom];
        _iconImageView.image=[UIImage imageWithContentsOfFile:[_annexDownloadHelper targetPath:_annexDownloadModel]];
    }else{
        [self restoreDefaultUI];
        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:_annexDownloadModel.url] placeholderImage:[QYAnnexDownloadIconHelper bigIconWithAnnexName:_annexDownloadModel.attachmentName] options:SDWebImageProgressiveDownload];

    }
    
    
}

@end
