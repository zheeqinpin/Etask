//
//  GlowTopicTableViewCell.m
//  GlowForum
//
//  Created by zwj on 15/8/25.
//  Copyright (c) 2015年 SJTU. All rights reserved.
//

#import "GlowTopicTableViewCell.h"

@interface GlowTopicTableViewCell ()

@property (nonatomic, strong) UILabel *topicLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *numberOfCommentsLabel;
@property (nonatomic, strong) UILabel *posterLabel;

@end

@implementation GlowTopicTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    
    self.backgroundColor = [UIColor whiteColor];
    self.accessoryType = UITableViewCellAccessoryNone;
    self.accessoryView = nil;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Fix for contentView constraint warning
    [self.contentView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    
    // topic label
    self.topicLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.topicLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.topicLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20];
    self.topicLabel.textColor = [UIColor blackColor];
    self.topicLabel.numberOfLines = 1;
    [self.contentView addSubview:self.topicLabel];
    
    // content label
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.contentLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.numberOfLines = 1;
    [self.contentView addSubview:self.contentLabel];
    
    // number of comments label
    self.numberOfCommentsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.numberOfCommentsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.numberOfCommentsLabel.numberOfLines = 1;
    self.numberOfCommentsLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.numberOfCommentsLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    self.numberOfCommentsLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.numberOfCommentsLabel];
    
    // poster label
    self.posterLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.posterLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.posterLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14];
    self.posterLabel.textColor = [UIColor colorWithHue:0.3 saturation:0.3 brightness:0.3 alpha:0.3];
    self.posterLabel.numberOfLines = 1;
    [self.contentView addSubview:self.posterLabel];
    
    // Constrain
    NSDictionary *viewDict = NSDictionaryOfVariableBindings(_topicLabel, _contentLabel, _numberOfCommentsLabel, _posterLabel);
    // Create a dictionary with buffer values
    NSDictionary *metricDict = @{@"sideBuffer" : @20, @"verticalBuffer" : @15};
    
    // Constrain elements horizontally
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_topicLabel]" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_contentLabel]" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_numberOfCommentsLabel]" options:0 metrics:metricDict views:viewDict]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-sideBuffer-[_posterLabel]" options:0 metrics:metricDict views:viewDict]];
    
    // Constrain elements vertically
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-verticalBuffer-[_topicLabel]-verticalBuffer-[_contentLabel]-verticalBuffer-[_numberOfCommentsLabel]-verticalBuffer-[_posterLabel]-verticalBuffer-|" options:0 metrics:metricDict views:viewDict]];
    
    [self.topicLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.topicLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.contentLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.contentLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.numberOfCommentsLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.numberOfCommentsLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [self.posterLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
    [self.posterLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    
    CGSize defaultSize = DEFAULT_CELL_SIZE;
    self.contentLabel.preferredMaxLayoutWidth = defaultSize.width - ([metricDict[@"sideBuffer"] floatValue] * 2);
}

- (void)setupCellWithData:(NSDictionary *)data {
    NSDictionary *data0 = data[@"question"];
    NSString *title = [data0 objectForKey:@"title"];
    self.topicLabel.text =title;
    
    NSString *content = [data0 objectForKey:@"content"];
    self.contentLabel.text = content;
    
    NSArray *commentsArray = data[@"0"][@"answer"];
    NSUInteger numberOfComments = [commentsArray count];
    NSMutableString *commentsAndViews = [[NSMutableString alloc] initWithFormat:@"%lu",(unsigned long)numberOfComments];

    [commentsAndViews appendString:@" Comments"];
   /* NSNumber *numberOfViews = [data objectForKey:@"views"];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *strNumberOfViews = [numberFormatter stringFromNumber:numberOfViews];
    [commentsAndViews appendString:strNumberOfViews];
    [commentsAndViews appendString:@" Views"];*/
    self.numberOfCommentsLabel.text = commentsAndViews;
    NSObject *temp0 =data0[@"user"];
    NSMutableString *posterInfo = [[NSMutableString alloc] initWithString:@"Posted by "];
    if ( temp0 ==nil) {
        NSLog(@"apped shuju");
        NSString *author = @"user";
            [posterInfo appendString:author];
            self.posterLabel.text = posterInfo;
    }
    else{
     NSString *author = [data0 objectForKey:@"user"];
            [posterInfo appendString:author];
            self.posterLabel.text = posterInfo;
    }
   

    //NSString *first_nameOfPoster = [author objectForKey:@"first_name"];

    /*NSNumber *created_time = [data objectForKey:@"create_time"];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *created = [numberFormatter stringFromNumber:created_time];
    NSString *timeAgo = [created calculateUpLoadTime];*/
 /*   NSObject *temp1 =data[@"create_time"];
    if ( temp1== nil) {
        NSString *timeAgo =@"create-time";
        [posterInfo appendString:timeAgo];
        self.posterLabel.text = posterInfo;
    }
    else
    {
        NSString *timeAgo =[data objectForKey:@"create_time"];
        [posterInfo appendString:timeAgo];
        self.posterLabel.text = posterInfo;
    }*/
   
}


@end
