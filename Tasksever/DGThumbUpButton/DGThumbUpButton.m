//
//  DGThumbUpButton.m
//  DGThumbUpButton
//
//  Created by Desgard_Duan on 16/6/9.
//  Copyright © 2016年 Desgard_Duan. All rights reserved.
//

#import "DGThumbUpButton.h"
#import "DGExplodeAnimationView.h"
#import "AFNetworking.h"

@interface DGThumbUpButton() {
    BOOL isSelected;
}

@property (strong, nonatomic) DGExplodeAnimationView *explodeAnimationView;

@end

@implementation DGThumbUpButton


#pragma mark - Freedom Initial
- (instancetype) initWithFrame: (CGRect)frame isPress: (BOOL)press type: (DGThumbUpButtonType)type {
    self = [super initWithFrame: frame];
    isSelected = press;
    if (isSelected) {
        [self setImage: [UIImage imageNamed: @"Like-Blue.png"] forState: UIControlStateNormal];
    } else {
        [self setImage: [UIImage imageNamed: @"Like-PlaceHold.png"] forState: UIControlStateNormal];
    }
    
    [self addTarget: self
             action: @selector(clickButtonPress)
   forControlEvents: UIControlEventTouchUpInside];
    
    [self insertSubview: self.explodeAnimationView atIndex: 0];
    
    return self;
}

- (instancetype) initWithFrame: (CGRect)frame isPress: (BOOL)press {
    self = [self initWithFrame: frame
                       isPress: press
                          type: DGThumbUpExplosionType];
    return self;
}

#pragma mark - Override
- (instancetype) initWithFrame: (CGRect) frame {
    self = [self initWithFrame: frame
                       isPress: NO
                          type: DGThumbUpExplosionType];
    return self;
}

- (instancetype) init {
    self = [self initWithFrame: CGRectMake(0, 0, 30, 30)
                       isPress: NO
                          type: DGThumbUpExplosionType];
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Methods
- (void) clickButtonPress {
    if (isSelected) {
        [self popInsideWithDuration: 0.5];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //manager.requestSerializer.timeoutInterval = 5;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        NSDictionary *dic = @{
                              @"ans_id" :self.anwserId,//被点赞答案的ID
                              @"user_id" : self.user1.userId ,//点赞人的ID
                              };
        /*NSString *ch= [NSString alloc];
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
         NSLog(@"###%@",ch);*/
        [manager POST:@"http://112.74.54.96/toggleThumb" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"###点赞返回%@",responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"点赞失败:%@",[error localizedDescription]);
        }];
    }
    else {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //manager.requestSerializer.timeoutInterval = 5;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        NSDictionary *dic = @{
                              @"ans_id" : self.anwserId,//被点赞答案的ID
                              @"user_id" :self.user1.userId ,//点赞人的ID
                              };
        [manager POST:@"http://112.74.54.96/toggleThumb" parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"###点赞返回%@",responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"点赞失败:%@",[error localizedDescription]);
        }];

        [self popOutsideWithDuration: 0.5];
        [self.explodeAnimationView animate];
    };
}

- (void) popOutsideWithDuration: (NSTimeInterval) duringTime {
    __weak typeof(self) weakSelf = self;
    self.transform = CGAffineTransformIdentity;
    
    [UIView animateKeyframesWithDuration: duringTime delay: 0 options: 0 animations: ^{
        [weakSelf setImage: [UIImage imageNamed: @"Like-Blue.png"] forState: UIControlStateNormal];
        [UIView addKeyframeWithRelativeStartTime: 0
                                relativeDuration: 1 / 3.0
                                      animations: ^{
                                          typeof(self) strongSelf = weakSelf;
                                          strongSelf.transform = CGAffineTransformMakeScale(1.5, 1.5);
                                      }];
        [UIView addKeyframeWithRelativeStartTime: 1 / 3.0
                                relativeDuration: 1 / 3.0
                                      animations: ^{
                                          typeof(self) strongSelf = weakSelf;
                                          strongSelf.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                      }];
        [UIView addKeyframeWithRelativeStartTime: 2 / 3.0
                                relativeDuration: 1 / 3.0
                                      animations: ^{
                                          typeof(self) strongSelf = weakSelf;
                                          strongSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      }];
    } completion: ^(BOOL finished) {
        isSelected = YES;
    }];
}

- (void) popInsideWithDuration: (NSTimeInterval) duringTime {
    __weak typeof(self) weakSelf = self;
    self.transform = CGAffineTransformIdentity;
    
    [UIView animateKeyframesWithDuration: duringTime delay: 0 options: 0 animations: ^{
        [weakSelf setImage: [UIImage imageNamed: @"Like-PlaceHold.png"] forState: UIControlStateNormal];
        [UIView addKeyframeWithRelativeStartTime: 0
                                relativeDuration: 1 / 2.0
                                      animations: ^{
                                          typeof(self) strongSelf = weakSelf;
                                          strongSelf.transform = CGAffineTransformMakeScale(0.8, 0.8);
                                      }];
        [UIView addKeyframeWithRelativeStartTime: 1 / 2.0
                                relativeDuration: 1 / 2.0
                                      animations: ^{
                                          typeof(self) strongSelf = weakSelf;
                                          strongSelf.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                      }];
    } completion: ^(BOOL finished) {
        isSelected = NO;
    }];

}

#pragma mark - Lazy Init
- (DGExplodeAnimationView *) explodeAnimationView {
    if (!_explodeAnimationView) {
        _explodeAnimationView = [[DGExplodeAnimationView alloc] initWithFrame: self.bounds];
    }
    return _explodeAnimationView;
}

@end
