//
//  bianjiwendaViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/4/30.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "bianjiwendaViewController.h"
#import "UIColor+Utils.h"
#import "AFNetworking.h"
@interface bianjiwendaViewController (){
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UITextView *timuTextView;
@property (weak, nonatomic) IBOutlet UITextView *wentimiaoshuTextView;
@end

@implementation bianjiwendaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bground = [UIImage imageNamed:@"111的副本.jpg"]; //设置背景图片
    self.view.layer.contents = (id) bground.CGImage;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationItem.title = @"发布问题";
    //问题
    _timuTextView.textColor=[UIColor lightGrayColor];//设置提示内容颜色
    _timuTextView.text=NSLocalizedString(@"标题（必填），4-40字", nil);//提示语
    _timuTextView.selectedRange=NSMakeRange(0,0) ;//光标起始位置
    _timuTextView.delegate=self;//代理
    self.automaticallyAdjustsScrollViewInsets = NO;
    //问题描述
    _wentimiaoshuTextView.textColor=[UIColor lightGrayColor];//设置提示内容颜色
    _wentimiaoshuTextView.text=NSLocalizedString(@"问题描述（必填），15-500字", nil);//提示语
    _wentimiaoshuTextView.selectedRange=NSMakeRange(0,0) ;//光标起始位置
    _wentimiaoshuTextView.delegate=self;//代理
    //右边按钮
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    // Do any additional setup after loading the view from its nib.
}- (void)viewWillAppear:(BOOL)animated {
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
- (void)textViewDidChangeSelection:(UITextView *)textView{
        if (textView.textColor==[UIColor lightGrayColor])//如果是提示内容，光标放置开始位置
        {
            NSRange range;
            range.location = 0;
            range.length = 0;
            textView.selectedRange = range;
        }
    }
- (IBAction)endEditing:(id)sender {
    [self.timuTextView resignFirstResponder];
    [self.wentimiaoshuTextView resignFirstResponder];
}
                                                 
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
        if (![text isEqualToString:@""]&&textView.textColor==[UIColor lightGrayColor])//如果不是delete响应,当前是提示信息，修改其属性
        {
            textView.text=@"";//置空
            textView.textColor=[UIColor blackColor];
        }
        return YES;
    }
- (void)textViewDidChange:(UITextView *)textView{
        if ([textView.text isEqualToString:@""])
        {
            textView.textColor=[UIColor lightGrayColor];
            textView.text=NSLocalizedString(@"", nil);
        }
}
-(void)complete{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSDictionary *dic = @{
                          @"userId" : self.user1.userId,
                          @"projectId" : self.projectId,
                          @"title" : self.timuTextView.text,
                          @"content": self.wentimiaoshuTextView.text,
                          };
    NSString *ch= [NSString alloc];
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        ch =[[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
        // NSLog(@"Register JSON:%@",ch);
    }else{
        NSLog(@"error");
        
    }
    NSDictionary *dics = @{
                           @"data" : ch,
                           };
     NSLog(@"###%@",ch);
    [manager POST:@"http://112.74.54.96/setAsks" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSDictionary *getDic=[NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        //if([getDic[@"status"] isEqualToString: @"successed"]){
        //弹出上传成功 返回上一界面
        NSLog(@"###%@",responseObject);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布成功！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        
                                   //     [self.navigationController popToRootViewControllerAnimated:YES];
                                        
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布失败！" message:@"请检查网络连接是否正常！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
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
