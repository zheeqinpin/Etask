//
//  loginViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/3/17.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "loginViewController.h"
#import "homePageViewController.h"
#import "contactsViewController.h"
#import "taskManageViewController.h"
#import "messageViewController.h"
#import "ProjectHomePageViewController.h"
#import "detailViewController.h"
#import "handinViewController.h"
#import "fenpeiViewController.h"
#import "AFNetworking.h"
#import "UIColor+Utils.h"
#import "registerViewController.h"

@interface loginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *idField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *findpsdButton;
@property (weak, nonatomic) IBOutlet UIButton *signinButton;
@property (weak, nonatomic) IBOutlet UIView *navview;


@end

@implementation loginViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{  self = [super initWithNibName:nibNameOrNil
                          bundle:nibBundleOrNil];
    if(self){
        UINavigationItem *navItem = self.navigationItem;
        navItem.title = @"登录";
        UIImage *bground = [UIImage imageNamed:@"111的副本.jpg"]; //设置背景图片
        self.view.layer.contents = (id) bground.CGImage;
    }
    
    return self;
}
- (void)viewDidLoad
    {
        //按键加边框
        [super viewDidLoad];
        self.user1 = [[user alloc] init];
        self.loginButton.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
        self.loginButton.layer.cornerRadius = 2.0;
        self.navview.backgroundColor= [UIColor colorWithRGBValue:0x1093f6];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.passwordField.text = nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//登录跳转
-(IBAction)loginButtonAction:(id)sender{
    NSBundle *appBundle = [NSBundle mainBundle];
    contactsViewController *con = [[contactsViewController alloc]
                                        initWithNibName:@"contactsViewController"
                                        bundle:appBundle];
    UINavigationController *contacts = [[UINavigationController alloc]
                                        initWithRootViewController:con];
    homePageViewController *home = [[homePageViewController alloc]
                                        initWithNibName:@"homePageViewController"
                                        bundle:appBundle ];
    UINavigationController *homepage = [[UINavigationController alloc]
                                        initWithRootViewController:home];
    messageViewController *mess = [[messageViewController alloc]
                                      initWithNibName:@"messageViewController"
                                      bundle:appBundle];
    UINavigationController *message = [[UINavigationController alloc]
                                        initWithRootViewController:mess];
    taskManageViewController *taskt = [[taskManageViewController alloc]
                                            initWithNibName:@"taskManageViewController"
                                            bundle:appBundle];
    UINavigationController *taskManage = [[UINavigationController alloc]
                                        initWithRootViewController:taskt];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.user1.userName = _idField.text;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
 //   NSLog(@"%@",_idField.text);


    NSDictionary *dics = @{
                           @"username":_idField.text,
                           @"password":_passwordField.text
                           };
    [manager POST:@"http://112.74.54.96/login" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *getDic=[NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        NSLog(@"登录成功%@",responseObject);
        if([getDic[@"status"] isEqualToString: @"successed"]) {
            self.user1.userId=getDic[@"userId"];
            self.user1.userClass=getDic[@"userClass"];
            home.user1=self.user1;
            mess.user1=self.user1;
            con.user1=self.user1;
            taskt.user1=self.user1;
            UITabBarController *tabBar = [[UITabBarController alloc] init];
            tabBar.viewControllers = @[homepage,message,contacts,taskManage];
            [self presentViewController:tabBar animated:YES completion:nil];
    }
        else {
            //......
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败！" message: @"请检查密码和账号是否正确！"preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                        {
                                        }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败！" message: @"请检查网络连接是否正常！"preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
    
      // [self.navigationController pushViewController:tabBar animated:YES];
}
//注册账号
-(IBAction)signinButtonAction:(id)sender
{
    registerViewController *try = [[registerViewController alloc] init];
    [self presentViewController:try animated:YES completion:nil];
}
//找回密码
-(IBAction)findpsd:(id)sender{    
}
- (IBAction)endEditing:(id)sender {
    [self.idField resignFirstResponder];
    [self.passwordField resignFirstResponder];
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
