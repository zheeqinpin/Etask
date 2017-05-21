//
//  upLoadFileViewController.m
//  Tasksever
//
//  Created by qingping zheng on 17/5/1.
//  Copyright © 2017年 zln. All rights reserved.
//

#import "upLoadFileViewController.h"
#import "UIColor+Utils.h"
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "GlobalVar.h"
#import "AFNetworking.h"
@interface upLoadFileViewController ()
<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIView *statusBarView;
}
@property (weak, nonatomic) IBOutlet UIImageView *addVideoImageView;
@property (weak, nonatomic) IBOutlet UILabel *videoTextField;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UITextView *othersFilesTextView;
@property (weak, nonatomic) IBOutlet UITextView *selfJudgeTextView;
@property (nonatomic) NSURL *videoUrl;
@end

@implementation upLoadFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bground = [UIImage imageNamed:@"111的副本.jpg"]; //设置背景图片
    self.view.layer.contents = (id) bground.CGImage;
    self.navigationItem.title = self.taskName;
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    self.videoTextField.text= @"添加视频文件";
   // self.videoImageView.image = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加视频按钮
    self.addVideoImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *clockddd = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClockAddVideo)];
    [self.addVideoImageView addGestureRecognizer:clockddd];
    //右边按钮
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(complete)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
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
- (IBAction)backgroundTouched:(id)sender {
    [self.view endEditing:YES];
    GlobalVar *globalVarInHandinVC = [GlobalVar globleFilePath];
    NSString *selectedFiles = @"已选中文件 ";
    if (globalVarInHandinVC.appFilePath.count) {
        for (int i = 0; i<globalVarInHandinVC.appFilePath.count; i++) {
            NSString *tempAppFilePath = globalVarInHandinVC.appFilePath[i];
            NSString *fileName = [tempAppFilePath lastPathComponent];
            selectedFiles = [selectedFiles stringByAppendingString:fileName];
            if (i != globalVarInHandinVC.appFilePath.count - 1) {
                selectedFiles = [selectedFiles stringByAppendingString:@"、"];
            }
        }
    }
    self.othersFilesTextView.text = selectedFiles;
    NSLog(@"已选中文件 ：%@",selectedFiles);
}

-(void)onClockAddVideo{
    //查找视频
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//sourcetype有三种分别是camera，photoLibrary和photoAlbum
    //NSArray *availableMedia = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];//Camera所支持的Media格式都有哪些,共有两个分别是@"public.image",@"public.movie"
    ipc.mediaTypes = [NSArray arrayWithObject:@"public.movie"];//设置媒体类型为public.movie
    
    [self presentViewController:ipc animated:YES completion:nil];
    ipc.delegate= self;//设置委托
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSURL *sourceURL = [info objectForKey:UIImagePickerControllerMediaURL];//获取视频路径
    NSLog(@"old%@",sourceURL);
    NSURL *newVideoUrl ; //一般.mp4，转码后视频路径
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉。
    NSLog(@"###############NEW%@",newVideoUrl);
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self convertVideoQuailtyWithInputURL:sourceURL outputURL:newVideoUrl completeHandler:nil];
}

- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    //  NSLog(resultPath);
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    NSString *fileName = [outputURL lastPathComponent];
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:
                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 self.videoUrl = [outputURL copy];
                 NSLog(@"选中视频%@",fileName);
                 self.videoTextField.text = fileName;
                 NSLog(@"success export");
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
     }];
    
}


-(void)complete{
    //提交所有文件
    GlobalVar *globalVarInHandinVC = [GlobalVar globleFilePath];
    if (self.videoUrl) {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        NSDictionary *params = @{@"userId" :self.user1.userId,
                                 @"englishTaskId" : self.taskId,
                                 @"answer" : self.selfJudgeTextView.text,                         };
        NSLog(@"upload dic%@",params);
        [manager POST:@"http://112.74.54.96/uploadFile" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            [formData appendPartWithFileURL:self.videoUrl name:@"file" fileName:@"video.mp4" mimeType:@"video/mp4" error:nil];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"video success");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传视频成功！" message: @" "preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                        {
                                        }]];
            [self presentViewController:alertController animated:YES completion:nil];
            [[NSFileManager defaultManager] removeItemAtPath:[self.videoUrl path] error:nil];
            NSLog(@"删除视频成功");//取消之后就删除，以免占用手机硬盘空间（沙盒）
            //self.finishSymbol.finished = 1;
            [self.navigationController popViewControllerAnimated:YES];
        }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传视频失败！" message: @"请检查网络连接！ "preferredStyle:UIAlertControllerStyleAlert];
                  [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                              {
                                              }]];
                  [self presentViewController:alertController animated:YES completion:nil];
                  NSLog(@"failed");
                  [[NSFileManager defaultManager] removeItemAtPath:[self.videoUrl path] error:nil];
                  NSLog(@"删除成功");
                  NSLog(@"%@",error);
                  /*NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
                   NSError *underError = error.userInfo[@"NSUnderlyingError"];
                   NSData *responseData = underError.userInfo[@"com.alamofire.serialization.response.error.data"];
                   id body = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
                   NSLog(@"error body :%@", body);*/
                  
              }];
    }
    if (globalVarInHandinVC.appFilePath.count > 0){
        for (int i = 0; i<globalVarInHandinVC.appFilePath.count; i++) {
            NSString *urlForAppFilePath = globalVarInHandinVC.appFilePath[i];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
            NSDictionary *params = @{@"userId" :self.user1.userId,
                                     @"englishTaskId" : self.taskId,
                                     @"answer" : self.selfJudgeTextView.text,                         };
            [manager POST:@"http://112.74.54.96/uploadFile" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                NSLog(@"有文件传输");
                //NSBundle *bundle = [NSBundle mainBundle];
                //NSString *jsonPath = [bundle pathForResource:@"CIImage" ofType:@"docx"];
                NSData *jsonData = [[NSData alloc] initWithContentsOfFile: urlForAppFilePath];
                [formData appendPartWithFileData:jsonData name:@"file" fileName:@"word.docx" mimeType:@"application/msword"];
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (i ==globalVarInHandinVC.appFilePath.count - 1) {
                    NSLog(@"success");
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传文件成功！" message: @" "preferredStyle:UIAlertControllerStyleAlert];
                    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                                {
                                                }]];
                    [self presentViewController:alertController animated:YES completion:nil];
                    [[NSFileManager defaultManager] removeItemAtPath:[self.videoUrl path] error:nil];
                    NSLog(@"删除成功");//取消之后就删除，以免占用手机硬盘空间（沙盒）
                    //self.finishSymbol.finished = 1;
                    [[GlobalVar globleFilePath] removeTheObjcet];
                    NSLog(@"gloabal vars%lu",(unsigned long)globalVarInHandinVC.appFilePath.count);
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }
                  failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传文件失败！" message: @"请检查网络连接！ "preferredStyle:UIAlertControllerStyleAlert];
                      [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action)
                                                  {
                                                  }]];
                      [self presentViewController:alertController animated:YES completion:nil];
                      NSLog(@"failed");
                      [[NSFileManager defaultManager] removeItemAtPath:[self.videoUrl path] error:nil];
                      NSLog(@"删除成功");
                      NSLog(@"%@",error);
                  }];
        }
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
