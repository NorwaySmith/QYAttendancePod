//
//  QYAboutTXZLViewController.m
//  QYBaseProject
//
//  Created by dzq on 15/7/3.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYAboutTXZLViewController.h"

#import "QYAboutTXZLView.h"
#import "QYDialogTool.h"
#import "UIFont+Base.h"
#import "QYTheme.h"
#import "QYH5ViewController.h"

@interface QYAboutTXZLViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,strong) QYAboutTXZLView *aboutTXZLView;

@end

@implementation QYAboutTXZLViewController


- (id)init
{
    self = [super init];
    if (self)
    {
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"关于";
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.aboutTXZLView.mTableView.backgroundColor = [UIColor themeListBackgroundColor];
    self.aboutTXZLView.mTableView.separatorColor = [UIColor themeSeparatorLineColor];
    
    self.titleArray = @[@{@"客服电话":@"13733883777"},@{@"公司网站":@"www.qytx.com.cn"}];
    
    [self addView];

}

- (void)addView
{
    self.aboutTXZLView = [[QYAboutTXZLView alloc] initWithFrame:self.view.bounds];
    _aboutTXZLView.mTableView.delegate = self;
    _aboutTXZLView.mTableView.dataSource = self;
    [self.view addSubview:_aboutTXZLView];
}

- (void)viewDidLayoutSubviews
{
    if ([self.aboutTXZLView.mTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [self.aboutTXZLView.mTableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    if ([self.aboutTXZLView.mTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [self.aboutTXZLView.mTableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}


#pragma mark - UITableView delegate  dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    
    NSDictionary *itemDict = self.titleArray[indexPath.row];
    cell.textLabel.text = itemDict.allKeys[0];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    cell.detailTextLabel.text = itemDict.allValues[0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:53.0/255 green:185.0/255 blue:235.0/255 alpha:1.0];
    cell.detailTextLabel.font = [UIFont baseTextSmall];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *itemDict = self.titleArray[indexPath.row];
    switch (indexPath.row)
    {
        case 0:
        {
            [self call:itemDict.allValues[0]];
        }
            break;
        case 1:
        {
            [self openCompanyURL:[NSString stringWithFormat:@"http://%@",itemDict.allValues[0]]];
        }
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)])
    {
        [cell setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}




#pragma mark - Private method

//拨打电话
-(void)call:(NSString*)phone
{
    if (!phone||[phone isEqualToString:@""]||[phone isEqualToString:@"(null)"])
    {
        return;
    }
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phone]];
    
    //NSLog(@"callURL:%@",phoneURL);
    if (![application canOpenURL:phoneURL])
    {
        [QYDialogTool showDlg:@"您使用的设备不能拨打电话!"];
        return;
    }
    [application openURL:phoneURL];
}

//浏览器打开网址
- (void)openCompanyURL:(NSString *)url
{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    
    NSURL *url_url = [NSURL URLWithString:url];
    QYH5ViewController *H5ViewController = [[QYH5ViewController alloc] initWithUrl:url_url];
    
    [self.navigationController pushViewController:H5ViewController animated:YES];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
