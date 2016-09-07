//
//  QYTheRecommendDetailsViewController.m
//  QYBaseProject
//
//  Created by dzq on 15/7/1.
//  Copyright (c) 2015年 田. All rights reserved.
//

#import "QYRecommendDetailsViewController.h"
#import "QYMoreNetworkApi.h"
#import "QYAccountService.h"
#import "QYAccount.h"
#import "IOSTool.h"
#import "QYTheme.h"

#import <QYAddressBook/QYABPickerApi.h>
#import <QYAddressBook/QYABPickerAddUserView.h>

#define kDefaultRecommendMessage @"【乐工作】%@推荐您下载乐工作，下载地址：http://www.le-work.com/clientdown.jsp 初始密码为123456。"

@interface QYRecommendDetailsViewController ()<QYABProtocol, QYABPickerAddUserDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray                *personItems;
@property (strong, nonatomic) UITableView                   *tableView;

@property (strong, nonatomic) QYABPickerAddUserView         *addUserView;
@property (strong, nonatomic) UITextView                    *textView;

@end

@implementation QYRecommendDetailsViewController

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor themeListBackgroundColor];
    self.title = @"短信推荐";
    self.personItems = [[NSMutableArray alloc] init];
    
    [self configBarButtonItem];
    [self configTableView];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI
- (void)configBarButtonItem{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.titleLabel.font = [UIFont themeRightButtonFont];
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    
    rightButton.frame = CGRectMake(0, 0, 50, 44);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    
    UIBarButtonItem *operationBar = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = operationBar;
}

- (void)configTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth], [QYDeviceInfo screenHeight]) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
//    _tableView.scrollEnabled = NO;
    _tableView.backgroundColor = [UIColor themeListBackgroundColor];
    [self.view addSubview:_tableView];
    
    //headerView
    _addUserView = [[QYABPickerAddUserView alloc] initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth], 65)];
    _addUserView.delegate = self;
    _addUserView.userArray = self.personItems;
    _tableView.tableHeaderView = _addUserView;
    
    //footerView
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [QYDeviceInfo screenWidth], 140)];
    footerView.backgroundColor = [UIColor themeListBackgroundColor];
    
    QYAccount *account = [[QYAccountService shared] defaultAccount];
    NSString *recommendStr = [NSString stringWithFormat:kDefaultRecommendMessage, account.userName];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, [QYDeviceInfo screenWidth] - 20, 120)];
    self.textView.userInteractionEnabled = NO;
    self.textView.text = recommendStr;
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font = [UIFont systemFontOfSize:15];
    self.textView.textColor = [UIColor colorWithRed:170.0/255 green:170.0/255 blue:170.0/255 alpha:1.0];
    [footerView addSubview:self.textView];
    _tableView.tableFooterView = footerView;
}

#pragma mark - TableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - CustomDelegate
#pragma mark -- QYABPickerAddUserDelegate
- (void)addUserAction:(id)object{
    QYABPickerApi *picker = [[QYABPickerApi alloc] initMultiPickerWithDelegate:self permitModules:@[AddressBookUnits, AddressBookPrivate, AddressBookCommonUser, AddressBookCommonGroup] isShowHiddenPerson:NO maximumSelect:0 moduleName:[[QYAccountService shared] combinedModuleName:AddressBookPicker_Base]];
    [picker setSelectedUsers:self.personItems];
    [picker setLockedUsers:nil];
    [picker show:QYABPickerDisplayModePush];
}

#pragma mark  -- QYABPickerDelegate
- (void)pickerDidFinishedSelectedWithUsers:(NSArray *)users{
    [self.personItems removeAllObjects];
    self.personItems = [NSMutableArray arrayWithArray:users];
    _addUserView.userArray = self.personItems;
}

#pragma mark - event response
- (void)done{
    if (!self.personItems || self.personItems.count == 0)
    {
        [QYDialogTool showDlg:@"请选择推荐人"];
    }
    else
    {
        NSMutableArray *phoneArray = [[NSMutableArray alloc] init];
        for (QYABUserModel *userModel in self.personItems){
            [phoneArray addObject:userModel.phone];
        }
        
        QYAccount *account = [[QYAccountService shared] defaultAccount];
        
        [QYMoreNetworkApi sendRecommendWithRecommendContent:kDefaultRecommendMessage phoneList:[phoneArray componentsJoinedByString:@","] userId:account.userId success:^(NSString *responseString)
         {
             [self.navigationController popViewControllerAnimated:YES];
             [QYDialogTool showDlg:responseString];
         }failure:^(NSString *alert)
         {
             [QYDialogTool showDlg:alert];
         }];
    }
}

#pragma mark - private method

#pragma mark - getters and setters


@end
