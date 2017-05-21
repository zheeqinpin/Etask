//
//  messageViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/3/16.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "messageViewController.h"
#import "user.h"
#import "MJRefresh.h"
#import "addContactsViewController.h"
#import "UIColor+Utils.h"
#import "AFNetworking.h"
#import "SDAnalogDataGenerator.h"
#import "informationViewController.h"
@interface messageViewController (){
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UITableView *tablethree;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegmented;
@end

@implementation messageViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{  self = [super initWithNibName:nibNameOrNil
                          bundle:nibBundleOrNil];
    if(self){
        self.navigationItem.title = @"联系人";
        self.tabBarItem.title = @"联系人";
        UIImage *h = [UIImage imageNamed:@"contacts.png"];
        self.tabBarItem.image =h;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    [self getMyFriends];
    [self getFriendSubmission];
    UIImage *rightButtonIcon = [[UIImage imageNamed:@"contacts_add_friend"]
                               imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithImage:rightButtonIcon
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(addNewContacts)];
    self.navigationItem.rightBarButtonItem = rightButton;
  /*  UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                         target:self
                                                                         action:@selector(addNewContacts)];
    self.navigationItem.rightBarButtonItem = bbi;*/
    self.tablethree.dataSource=self;
    self.friendNameList = [[NSMutableArray alloc] init];
    self.friendInviteNameList = [[NSMutableArray alloc] init];
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.tablethree.mj_header = header;
    NSArray *segmentedData = [[NSArray alloc]initWithObjects:@"好友",@"好友申请",nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedData];
    segmentedControl.frame = CGRectMake(10.0, 20.0,30.0, 30.0);
    [segmentedControl addTarget:self action:@selector(segmentClick:) forControlEvents: UIControlEventValueChanged];
    self.mySegmented=segmentedControl;
    self.mySegmented.selectedSegmentIndex=0;
    [[self navigationItem] setTitleView:segmentedControl];
    
 //   [self.tablethree.mj_header beginRefreshing];
}
-(void)segmentClick:(UISegmentedControl *)seg
{
       switch (seg.selectedSegmentIndex)
    {
        case 0:
            self.judgeFriendType = 0;
            [self.tablethree reloadData];
            break;
        case 1:
            self.judgeFriendType = 1;
            [self.tablethree reloadData];
            break;
        default:
            break;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tablethree reloadData];
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
    statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
    [self.navigationController.navigationBar addSubview:statusBarView];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [statusBarView removeFromSuperview];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(_judgeFriendType == 0){
        if(_friendNameList != nil){
            cell.textLabel.text = [self.friendNameList objectAtIndex:indexPath.row];
            UIImage *profileImage = [UIImage alloc];
            profileImage = [UIImage imageNamed:[SDAnalogDataGenerator randomIconImageName]];
            CGSize reSize = CGSizeMake(40, 40);
            UIImage *smallProfile = [profileImage reSizeImage:profileImage toSize:reSize];
            cell.imageView.image = smallProfile;
            cell.imageView.layer.cornerRadius = 20;
            cell.imageView.layer.masksToBounds = true;
        }
    }else if(_judgeFriendType == 1){
        if(_friendInviteNameList != nil){
            NSLog(@"ERROR");
            cell.textLabel.text = [self.friendInviteNameList objectAtIndex:indexPath.row];
            UIImage *profileImage = [UIImage alloc];
            profileImage = [UIImage imageNamed:[SDAnalogDataGenerator randomIconImageName]];
            CGSize reSize = CGSizeMake(40, 40);
            UIImage *smallProfile = [profileImage reSizeImage:profileImage toSize:reSize];
            cell.imageView.image = smallProfile;
            cell.imageView.layer.cornerRadius = 20;
            cell.imageView.layer.masksToBounds = true;
        }else{
                
        }
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.judgeFriendType  == 0) {
        //return 20;
        return self.friendNameList.count;
    } else {
        return self.friendInviteNameList.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.0f;
     //   return CGFLOAT_MIN;
    }
    return CGFLOAT_MIN;
  //  return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if(_judgeFriendType == 0){
        
    }else if(_judgeFriendType == 1){
        informationViewController *infor = [[informationViewController alloc] init];
        infor.judgeIfAddFriend =3;
        infor.user1 = self.user1;
        infor.userName = self.friendInviteNameList[indexPath.row];
        [self.navigationController pushViewController:infor animated:YES];
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        if(self.judgeFriendType == 0){
            [self.friendNameList removeObjectAtIndex:indexPath.row];
            [self.tablethree deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }else if(self.judgeFriendType == 1){
            [self.friendInviteNameList removeObjectAtIndex:indexPath.row];
            [self.tablethree deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }else if(editingStyle == UITableViewCellEditingStyleInsert){
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除好友";
}
-(void)addNewContacts{
    addContactsViewController *add1 = [[addContactsViewController alloc] init];
    add1.judgeSearchWhat = 1;
    add1.user1 = self.user1;
    [self.navigationController pushViewController:add1 animated:YES];
  
}

-(void)headerClick{
    // 可在此处实现下拉刷新时要执行的代码
    // ......
    [self getMyFriends];
    [self getFriendSubmission];
    // 模拟延迟3秒
    [NSThread sleepForTimeInterval:1];
    // 结束刷新
    [self.tablethree.mj_header endRefreshing];
}
-(void)getMyFriends{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSDictionary *dic = @{
                          @"username":self.user1.userName,
                          };
    NSString *ch= [NSString alloc];
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        ch =[[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
        NSLog(@"Register JSON:%@",ch);
    }else{
        NSLog(@"error");
        
    }
    NSDictionary *dics = @{
                           @"data" : ch,
                           };
    NSLog(@"###%@",ch);

    [manager POST:@"http://112.74.54.96/getFriendsList" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回成功好友列表%lu",[responseObject count]);
        NSLog(@"返回成功好友列表%@",responseObject);
            [self.friendNameList removeAllObjects];
            for (int i = 0; i<[responseObject count]; i++) {
                [self.friendNameList addObject:responseObject[i]];
            }
            __weak UITableView *tableView = self.tablethree;
            [tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
}
-(void)getFriendSubmission{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSDictionary *dic = @{
                          @"username":self.user1.userName,
                          };
    NSString *ch= [NSString alloc];
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        ch =[[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
        NSLog(@"Register JSON:%@",ch);
    }else{
        NSLog(@"error");
        
    }
    NSDictionary *dics = @{
                           @"data" : ch,
                           };
    NSLog(@"###返回邀请%@",ch);
    
    [manager POST:@"http://112.74.54.96/getFriendSubmission" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回成功邀请列表%lu",[responseObject count]);
        NSLog(@"返回成功邀请列表%@",responseObject);
        [self.friendInviteNameList removeAllObjects];
        for (int i = 0; i<[responseObject count]; i++) {
            [self.friendInviteNameList addObject:responseObject[i]];
        }
        if(self.friendInviteNameList.count != 0){
            self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.friendInviteNameList.count];
        }else{
            self.tabBarItem.badgeValue = nil;
        }
        __weak UITableView *tableView = self.tablethree;
        [tableView reloadData];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
