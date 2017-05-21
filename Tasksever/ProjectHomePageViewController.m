//
//  ProjectHomePageViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/4/30.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "ProjectHomePageViewController.h"
#import "fenpeiViewController.h"
#import "chengyuanguanliViewController.h"
#import "AFNetworking.h"
#import "checkViewController.h"
#import "groupInformationViewController.h"
#import "UIColor+Utils.h"
#import "doMyTaskViewController.h"
#import "wenjiankuViewController.h"
@interface ProjectHomePageViewController (){
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UIImageView *wenjiankuImage;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIImageView *jinduImage;
@property (weak, nonatomic) IBOutlet UIImageView *fenpeiImage;
@property (weak, nonatomic) IBOutlet UIImageView *chengyuanImage;
@property (weak, nonatomic) IBOutlet UILabel *canyuLabel;
@property (weak, nonatomic) IBOutlet UILabel *guanliLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberOfGroup;
@property (weak, nonatomic) IBOutlet UIImageView *xinxiImage;
@property (weak, nonatomic) IBOutlet UIImageView *destroyGroup;
@end

@implementation ProjectHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bground = [UIImage imageNamed:@"111的副本.jpg"]; //设置背景图片
    self.view.layer.contents = (id) bground.CGImage;
    //显示头像
    NSData * decodedImageData = [[NSData alloc] initWithBase64EncodedString:self.projectImageString options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    self.avatarImage.image = decodedImage;
    //显示群组Id
    _numberOfGroup.text = [NSString stringWithFormat:@"%@", self.projectId];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.tabBarController.tabBar.hidden = YES;
    [self getProjectMember];
    [self getProjectMemberJoin];
    self.navigationItem.title = self.projectTitle;
    self.memberNameList = [[NSMutableArray alloc] init];
    self.memberIdList = [[NSMutableArray alloc] init];
    self.managerNameList = [[NSMutableArray alloc] init];
    self.joinerNameList = [[NSMutableArray alloc] init];
    //头像
    self.avatarImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImage.layer.borderWidth = 4;
    self.avatarImage.layer.cornerRadius = 45;
    self.avatarImage.layer.masksToBounds = true;
    //任务进度按钮
    self.jinduImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *clock = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockJindu)];
    [self.jinduImage addGestureRecognizer:clock];
    //任务分配按钮
    self.fenpeiImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *clock1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockFenpei)];
    [self.fenpeiImage addGestureRecognizer:clock1];
    //小组成员按钮
    self.chengyuanImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *clock2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockChengyuan)];
    [self.chengyuanImage addGestureRecognizer:clock2];
    //解散群组按钮
    self.destroyGroup.userInteractionEnabled = YES;
    UITapGestureRecognizer *clock112 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDestroyGroup)];
    [self.destroyGroup addGestureRecognizer:clock112];
    //项目信息按钮
    self.xinxiImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *clock3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockXinxi)];
    [self.xinxiImage addGestureRecognizer:clock3];
    //文件库按钮
    self.wenjiankuImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *clock3111 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockWenJianKu)];
    [self.wenjiankuImage addGestureRecognizer:clock3111];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getProjectMemberJoin];
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
//查看进度
-(void)onClockJindu{
    if(self.judgeWhoEnterThisPage == 1){
        checkViewController *check = [[checkViewController alloc] init];
        check.user1 = self.user1;
        check.projectId = self.projectId;
        [self.navigationController pushViewController:check animated:YES];
    }else if(self.judgeWhoEnterThisPage == 0){
        doMyTaskViewController *do12 = [[doMyTaskViewController alloc] init];
        do12.user1 = self.user1;
        do12.projectId = self.projectId;
        [self.navigationController pushViewController:do12 animated:YES];
    }
}
//分配任务
-(void)onClockFenpei{
    int userpower = [self.userPower intValue];
    if(self.judgeWhoEnterThisPage == 1 || userpower == 1){
        fenpeiViewController *fenpei = [[fenpeiViewController alloc] init];
        fenpei.projectId = self.projectId;
        fenpei.user1 = self.user1;
        [self.navigationController pushViewController:fenpei animated:YES];
    }else{// if(self.judgeWhoEnterThisPage == 0 || [self.userPower isEqualToString:@"0"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"对不起，您无此权限！" message: @""preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
//查看成员
-(void)onClockChengyuan{
    chengyuanguanliViewController *cheng = [[chengyuanguanliViewController alloc] init];
    cheng.joinerNameList = [[NSMutableArray alloc] init];
    cheng.joinerNameList = self.joinerNameList;
    cheng.managerNameList = [[NSMutableArray alloc] init];
    cheng.memberNameList = [[NSMutableArray alloc] init];
    cheng.memberNameList = self.memberNameList;
    cheng.managerNameList= self.managerNameList;
    cheng.publishName = self.publishName;
    cheng.projectId = self.projectId;
    if(self.judgeWhoEnterThisPage == 1){
        cheng.userPower = @"right";
    }else{
        cheng.userPower = @"notRight";
    }
    [self.navigationController pushViewController:cheng animated:YES];
}
//查看群组信息
-(void)onClockXinxi{
    groupInformationViewController *group = [[groupInformationViewController alloc] init];
    group.projectTitle = self.projectTitle;
    group.projectId = self.projectId;
    group.projectDescription = self.projectDescription;
    group.projectImageString = self.projectImageString;
    group.publishName = self.publishName;
    [self.navigationController pushViewController:group animated:YES];
}
//点击文件库
-(void)onClockWenJianKu{
    wenjiankuViewController *wenjianku = [[wenjiankuViewController alloc] init];
    [self.navigationController pushViewController:wenjianku animated:YES];
}
//解散群组
-(void)onDestroyGroup{
    if(self.judgeWhoEnterThisPage == 1){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您确定要这个解散群组吗？" message: @""preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action){
        //解散群组
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //manager.requestSerializer.timeoutInterval = 5;
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
            
            
            NSDictionary *dic = @{
                                  @"p_id":self.projectId,
                                  };
            NSString *ch= [NSString alloc];
            if ([NSJSONSerialization isValidJSONObject:dic]) {
                NSError *error;
                NSData *registerData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
                ch =[[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
            }else{
                
            }
            NSDictionary *dics = @{
                                   @"data" : ch,
                                   };
            NSLog(@"###%@",ch);
            [manager POST:@"http://112.74.54.96/deleteProject" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                 NSLog(@"返回解散群组成功%@",responseObject);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"解散传输失败:%@",[error localizedDescription]);
            }];
            
            
            
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
                                
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"对不起，您无此权限" message: @""preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
-(void)getProjectMember{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    NSDictionary *dic = @{
                          @"p_id":self.projectId,
                          };
    NSString *ch= [NSString alloc];
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        ch =[[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
      //  NSLog(@"Register JSON:%@",ch);
    }else{
     //   NSLog(@"error");
        
    }
    NSDictionary *dics = @{
                           @"data" : ch,
                           };
  //  NSLog(@"###%@",ch);
    [manager POST:@"http://112.74.54.96/getProjectMember" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSLog(@"返回成功群组成员%@",responseObject);
        [self.memberNameList removeAllObjects];
        [self.managerNameList removeAllObjects];
        for (int i = 0; i<[responseObject[@"data"] count]; i++) {
            [self.memberNameList addObject:responseObject[@"data"][i][@"u_name"]];
        }
        for(int i = 0; i<[responseObject[@"data2"] count]; i++) {
            [self.managerNameList addObject:responseObject[@"data2"][i]];
        }
        NSLog(@"###%@",self.managerNameList);
        NSLog(@"###%@",self.memberNameList);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
}
-(void)getProjectMemberJoin{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    NSDictionary *dic = @{
                          @"userid":self.user1.userId,
                          @"projectid":self.projectId,
                          };
    NSString *ch= [NSString alloc];
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        ch =[[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
        //  NSLog(@"Register JSON:%@",ch);
    }else{
        //   NSLog(@"error");
        
    }
    NSDictionary *dics = @{
                           @"data" : ch,
                           };
    NSLog(@"###%@",ch);
    [manager POST:@"http://112.74.54.96//getProjectSubmission" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       //  NSLog(@"返回成功申请入群%@",responseObject);
            [self.joinerNameList removeAllObjects];
        for (int i = 0; i<[responseObject count]; i++) {
            [self.joinerNameList addObject:responseObject[i][@"username"]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"获取申请传输失败:%@",[error localizedDescription]);
    }];
}
- (void)didReceiveMemoryWarning {
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
