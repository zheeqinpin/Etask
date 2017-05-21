//
//  handinViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/3/20.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "handinViewController.h"
#import "AFNetworking.h"
#import "UIColor+Utils.h"
#import "upLoadFileViewController.h"
#import "wanchegnrenViewController.h"
#import "NSString+TimeInterval.h"
@interface handinViewController ()
{
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UITextView *taskDesc;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;



@end
@implementation handinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bground = [UIImage imageNamed:@"111的副本.jpg"]; //设置背景图片
    self.view.layer.contents = (id) bground.CGImage;
    self.navigationItem.title = self.taskName;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.finishNameLis = [[NSMutableArray alloc] init];
    self.finishIdList = [[NSMutableArray alloc] init];
    self.unfinishNameLis = [[NSMutableArray alloc] init];
    //右边按钮
    if(self.judgeIfManagerEnterThisPage == 0){
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"去完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
        self.taskDesc.text =self.taskDescription;
        
        self.label1.text = self.creatTime;
        self.label2.text = self.deadline;
    }else{
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"查看" style:UIBarButtonItemStylePlain target:self action:@selector(checkMember)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
        self.taskDesc.text =self.taskDescription;
        self.label1.text = self.creatTime;
        self.label2.text = self.deadline;
        NSString *timeAgo = [self.creatTime calculateUpLoadTime];
        NSLog(@"##agoooooooo%@",timeAgo);
        [self getFinishList];
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
-(void)complete{
    upLoadFileViewController *upload = [[upLoadFileViewController alloc] init];
    upload.user1 =self.user1;
    upload.taskId = self.taskId;
    upload.taskName = self.taskName;
    [self.navigationController pushViewController:upload animated:YES];
}
-(void)checkMember{
    wanchegnrenViewController *wan = [[wanchegnrenViewController alloc] init];
    wan.finishNameLis = self.finishNameLis;
    wan.finishIdList = self.finishIdList;
    wan.unfinishNameLis = self.unfinishNameLis;
    wan.taskId = self.taskId;
    wan.user1= self.user1;
    [self.navigationController pushViewController:wan animated:YES];
}
-(void)getFinishList{
    // 模拟延迟3秒
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    NSDictionary *dic = @{
                          @"t_id":self.taskId,
                          @"signal":@"0",
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
    NSLog(@"###gettfinish%@",ch);
    [manager POST:@"http://112.74.54.96/getFinishList" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     //   NSLog(@"返回成功%@",responseObject);
        [self.finishNameLis removeAllObjects];
        [self.finishIdList removeAllObjects];
        [self.unfinishNameLis removeAllObjects];
        for (int i = 0; i<[responseObject[@"data"] count]; i++) {
            [self.finishNameLis addObject:responseObject[@"data"][i][@"commitName"]];
            [self.finishIdList addObject:responseObject[@"data"][i][@"commitId"]];
        }
        for (int i = 0; i<[responseObject[@"data1"] count]; i++) {
            [self.unfinishNameLis addObject:responseObject[@"data1"][i]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
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
