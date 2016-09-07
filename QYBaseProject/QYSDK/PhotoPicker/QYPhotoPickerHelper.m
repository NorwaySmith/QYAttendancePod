//
//  QYPhotoPickerHelper.m
//  QYBaseProject
//
//  Created by 田 on 15/8/6.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYPhotoPickerHelper.h"
#import "QYTheme.h"
@interface QYPhotoPickerHelper()
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIActionSheetDelegate>
@property (nonatomic, weak)  UIViewController          *fromController;
@property (nonatomic, copy)  QYPickerCompelitionBlock completion;
@property (nonatomic, copy)  QYPickerCancelBlock      cancelBlock;
@end
@implementation QYPhotoPickerHelper
+ (QYPhotoPickerHelper *)shared {
    static QYPhotoPickerHelper *sharedObject = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        if (!sharedObject) {
            sharedObject = [[[self class] alloc] init];
        }
    });
    
    return sharedObject;
}  
- (void)showActionSheetInView:(UIView *)inView
               fromController:(UIViewController *)fromController
                   completion:(QYPickerCompelitionBlock)completion
                  cancelBlock:(QYPickerCancelBlock)cancelBlock {
    self.completion = [completion copy];
    self.cancelBlock = [cancelBlock copy];
    self.fromController = fromController;
    
        UIActionSheet *actionSheet = nil;
        actionSheet  = [[UIActionSheet alloc] initWithTitle:nil
                                            delegate:(id<UIActionSheetDelegate>)self
                                            cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                        otherButtonTitles:@"拍照",@"从手机相册选择", nil];
  
        [actionSheet showInView:inView];
    
    return;  
}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 从相册选择
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            [[picker navigationBar] setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
            [[picker navigationBar] setBackgroundImage:[UIImage themeNavBg] forBarMetrics:UIBarMetricsDefault];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            [self.fromController presentViewController:picker animated:YES completion:nil];
        }
    } else if (buttonIndex == 0) { // 拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            [[picker navigationBar] setTintColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]];
            [[picker navigationBar] setBackgroundImage:[UIImage themeNavBg] forBarMetrics:UIBarMetricsDefault];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self.fromController presentViewController:picker animated:YES completion:nil];
        }else{
        
        }
    }  
    return;  
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
#pragma mark - UIImagePickerControllerDelegate
// 选择了图片或者拍照了
- (void)imagePickerController:(UIImagePickerController *)aPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    __block UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    if (image && self.completion) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.fromController setNeedsStatusBarAppearanceUpdate];
        
        self.completion(image);
    }
    return;
}

// 取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)aPicker {
    [aPicker dismissViewControllerAnimated:YES completion:nil];
    
    if (self.cancelBlock) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self.fromController setNeedsStatusBarAppearanceUpdate];
        
        self.cancelBlock();  
    }  
    return;  
}
@end
