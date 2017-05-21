//
//  registerViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/4/15.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "registerViewController.h"
#import "UIColor+Utils.h"
#import "AFNetworking.h"
@interface registerViewController ()

@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UIButton *backToLoginPageButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordAgainTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation registerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bground = [UIImage imageNamed:@"111的副本.jpg"]; //设置背景图片
    self.view.layer.contents = (id) bground.CGImage;
   //self.registerButton.backgroundColor = [UIColor colorWithRGBValue:0x1093f6];
    self.registerButton.layer.cornerRadius = 2;
    self.navBarView.backgroundColor= [UIColor colorWithRGBValue:0x1093f6];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)backToLoginPageAction:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)endEditing:(id)sender {
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.passwordAgainTextField resignFirstResponder];
}
-(IBAction)registerAction:(id)sender{
    if(!_userNameTextField.text || _userNameTextField.text.length == 0 ||
       !_passwordTextField.text || _passwordTextField.text.length == 0 ||
       !_passwordAgainTextField.text || _passwordAgainTextField.text.length == 0){
        //默认头像
        UIImage *image = [[UIImage alloc] init];
        image = [UIImage imageNamed:@"bg.png"];
        //图片转字符串
        NSData *data = UIImageJPEGRepresentation(image, 1.0f);
        NSString *encodeImageStr= [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册失败！" message: @"请检查信息是否填写完整？"preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        if (_passwordTextField.text != _passwordAgainTextField.text) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册失败！" message: @"密码填写不一致，请检查！"preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                        {
                                        }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }else{
            //.....
            //添加注册账号代码
            //.....
            NSLog(@"###%@",_userNameTextField.text);
            NSLog(@"###%@",_passwordTextField.text);
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            //manager.requestSerializer.timeoutInterval = 5;
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
            NSDictionary *dic = @{
                                  @"username":_userNameTextField.text,
                                  @"password":_passwordTextField.text,
                                  
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
            [manager POST:@"http://112.74.54.96/register" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"返回成功好友列表%@",responseObject);
                NSDictionary *getDic=[NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
                if([getDic[@"status"] isEqualToString: @"success"]){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册成功！" message: @""preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                                {
                                                }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                
                }else if([getDic[@"status"] isEqualToString: @"error"]){
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册失败！" message: @"用户名已存在！"preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                                {
                                                }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                    
                }

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"传输失败:%@",[error localizedDescription]);
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注册失败！" message: @"请检查网络连接状况！"preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                            {
                                            }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        }
        }
    
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
