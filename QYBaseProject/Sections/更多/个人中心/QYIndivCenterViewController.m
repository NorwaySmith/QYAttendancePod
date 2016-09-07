//
//  QYIndivCenterViewController.m
//  QYBaseProject
//
//  Created by 田 on 15/6/8.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYIndivCenterViewController.h"
#import "QYIndivCenterAvatarCell.h"
#import "QYIndivCenterDefaultCell.h"
#import "QYIndivCenterViewModel.h"
#import "QYIndivCenterModel.h"
#import "IOSTool.h"
#import "MBProgressHUD.h"

#import "QYPersonalitySignatureViewController.h"

//#import "QYUpdateBasicData.h"
#import "QYAccount.h"
#import "QYAccountService.h"

#import "SDImageCache.h"
#import "SDWebImageManager.h"

#import "QYURLHelper.h"

#import <QYAddressBook/QYABDb.h>
//#import "QYABDb.h"

static NSString  *ModelCode          = @"ydzjMobile";

//区间距
static CGFloat const SectionFooterPadding = 6;
//static CGFloat const sectionHeaderPadding = 8;

static NSString *const IndivCenterDefaultCell = @"IndivCenterDefaultCell";
static NSString *const IndivCenterAvatarCell = @"IndivCenterAvatarCell";
static NSInteger const SexActionSheetTag = 1;
static NSInteger const PhotoActionSheetTag = 2;

@interface QYIndivCenterViewController ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,strong) QYIndivCenterViewModel *viewModel;
@property (nonatomic,strong) NSArray *modelArray;

@property (nonatomic,strong) QYIndivCenterModel *IndivCenterModel;

@end

@implementation QYIndivCenterViewController

#pragma mark - life cycle
- (void)dealloc
{
    
}
- (instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self = [super initWithStyle:style])
    {
        self.hidesBottomBarWhenPushed = YES;
        [self initializeViewModel];
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"个人中心";
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [self removeTableViewLine];
    self.tableView.separatorColor = [UIColor themeSeparatorLineColor];
    self.tableView.backgroundColor = [UIColor themeListBackgroundColor];

    
    
    [self.tableView registerClass:[QYIndivCenterDefaultCell class] forCellReuseIdentifier:IndivCenterDefaultCell];
    [self.tableView registerClass:[QYIndivCenterAvatarCell class] forCellReuseIdentifier:IndivCenterAvatarCell];
    
    [self assembleData];
    
    //获取自己信息
    [self getSelf];
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return SectionFooterPadding * 2;
    }
    return SectionFooterPadding;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
   return SectionFooterPadding;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    QYIndivCenterModel *moreModel = _modelArray[section][row];
    
    if (moreModel.indivCenterCellStyle == QYMoreCellStyleAvatar)
    {
        return ThemeListHeightDouble;
    }
    else
    {
        return ThemeListHeightSingle;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_modelArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_modelArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    QYIndivCenterModel *IndivCenterModel = _modelArray[section][row];
    
    if (IndivCenterModel.indivCenterCellStyle == QYMoreCellStyleAvatar)
    {
        QYIndivCenterAvatarCell *cell = [tableView dequeueReusableCellWithIdentifier:IndivCenterAvatarCell forIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //NSLog(@"self.userModel.photo===%@",self.userModel.photo);
        
        IndivCenterModel.imageUrl = self.userModel.photo;
        cell.IndivCenterModel = IndivCenterModel;
        
        return cell;
    }
    else
    {
        QYIndivCenterDefaultCell *cell = [tableView dequeueReusableCellWithIdentifier:IndivCenterDefaultCell  forIndexPath:indexPath];
        
        if (indexPath.section != 0)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if (indexPath.section == 0 && indexPath.row == 1)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (indexPath.section == 0 && (indexPath.row != 1))
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.section = indexPath.section;
            cell.row = indexPath.row;
        }
        
        cell.IndivCenterModel = IndivCenterModel;
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    self.IndivCenterModel = _modelArray[section][row];
    
    if (_IndivCenterModel.indivCenterCellStyle == QYMoreCellStyleAvatar)
    {
        //上传头像
        [self showPhotoActionSheet];
    }
    
    if (_IndivCenterModel.indivCenterCellStyle == QYMoreCellStyleDefault)
    {
        if ([_IndivCenterModel.leftString isEqualToString:@"性别"])
        {
            [self showSexActionSheet];
        }
        if ([_IndivCenterModel.leftString isEqualToString:@"个性签名"])
        {
            [self showInputController:_IndivCenterModel.rightString];
        }
    }
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}


#pragma mark - CustomDelegate
#pragma mark -- UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //NSLog(@"buttonIndex==%ld",(long)buttonIndex);
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        return;
    }
    if (actionSheet.tag == PhotoActionSheetTag) {
        if(actionSheet.cancelButtonIndex == buttonIndex) {
            return;
        }
        
        __weak QYIndivCenterViewController *wself = self;
        //NSLog(@"dzq====%ld",(long)buttonIndex);
        
        switch (buttonIndex) {
            case 0:
            {
                [[QYDevicePermission shared] systemCameraServiceCallBack:^(BOOL granted) {
                    if (granted) {
                        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
                            return;
                        }else{
                            [wself showImagePickerWithSourceType:UIImagePickerControllerSourceTypeCamera];
                        }
                    }
                }];
            }
                break;
            case 1:
            {
                [[QYDevicePermission shared] systemPhotoServiceCallBack:^(BOOL granted) {
                    if (granted) {
                        [wself showImagePickerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
                    }
                }];
            }
                break;
                
            default:
                break;
        }
    }
    
    if (actionSheet.tag == SexActionSheetTag) {
        if (buttonIndex != 2) {
            BOOL sex = NO;
            NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
            if ([title isEqualToString:@"男"]) {
                sex = YES;
            }

            //数据层
            _viewModel.sex = sex;
            [_viewModel uploadSexActionSuccess:^(NSString *alert) {
                [QYDialogTool showDlg:alert];
                [self assembleData];
            }
            failure:^(NSString *alert) {
                [QYDialogTool showDlg:alert];
            }];
        }
    }
}

#pragma mark - 照片选择
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker.allowsEditing = YES;

    NSData *imageData = UIImageJPEGRepresentation(image, 0.00000001);
    
    UIImage *compressImage = [UIImage imageWithData:imageData];
    
    //准备上传的图片
    _viewModel.photoImage = [_viewModel imageWithImageSimple:compressImage scaledToSize:CGSizeMake(100, 100)];
    
    //上传请求
    [_viewModel uploadPhotoActionSuccess:^(NSString *alert, NSString *attachFile)
    {
        [QYDialogTool showDlg:alert];
        
        //将图片存入 内存
        QYAccount *account = [[QYAccountService shared] defaultAccount];
        NSString *urlString = [[QYURLHelper shared] getUrlWithModule:ModelCode urlKey:@"headPictureView"];
        NSString *headImageURL = [NSString stringWithFormat:@"%@userId=%@&_clientType=wap&filePath=%@",urlString,account.userId,attachFile];

        [[SDImageCache sharedImageCache] storeImage:compressImage forKey:headImageURL];
        
        //上传完，从数据库里面查询（更新）
        [self getSelf];
    }
    failure:^(NSString *alert)
    {
        [QYDialogTool showDlg:alert];
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - event response
#pragma mark - private methods
/**
 *  初始化viewModel，监测viewModel数据变化，更新UI
 */
- (void)initializeViewModel
{
    _viewModel = [[QYIndivCenterViewModel alloc] init];
    
}
-(void)removeTableViewLine
{
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.tableFooterView = [[UIView alloc] init];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.backgroundView = nil;
    self.tableView.backgroundView = [UIView new];
    self.tableView.backgroundColor = [UIColor themeBgColorGrey];
    self.view.backgroundColor= [UIColor themeBgColorGrey];
}

-(void)assembleData
{
    self.modelArray = [_viewModel assembleData];
    [self.tableView reloadData];
}

-(void)showInputController:(NSString *)text
{
    QYPersonalitySignatureViewController *indivCenterInputViewController = [[QYPersonalitySignatureViewController alloc] init];
    if ([text isEqualToString:@"(null)"])
    {
        text = @"";
    }
    indivCenterInputViewController.text = text;
    indivCenterInputViewController.title = @"编辑签名";
    
    [self.navigationController pushViewController:indivCenterInputViewController animated:YES];
    
    __weak QYPersonalitySignatureViewController *wIndivCenterInputViewController = indivCenterInputViewController;
    indivCenterInputViewController.completBlock = ^(NSString *text)
    {
        _viewModel.sign = text;
        
        //更新签名
        [_viewModel uploadSignActionSuccess:^(NSString *alert)
        {
            [QYDialogTool showDlg:alert];
            
            [wIndivCenterInputViewController.navigationController popViewControllerAnimated:YES];
            
            [self assembleData];
        }
        failure:^(NSString *alert)
        {
            [QYDialogTool showDlg:alert];
        }];
    };
}

//上传头像
-(void)showPhotoActionSheet
{
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    actSheet.delegate = self;
    actSheet.tag = PhotoActionSheetTag;
    [actSheet showInView:self.view];
}

/**
 *  创建 男 女 actionSheet
 */
-(void)showSexActionSheet
{
    UIActionSheet *actSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    actSheet.tag = SexActionSheetTag;
    actSheet.delegate = self;
    [actSheet showInView:self.view];
}

/**
 *  创建 上传头像 actionSheet
 *
 *  @param sourceType <#sourceType description#>
 */
-(void)showImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imgPickerController = [[UIImagePickerController alloc] init];
    [[imgPickerController navigationBar] setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
    [[imgPickerController navigationBar] setBackgroundImage:[UIImage themeNavBg] forBarMetrics:UIBarMetricsDefault];
    imgPickerController.allowsEditing = YES;
    imgPickerController.delegate = self;
    imgPickerController.sourceType = sourceType;
    
    [self presentViewController:imgPickerController animated:YES completion:nil];
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    for (UINavigationItem *item in navigationController.navigationBar.subviews)
    {
        if ([item isKindOfClass:[UIButton class]] && ([item.title isEqualToString:@"取消"] || [item.title isEqualToString:@"Cancel"]))
        {
            UIButton *button = (UIButton *)item;
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
        }
    }
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
-(void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [[UIApplication  sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

//从通讯录(数据库)中得到自己
-(void)getSelf
{
    self.userModel = nil;
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    
    QYABUserModel *userModel = [QYABDb userWithUserId:account.userId];
    self.userModel = userModel;
    
    [self.tableView reloadData];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
