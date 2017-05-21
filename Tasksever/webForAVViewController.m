//
//  webForAVViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/3/23.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "webForAVViewController.h"
#import <WebKit/WebKit.h>
@interface webForAVViewController ()

@end

@implementation webForAVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //编辑问卷
    if(self.a == 1){
      //  NSString *tempString = [self.id1 componentsJoinedByString:@";"];
        NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"%@%@", @"http://112.74.54.96/question/", self.publisherId ];
        NSMutableString *strr = [[NSMutableString alloc] initWithFormat:@"%@/%@", str,self.projectId];
        NSLog(@"####%@",strr);
        UIWebView * view = [[UIWebView alloc]initWithFrame:self.view.frame];
        [view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strr]]];
        [self.view addSubview:view];
    //填写问卷
    }else if(self.a==2){
        NSString *str = [[NSMutableString alloc] init];
        NSString *strr = [[NSMutableString alloc] init];
        str = [[NSString alloc] initWithFormat:@"%@%@", @"http://112.74.54.96/showQuestion/", self.userId ];
        strr =[[NSString alloc] initWithFormat:@"%@/%@", str, self.qusetionId];
        NSLog(@"##%@",strr);
        UIWebView * view = [[UIWebView alloc]initWithFrame:self.view.frame];
        [view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strr]]];
        [self.view addSubview:view];
    //查看一般任务并评价
    }else if(self.a==3){
        NSMutableString *strr = [[NSMutableString alloc] init];
        strr = [[NSMutableString alloc] initWithFormat:@"%@%@", @"http://112.74.54.96/showTask/", self.commitId ];
        UIWebView * view = [[UIWebView alloc]initWithFrame:self.view.frame];
        [view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strr]]];
        NSLog(@"####$$$ %@",strr);
        [self.view addSubview:view];
    //查看任务评价
    } else if(self.a ==4 ){
        NSString *strr = [[NSMutableString alloc] init];
        strr = [[NSString alloc] initWithFormat:@"%@%@", @"http://112.74.54.96/myShowTask/", self.str12 ];
        UIWebView * view = [[UIWebView alloc]initWithFrame:self.view.frame];
        [view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strr]]];
        NSLog(@"####$$$ %@",strr);
        [self.view addSubview:view];
    //查看问卷统计
    }else if(self.a == 5){
        NSString *strr = [[NSMutableString alloc] init];
        strr = [[NSString alloc] initWithFormat:@"%@%@", @"http://112.74.54.96/lookQuestion/", self.questId ];
        UIWebView * view = [[UIWebView alloc]initWithFrame:self.view.frame];
        [view loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:strr]]];
        NSLog(@"####$$$ %@",strr);
        [self.view addSubview:view];
    }
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
