//
//  addContactsViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/4/25.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "addContactsViewController.h"
#import "CustomSearchBar.h"
#import "informationViewController.h"
#import "UIColor+Utils.h"
#import "AFNetworking.h"
@interface addContactsViewController ()<CustomsearchResultsUpdater,CustomSearchBarDataSouce,CustomSearchBarDelegate>{
    UIView *statusBarView;
}
@property (nonatomic, strong) CustomSearchBar * customSearchBar1;
@property (nonatomic, strong) CustomSearchBar * customSearchBar2;
@property (nonatomic, strong) NSMutableArray * resultFileterArry;
@property (nonatomic, strong) NSMutableArray * myData;
@property (nonatomic, strong) NSMutableArray * groupID;
@property (nonatomic ) NSString *groupIdString;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPress;

@end

@implementation addContactsViewController
-(NSMutableArray *)resultFileterArry {
    if (!_resultFileterArry) {
        _resultFileterArry = [NSMutableArray new];
    }
    return _resultFileterArry;
}
-(void)setJudgeSearchWhat{
    if(_judgeSearchWhat == 0){
        self.textFieldPress.placeholder = @"请输入群组号";
        self.navigationItem.title = @"加入群组";
        [self getGroupList];
    }else if(_judgeSearchWhat == 1){
        self.textFieldPress.placeholder = @"用户名/手机号/邮箱";
        self.navigationItem.title = @"添加联系人";
        [self getUserList];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.myData = [[NSMutableArray alloc] init];
    self.groupID = [[NSMutableArray alloc] init];
    [self setJudgeSearchWhat];
  //  [searchbar0 release];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
    statusBarView = [[UIView alloc]   initWithFrame:CGRectMake(0, -20,    self.view.bounds.size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
    [self.navigationController.navigationBar addSubview:statusBarView];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    [statusBarView removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchBarOut:(id)sender {
    [self.resultFileterArry removeAllObjects];
    if(self.judgeSearchWhat == 0){
        self.customSearchBar1 = [CustomSearchBar show:CGPointMake(0, 0) andHeight:SEMHEIGHT];
        self.customSearchBar1.searchResultsUpdater = self;
        self.customSearchBar1.DataSource = self;
        self.customSearchBar1.delegate = self;
        [self.navigationController.view insertSubview:self.customSearchBar1 aboveSubview:self.navigationController.navigationBar];
    }else{
        self.customSearchBar2 = [CustomSearchBar show:CGPointMake(0, 0) andHeight:SEMHEIGHT];
        self.customSearchBar2.searchResultsUpdater = self;
        self.customSearchBar2.DataSource = self;
        self.customSearchBar2.delegate = self;
        [self.navigationController.view insertSubview:self.customSearchBar2 aboveSubview:self.navigationController.navigationBar];
    }
}
-(void)textFieldDidBeginEditing:(UITextField*)textField{
    self.textFieldPress.enabled = NO;
}
-(void)customSearch:(CustomSearchBar *)searchBar inputText:(NSString *)inputText {
    [self.resultFileterArry removeAllObjects];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",inputText];
    NSArray * arry = [self.myData filteredArrayUsingPredicate:predicate];
    for (NSString * taxChat in arry) {
        [self.resultFileterArry addObject:taxChat];
    }
}
// 设置显示列的内容
-(NSInteger)searchBarNumberOfRowInSection {
    return self.resultFileterArry.count;
}
// 设置显示没行的内容
-(NSString *)customSearchBar:(CustomSearchBar *)menu titleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.resultFileterArry[indexPath.row];
}
- (void)customSearchBar:(CustomSearchBar *)segment didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(self.judgeSearchWhat == 1){
        informationViewController *infor = [[informationViewController alloc] init];
        infor.judgeIfAddFriend = 1;
        infor.user1 = self.user1;
        infor.userName = self.resultFileterArry[indexPath.row];
        [self.navigationController pushViewController:infor animated:YES];
    }else if(self.judgeSearchWhat == 0){
        //群组信息页
        self.groupIdString = self.myData[indexPath.row];
        [self sendJoinGroupRequest];
    }
}

-(void)customSearchBar:(CustomSearchBar *)segment cancleButton:(UIButton *)sender {
    
}
-(NSString *)customSearchBar:(CustomSearchBar *)searchBar imageNameForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Search_noraml";
}
-(void)getUserList{
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
  //  NSLog(@"###获取全部用户%@",ch);
    [manager POST:@"http://112.74.54.96/getUserList" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //  NSLog(@"返回成功全部用户%@",responseObject);
         [self.myData removeAllObjects];
         for (int i = 0; i<[responseObject count]; i++) {
             [self.myData addObject: responseObject[i][@"username"]];
         }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
}

-(void)getGroupList{
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
    NSLog(@"###获取全部群组%@",ch);
    [manager POST:@"http://112.74.54.96/getProjectList" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回成功全部群组%@",responseObject);
        [self.myData removeAllObjects];
        [self.groupID removeAllObjects];
        for (int i = 0; i<[responseObject count]; i++) {
            [self.groupID addObject:responseObject[i][@"id"]];
        }for (int i=0; i<self.groupID.count; i++) {
            self.myData[i] = [NSString stringWithFormat:@"%@",self.groupID[i]];
        }
     //   self.myData initWithObjects:<#(nonnull id), ...#>, nil
        NSLog(@"####%@",self.myData);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
}
-(void)sendJoinGroupRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSDictionary *dic = @{
                          @"username" : self.user1.userName,
                          @"project_id" : self.groupIdString,
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
    NSLog(@"###加入群组%@",ch);
    [manager POST:@"http://112.74.54.96/sendAddProjectSubmission" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //   NSDictionary *getDic=[NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        //弹出上传成功 返回上一界面
        NSLog(@"###成功加入群组%@",responseObject);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"已发送进组申请！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发送申请失败！" message:@"请检查网络连接是否正常！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
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
