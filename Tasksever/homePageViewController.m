//
//  homePageViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/3/16.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "homePageViewController.h"
#import "messageViewController.h"
#import "detailViewController.h"
#import "handinViewController.h"
#import "user.h"
#import "MJRefresh.h"
#import "finishedOrNot.h"
#import "AppDelegate.h"
#import "UIColor+Utils.h"
#import "informationViewController.h"
#import "addContactsViewController.h"
#import "AFNetworking.h"
#import "SDAnalogDataGenerator.h"
@interface homePageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *creatGroupImage;
@property (weak, nonatomic) IBOutlet UIImageView *joinGroupImage;
@property (weak, nonatomic) IBOutlet UIImageView *user_infoImage;
@property (weak, nonatomic) IBOutlet UITableView *tablefive;
@property (weak, nonatomic) IBOutlet UIView *headerView_backGround;
@property (weak, nonatomic) IBOutlet UIImageView *pitureImageView;
@property (nonatomic) NSMutableArray *latestTaskTitle;//用于主界面展示最新的一部分任务
@property (nonatomic) NSMutableArray *sourceProjectName;//任务所属群组
@property (nonatomic) NSMutableArray *deadline;//截止时间
@end

@implementation homePageViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{  self = [super initWithNibName:nibNameOrNil
                          bundle:nibBundleOrNil];
    if(self){
        self.navigationItem.title = @"个人主页";
        self.tabBarItem.title = @"个人主页";
        UIImage *h = [UIImage imageNamed:@"homePage.png"];
        self.tabBarItem.image =h;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.taskTitleList = [[NSMutableArray alloc] init];
    self.taskImageList = [[NSMutableArray alloc] init];
    self.taskGroupList = [[NSMutableArray alloc] init];
    UIImage *image = [UIImage imageNamed:@"Previous.png"];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(loginout)];
    self.navigationItem.leftBarButtonItem = backButton;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.headerView_backGround.backgroundColor= [UIColor colorWithRGBValue:0x1093f6];
    self.tablefive.dataSource=self;
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.tablefive.mj_header = header;
    //头像
    self.pitureImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.pitureImageView.layer.borderWidth = 4;
    UIImage *profileImage = [UIImage alloc];
    profileImage = [UIImage imageNamed:[SDAnalogDataGenerator randomIconImageName]];
    CGSize reSize = CGSizeMake(93, 93);
    UIImage *smallProfile = [profileImage reSizeImage:profileImage toSize:reSize];
    self.pitureImageView.image = smallProfile;
    self.pitureImageView.layer.cornerRadius = 46.5;
    self.pitureImageView.layer.masksToBounds = true;
    //创建群组按钮
    self.creatGroupImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *cll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockCreatGroupImage)];
    [self.creatGroupImage addGestureRecognizer:cll];
    //加入群组按钮
    self.joinGroupImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *clll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockJoinGroupImage)];
    [self.joinGroupImage addGestureRecognizer:clll];
    //个人资料按钮
    self.user_infoImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *cllll = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockUserInfomationImage)];
    [self.user_infoImage addGestureRecognizer:cllll];
    [self.tablefive.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.tablefive reloadData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
-(void)onClockCreatGroupImage{
    detailViewController *detail = [[detailViewController alloc ] init];
    detail.user1 = self.user1;
    [self.navigationController pushViewController:detail animated:YES];
    
}
-(void)onClockJoinGroupImage{
    addContactsViewController *addc = [[addContactsViewController alloc] init];
    addc.judgeSearchWhat = 0;
    addc.user1 = self.user1;
    [self.navigationController pushViewController:addc animated:YES];
}
-(void)onClockUserInfomationImage{
    informationViewController *inFor = [[informationViewController alloc] init];
    inFor.user1 = self.user1;
    inFor.judgeIfAddFriend = 0;
    inFor.userName = self.user1.userName;
    [self.navigationController pushViewController:inFor animated:YES];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableString *strrr = [[NSMutableString alloc] initWithFormat:@"近期任务：%@",[self.taskTitleList objectAtIndex:indexPath.row]];
    cell.textLabel.text = strrr;
    NSData * decodedImageData = [[NSData alloc] initWithBase64EncodedString:self.taskImageList[indexPath.row] options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    CGSize reSize = CGSizeMake(40, 40);
    UIImage *smallProfile = [decodedImage reSizeImage:decodedImage toSize:reSize];
    cell.imageView.layer.cornerRadius = 20;
    cell.imageView.layer.masksToBounds = true;
    cell.imageView.image = smallProfile; //decodedImage;
    NSMutableString *strr = [[NSMutableString alloc] initWithFormat:@"来自群组：%@",[self.taskGroupList objectAtIndex:indexPath.row]];
    cell.detailTextLabel.text =strr;

    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//self.latestTaskTitle.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.taskTitleList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0f;
    }
    
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
}

//退出登录
-(void)loginout{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"退出登录！" message: @"您确定要退出登录吗？"preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                {
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)headerClick{
    [self getAllTask];
    // 模拟延迟3秒
    [self.tablefive reloadData];
    [NSThread sleepForTimeInterval:1];
    // 结束刷新
    [self.tablefive.mj_header endRefreshing];
}
-(void)getAllTask{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    NSDictionary *dic = @{
                          @"userid":self.user1.userId,
                          };
    NSString *ch= [NSString alloc];
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        ch =[[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
        //    NSLog(@"Register JSON:%@",ch);
    }else{
        //  NSLog(@"error");
        
    }
    NSDictionary *dics = @{
                           @"data" : ch,
                           };
  //  NSLog(@"###%@",ch);
    [manager POST:@"http://112.74.54.96/getAllTask" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     //   NSLog(@"返回成功我的任务%@",responseObject);
        [self.taskGroupList removeAllObjects];
        [self.taskTitleList removeAllObjects];
        [self.taskImageList removeAllObjects];
        for (int i = 0; i<[responseObject[@"data"] count]; i++) {
            
            [self.taskImageList addObject:responseObject[@"data"][i][@"img"]];
            [self.taskTitleList addObject:responseObject[@"data"][i][@"taskTitle"]];
            [self.taskGroupList addObject:responseObject[@"data"][i][@"project_name"]];
    }
        [self.tablefive reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
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
