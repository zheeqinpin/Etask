//
//  groupInformationViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/5/1.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "groupInformationViewController.h"
#import "UIColor+Utils.h"
@interface groupInformationViewController (){
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UITextField *groupTitleTextField;
@property (weak, nonatomic) IBOutlet UITextField *numberOfGroupTextField;
@property (weak, nonatomic) IBOutlet UITextField *publishNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descraptionOfGroupTextView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation groupInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bground = [UIImage imageNamed:@"111的副本.jpg"]; //设置背景图片
    self.view.layer.contents = (id) bground.CGImage;
    //头像
    self.avatarImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatarImageView.layer.borderWidth = 4;
    self.avatarImageView.layer.cornerRadius = 60.5;
    self.avatarImageView.layer.masksToBounds = true;
    // Do any additional setup after loading the view from its nib.
    _groupTitleTextField.text = [NSString stringWithFormat:@"群组名称：%@",self.projectTitle];
    _numberOfGroupTextField.text = [NSString stringWithFormat:@"群组序号：%@", self.projectId];
    _publishNameTextField.text = [NSString stringWithFormat:@"创建者：%@", self.publishName];
    _descraptionOfGroupTextView.text = self.projectDescription;
    NSData * decodedImageData = [[NSData alloc] initWithBase64EncodedString:self.projectImageString options:(NSDataBase64DecodingIgnoreUnknownCharacters)];
    UIImage *decodedImage = [UIImage imageWithData:decodedImageData];
    self.avatarImageView.image = decodedImage;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
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
