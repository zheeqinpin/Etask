//
//  chooseContactsViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/4/25.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "chooseContactsViewController.h"
#import "MJRefresh.h"
#import "UIColor+Utils.h"
#import "SDAnalogDataGenerator.h"
#import "AFNetworking.h"
@interface chooseContactsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tablethree;
@property (nonatomic ) NSString *strr;
@end
@implementation chooseContactsViewController{
    UIView *statusBarView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"选择联系人";
    self.selectIndexs = [[NSMutableArray alloc] init];
    self.tablethree.dataSource=self;
    //刷新
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.tablethree.mj_header = header;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tablethree reloadData];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
    statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
    [self.navigationController.navigationBar addSubview:statusBarView];

    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
    if(self.selectIndexs.count == 1){
        self.strr = [[NSString alloc] initWithFormat:@"%@;",self.selectIndexs[0]];
        NSLog(@"##############%@",self.strr);
    }else{
        NSString *str = [self.selectIndexs componentsJoinedByString:@";"];
        self.strr = [[NSString alloc] initWithFormat:@"%@;",str];
        NSLog(@"##############%@",self.strr);
    }
    if(self.judgeChooseManagerOrMember == 0){
        self.user1.userChooseMember = self.strr;
    }else{
        self.user1.userChooseManager = self.strr;
    }
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [statusBarView removeFromSuperview];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.friendNameList[0] != nil){
            cell.textLabel.text = [self.friendNameList objectAtIndex:indexPath.row];
            UIImage *profileImage = [UIImage alloc];
             profileImage = [UIImage imageNamed:[SDAnalogDataGenerator randomIconImageName]];
            CGSize reSize = CGSizeMake(40, 40);
            UIImage *smallProfile = [profileImage reSizeImage:profileImage toSize:reSize];
            cell.imageView.image = smallProfile;
            cell.imageView.layer.cornerRadius = 20;
            cell.imageView.layer.masksToBounds = true;
          //  cell.detailTextLabel.text =[self.idList objectAtIndex:indexPath.row];
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.friendNameList.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
      //  return CGFLOAT_MIN;
        return 10.0f;
    }
   // return 10.0f;
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [ self.tablethree cellForRowAtIndexPath: indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryNone){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [self.selectIndexs addObject:cell.textLabel.text];
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
            [self.selectIndexs removeObject:cell.textLabel.text];
        }
    
}
-(void)headerClick{
    // 可在此处实现下拉刷新时要执行的代码
    // ......
    [self getMyFriends];
    // 模拟延迟3秒
    [NSThread sleepForTimeInterval:3];
    // 结束刷新
    [self.tablethree.mj_header endRefreshing];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSLog(@"返回好友列表啦%@",responseObject);
        [self.friendNameList removeAllObjects];
        for (int i = 0; i<[responseObject count]; i++) {
            [self.friendNameList addObject:responseObject[i]];
        }
        //  __weak UITableView *tableView = self.tablethree;
        [_tablethree reloadData];
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
