//
//  wenjiankuViewController.m
//  Tasksever
//
//  Created by 云英杰 on 2017/5/18.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "wenjiankuViewController.h"
#import "UIColor+Utils.h"
@interface wenjiankuViewController (){
    UIView *statusBarView;
}

@end

@implementation wenjiankuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"文件库";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    UIImage *rightButtonIcon = [[UIImage imageNamed:@"barbuttonicon_add"]
                                imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithImage:rightButtonIcon
                                    style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(addNewFiles)];
    self.navigationItem.rightBarButtonItem = rightButton;
    // Do any additional setup after loading the view from its nib.
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
-(void)addNewFiles{
    
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
