//
//  QYAnnexDownloadDetailViewController.m
//  QYBaseProject
//
//  Created by 田 on 15/7/23.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYAnnexDownloadDetailViewController.h"
#import "QYTheme.h"
#import "Masonry.h"
#import "QYAnnexDownloadIconHelper.h"
#import "QYAnnexDownloadHelper.h"
/**
 *  附件图标
 */
static CGFloat const iconImageView_top_padding = 80;
static CGFloat const iconImageView_width = 86;
static CGFloat const iconImageView_height = 99;

static CGFloat const titleLabel_top_padding = 15;
static CGFloat const titleLabel_left_padding = 30;
static CGFloat const titleLabel_height = 40;

static CGFloat const sizeLabel_top_padding = 10;
static CGFloat const sizeLabel_left_padding = 30;
static CGFloat const sizeLabel_height = 20;

static CGFloat const progressView_top_padding = 35;
static CGFloat const progressView_left_padding = 30;
static CGFloat const progressView_right_padding = 10;
static CGFloat const progressView_height = 2;

static CGFloat const startButton_right_padding = 30;
static CGFloat const startButton_height = 25;

static CGFloat const progressLabel_top_padding = 10;
static CGFloat const progressLabel_right_padding = 30;
static CGFloat const progressLabel_height = 20;

static CGFloat const downloadButton_top_padding = 25;
static CGFloat const downloadButton_height = 40;
static CGFloat const downloadButton_width = 145;

static NSString *const downloadButtonTitleUnDownload = @"下载";
static NSString *const downloadButtonTitleDownloading = @"下载中...";
static NSString *const downloadButtonTitleDownloadDone = @"打开附件";
static NSString *const downloadButtonTitleDownloadPause = @"已暂停";

@interface QYAnnexDownloadDetailViewController ()<UIDocumentInteractionControllerDelegate>

@property(nonatomic,strong)UIImageView                      *iconImageView;
@property(nonatomic,strong)UILabel                          *titleLabel;
@property(nonatomic,strong)UILabel                          *sizeLabel;
@property(nonatomic,strong)UIProgressView                   *progressView;
@property(nonatomic,strong)UIButton                         *startButton;
@property(nonatomic,strong)UILabel                          *progressLabel;
@property(nonatomic,strong)UIButton                         *downloadButton;
@property(nonatomic,strong)QYAnnexDownloadHelper            *annexDownloadHelper;
@property(nonatomic,strong)UIDocumentInteractionController  *documentInteractionController;

@end

@implementation QYAnnexDownloadDetailViewController
#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UI
-(void)configUI {
    self.iconImageView = [[UIImageView alloc] init];
    [self.view addSubview:_iconImageView];
    
    self.titleLabel = [[UILabel alloc] init];
    _titleLabel.font = [UIFont baseTextLarge];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.numberOfLines = 2;
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_titleLabel];
    
    self.sizeLabel = [[UILabel alloc] init];
    _sizeLabel.font = [UIFont baseTextMiddle];
    _sizeLabel.textColor = [UIColor themeAnnexSizeColor];
    _sizeLabel.textAlignment = NSTextAlignmentCenter;
    _sizeLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_sizeLabel];
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    _progressView.progress = 0;
    [self.view addSubview:_progressView];
    
    self.startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startButton setImage:[UIImage imageNamed:@"Annex_startDownload"] forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_startButton];

    self.progressLabel = [[UILabel alloc] init];
    _progressLabel.font = [UIFont baseTextMiddle];
    _progressLabel.textColor = [UIColor themeAnnexSizeColor];
    _progressLabel.textAlignment = NSTextAlignmentCenter;
    _progressLabel.backgroundColor = [UIColor clearColor];
    _progressLabel.text = @"0K/0K";
    [self.view addSubview:_progressLabel];
    
    self.downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downloadButton setBackgroundImage:[UIImage imageNamed:@"Annex_download_bg"] forState:UIControlStateNormal];
    [_downloadButton setBackgroundImage:[UIImage imageNamed:@"Annex_download_bgH"] forState:UIControlStateHighlighted];
    [_downloadButton setTitle:downloadButtonTitleUnDownload forState:UIControlStateNormal];
    [_downloadButton setTitleColor:[UIColor baseTextBlack] forState:UIControlStateNormal];
    [_downloadButton addTarget:self action:@selector(downloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_downloadButton];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(@(iconImageView_top_padding));
         make.width.equalTo(@(iconImageView_width));
         make.height.equalTo(@(iconImageView_height));
         make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(_iconImageView.mas_bottom).offset(titleLabel_top_padding);
         make.left.equalTo(@(titleLabel_left_padding));
         make.right.equalTo(@(-titleLabel_left_padding));
         make.height.equalTo(@(titleLabel_height));
    }];
    
    [_sizeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(_titleLabel.mas_bottom).offset(sizeLabel_top_padding);
         make.left.equalTo(@(sizeLabel_left_padding));
         make.right.equalTo(@(-sizeLabel_left_padding));
         make.height.equalTo(@(sizeLabel_height));
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(_sizeLabel.mas_bottom).offset(progressView_top_padding);
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
    
    [_progressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(_progressView.mas_top).offset(progressLabel_top_padding);
         make.left.equalTo(@(progressLabel_right_padding));
         make.right.equalTo(@(-progressLabel_right_padding));
         make.height.equalTo(@(progressLabel_height));
    }];
    
    [_downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.equalTo(_progressLabel.mas_bottom).offset(downloadButton_top_padding);
         make.centerX.equalTo(self.view.mas_centerX);
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
-(void)downloadButtonClick:(id)sender {
    UIButton *downloadButton = sender;
    if([[downloadButton currentTitle] isEqualToString:downloadButtonTitleUnDownload]) {
        [self startDownload];
        return;
    }
  
    if([[downloadButton currentTitle] isEqualToString:downloadButtonTitleDownloadDone]) {
        NSURL *URL = [NSURL fileURLWithPath:[_annexDownloadHelper targetPath:_annexDownloadModel]];
        if (URL) {
            self.documentInteractionController = [UIDocumentInteractionController
                                                                interactionControllerWithURL:URL];
            [self.documentInteractionController setDelegate:self];
            [self.documentInteractionController presentPreviewAnimated:YES];
        }
        return;
    }
}
/**
 *  开始下载
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
    
    __weak QYAnnexDownloadDetailViewController *wself=self;
    /**
     *  下载失败
     */
    _annexDownloadHelper.downloadFailureBlock=^(NSString *filePath) {
        [wself restoreDefaultUI];
    };
    /**
     *  下载成功
     */
    _annexDownloadHelper.downloadSuccessBlock=^(NSString *filePath) {
        [wself downloadDoneUI];
    };
    /**
     *  下载进度
     */
    _annexDownloadHelper.downloadProgressiveBlock=^(long long  totalBytesRead,long long  totalBytesExpected) {
        wself.progressLabel.text = [NSString stringWithFormat:@"%lldK/%lldK",totalBytesRead/1024,totalBytesExpected/1024];
        wself.progressView.progress = ((CGFloat)totalBytesRead)/((CGFloat)totalBytesExpected);
    };
}
#pragma mark - private methods
/**
 *  下载暂停时界面控制
 */
-(void)downloadPauseUI {
    [_downloadButton setTitle:downloadButtonTitleDownloadPause forState:UIControlStateNormal];
    [_downloadButton setBackgroundImage:nil forState:UIControlStateNormal];
    _progressView.hidden = NO;
    _progressLabel.hidden = NO;
    _startButton.hidden = NO;
    [_startButton setImage:[UIImage imageNamed:@"Annex_startDownload"] forState:UIControlStateNormal];
}
/**
 *  下载中界面控制
 */
-(void)downloadingUI {
    [_downloadButton setTitle:downloadButtonTitleDownloading forState:UIControlStateNormal];
    [_downloadButton setBackgroundImage:nil forState:UIControlStateNormal];
    _progressView.hidden = NO;
    _progressLabel.hidden = NO;
    _startButton.hidden = NO;
    [_startButton setImage:[UIImage imageNamed:@"Annex_pauseDownload"] forState:UIControlStateNormal];
}
/**
 *  下载完成界面控制
 */
-(void)downloadDoneUI {
    _progressView.hidden = YES;
    _progressLabel.hidden = YES;
    _startButton.hidden = YES;
    [_downloadButton setTitle:downloadButtonTitleDownloadDone forState:UIControlStateNormal];
    [_downloadButton setBackgroundImage:[UIImage imageNamed:@"Annex_download_bg"] forState:UIControlStateNormal];
}
/**
 *  UI恢复默认状态
 */
-(void)restoreDefaultUI {
    _progressView.hidden = YES;
    _progressLabel.hidden = YES;
    _startButton.hidden = YES;
    [_downloadButton setTitle:downloadButtonTitleUnDownload forState:UIControlStateNormal];
    [_downloadButton setBackgroundImage:[UIImage imageNamed:@"Annex_download_bg"] forState:UIControlStateNormal];
}

#pragma mark - getters and setters
-(void)setAnnexDownloadModel:(QYAnnexDownloadModel *)annexDownloadModel {
    _annexDownloadModel = annexDownloadModel;
    [self configUI];
    self.annexDownloadHelper = [[QYAnnexDownloadHelper alloc] init];
    if ([_annexDownloadHelper isExist:_annexDownloadModel]) {
        [self downloadDoneUI];
    } else {
        [self restoreDefaultUI];
    }
    
    _iconImageView.image = [QYAnnexDownloadIconHelper bigIconWithAnnexName:_annexDownloadModel.attachmentName];
    _titleLabel.text = _annexDownloadModel.attachmentName;
    _sizeLabel.text = _annexDownloadModel.fileSize;
}

@end
