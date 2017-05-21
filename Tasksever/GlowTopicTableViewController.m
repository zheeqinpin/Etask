//
//  GlowTopicTableViewController.m
//  GlowForum
//
//  Created by zwj on 15/8/25.
//  Copyright (c) 2015年 SJTU. All rights reserved.
//

#import "GlowTopicTableViewController.h"
#import "replyViewController.h"
#import "MJRefresh.h"
#import "UIColor+Utils.h"
#import "AFNetworking.h"
#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

static NSString *GlowTopicTableViewCellIdentifier = @"topicCellIdentifer";
static NSString *GlowCommentsTableViewCellIdentifier = @"commentsCellIdentifer";

@interface GlowTopicTableViewController (){
    UIView *statusBarView;
}
@property(nonatomic)UIButton *bottomButton;
@property CGFloat offsetY;
@property (nonatomic) NSMutableArray *anwserIdList;
@end

@implementation GlowTopicTableViewController

- (void)setupData {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *jsonPath = [bundle pathForResource:@"glowdata" ofType:@"json"];
    NSData *jsonData = [[NSData alloc] initWithContentsOfFile:jsonPath];
    
    self.jsonArray = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:NULL];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    //self.jsonDict = [self.jsonArray objectAtIndex:self.rowOfData];
    // sort by time_created
    NSArray *commentsArray = [self.jsonDict1 objectForKey:@"answer"];
    //NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]];
    //[commentsArray sortedArrayUsingDescriptors:sortDescriptors];
    self.sortedCommentsArray = commentsArray ;
}
- (void)loadView {
    // Setup our TableView
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.askName;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.tableView.delegate=self;
    [self.tableView registerClass:[GlowTopicTableViewCell class] forCellReuseIdentifier:GlowTopicTableViewCellIdentifier];
    [self.tableView registerClass:[GlowCommentsTableViewCell class] forCellReuseIdentifier:GlowCommentsTableViewCellIdentifier];
    MJRefreshNormalHeader *header = [[MJRefreshNormalHeader alloc] init];
    [header setRefreshingTarget:self refreshingAction:@selector(headerClick)];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];

    [self setupData];

    self.bottomButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    self.bottomButton.frame = CGRectMake(kScreenW - 80, kScreenH - 170, 30, 30);
    
    [self.bottomButton setBackgroundImage:[UIImage imageNamed:@"edit1111.png"] forState:UIControlStateNormal];
    
    [self.bottomButton addTarget:self action:@selector(onTapLiveBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.bottomButton];
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
//点击编辑按钮
- (void)onTapLiveBtn

{
    replyViewController *reply = [[replyViewController alloc] init];
    reply.user1 = self.user1;
    reply.askId = self.askId;
    [self.navigationController pushViewController:reply animated:YES];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > self.offsetY && scrollView.contentOffset.y > 0) {//向上滑动
        
        //按钮消失
        
        [UIView transitionWithView:self.bottomButton duration:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
            
            self.bottomButton.frame = CGRectMake(kScreenW - 80, kScreenH - 65, 60, 60);
            
        } completion:NULL];
        
    }else if (scrollView.contentOffset.y < self.offsetY ){//向下滑动
        
        //按钮出现
        
        [UIView transitionWithView:self.bottomButton duration:0.1 options:UIViewAnimationOptionTransitionNone animations:^{
            
            self.bottomButton.frame = CGRectMake(kScreenW - 80, kScreenH - 170, 60, 60);
            
        } completion:NULL];
        
    }
    
    self.offsetY = scrollView.contentOffset.y;//将当前位移变成缓存位移
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"hangshu%lu",(unsigned long)[self.sortedCommentsArray count ]);
    return [self.sortedCommentsArray count]+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // first line is the topic theme
    if (indexPath.row == 0) {
        GlowTopicTableViewCell *topicCell = (GlowTopicTableViewCell *)[tableView dequeueReusableCellWithIdentifier:GlowTopicTableViewCellIdentifier forIndexPath:indexPath];
        // Load data
        [topicCell setupCellWithData:self.jsonDict2];
        //NSLog(@"%@", self.jsonDict);
        return topicCell;
    }else{
        NSLog(@"没有评论cell");
        GlowCommentsTableViewCell *commentCell = (GlowCommentsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:GlowCommentsTableViewCellIdentifier forIndexPath:indexPath];
        int theRow = indexPath.row - 1;
        commentCell.anwserId = self.anwserIdList[theRow];
        commentCell.user1 =self.user1;
        NSDictionary *sortedDict = [self.sortedCommentsArray objectAtIndex:indexPath.row-1];
        [commentCell setupCellWithData:sortedDict];
        
        return commentCell;
    }
}

// tableView的Cell自适应高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    if (indexPath.row == 0) {
        // Create our size
        CGSize topicCellSize = [GlowTopicTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<GlowResizingProtocol> cellToSetup)  {
          
           NSDictionary *dataDict = weakSelf.jsonDict2;
            [((GlowTopicTableViewCell *)cellToSetup) setupCellWithData:dataDict];
            
            return cellToSetup;
        }];
        
        return topicCellSize.height;
    }else{
        
        // Create our size
        CGSize commentCellSize = [GlowCommentsTableViewCell sizeForCellWithDefaultSize:defaultSize setupCellBlock:^id(id<GlowResizingProtocol> cellToSetup)  {
            
            NSDictionary *sortedDict = [self.sortedCommentsArray objectAtIndex:indexPath.row-1];
            [((GlowCommentsTableViewCell *)cellToSetup) setupCellWithData:sortedDict];
            
            return cellToSetup;
        }];
        return commentCellSize.height+20;
    }
}
- (void)headerClick {
    // 可在此处实现下拉刷新时要执行的代码
    // ......
    NSLog(@"headerclick");
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    
    
    NSDictionary *dic = @{
                          @"ask_id":self.askId,
                          };
    NSString *ch= [NSString alloc];
    if ([NSJSONSerialization isValidJSONObject:dic]) {
        NSError *error;
        NSData *registerData = [NSJSONSerialization dataWithJSONObject:dic options:0 error:&error];
        ch =[[NSString alloc] initWithData:registerData encoding:NSUTF8StringEncoding];
        //    NSLog(@"Register JSON:%@",ch);
    }else{
        //  NSLog(@"error");
        
    }
    NSDictionary *dics = @{
                           @"data" : ch,
                           };
    NSLog(@"##6%@",ch);
    [manager POST:@"http://112.74.54.96/getOneAsk" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"返回数据%@",responseObject);
        NSDictionary *tempdic =[NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        self.jsonDict1= tempdic[@"0"];
        self.jsonDict2 =tempdic;
        NSMutableArray *anwserIdList = [[NSMutableArray alloc] init];
        NSLog(@"anwser%@",self.jsonDict1);
        for (int i = 0; i<[tempdic[@"0"][@"answer"] count]; i++) {
            [anwserIdList addObject:tempdic[@"0"][@"answer"][i][@"id"]];
            NSLog(@"topic vc anserIDlIST%@",tempdic[@"0"][@"answer"][i][@"id"]);
        }
        self.anwserIdList = anwserIdList;
        NSArray *commentsArray = [self.jsonDict1 objectForKey:@"answer"];
        //NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"time" ascending:NO]];
        //[commentsArray sortedArrayUsingDescriptors:sortDescriptors];
        self.sortedCommentsArray = commentsArray ;

     /*   [self.questionName removeAllObjects];
        [self.questionId removeAllObjects];
        [self.projectId removeAllObjects];
        [self.projectTitle removeAllObjects];
        [self.projectDescription removeAllObjects];
        [self.projectImage removeAllObjects];
        for (int i = 0; i<[responseObject[@"data1"] count]; i++) {
            [self.questionName addObject:responseObject[@"data1"][i][@"q_name"]];
            //   NSLog(@"shuzu %@",self.finishTitleList[i]);
            [self.questionId addObject:responseObject[@"data1"][i][@"id"]];
        }
        for (int i = 0; i<[responseObject[@"data"] count]; i++) {
            [self.projectTitle addObject:responseObject[@"data"][i][@"p_name"]];
            [self.projectId addObject:responseObject[@"data"][i][@"p_id"]];
            [self.projectDescription addObject:responseObject[@"data"][i][@"p_info"]];
            [self.projectImage addObject:responseObject[@"data"][i][@"p_img"]];
        }
        __weak UITableView *tableView = self.tabletwo;
        
        [tableView reloadData];
        */
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];
    // 模拟延迟3秒
    [NSThread sleepForTimeInterval:3];
    // 结束刷新
    [self.tableView.mj_header endRefreshing];
}
//点赞上传
-(void)toggleThumb{
  /*  AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //manager.requestSerializer.timeoutInterval = 5;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    NSDictionary *dic = @{
                          @"ans_id" : ,//被点赞答案的ID
                          @"user_id" : , //点赞人的ID
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
    // NSLog(@"###%@",ch);
    [manager POST:@"http://112.74.54.96/setAnws" parameters:dics constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSDictionary *getDic=[NSDictionary dictionaryWithDictionary:(NSDictionary *)responseObject];
        //if([getDic[@"status"] isEqualToString: @"successed"]){
        //弹出上传成功 返回上一界面
        NSLog(@"###%@",responseObject);
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布成功！" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                        
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"发布失败！" message:@"请检查网络连接是否正常！" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                    {
                                        
                                    }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        NSLog(@"传输失败:%@",[error localizedDescription]);
    }];  */
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
