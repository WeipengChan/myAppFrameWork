//
//  YTitleViewController.m
//  YunMai
//
//  Created by YunInfo on 14-2-26.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import "YTitleViewController.h"

@implementation YTitleViewController


-(void)dealloc
{
    [self.hTitleView removeFromSuperview];
    self.hTitleView = nil;
    
    [self.hBackToLeftBT removeFromSuperview];
    self.hBackToLeftBT = nil;
    
    MSDebug(@"HbaseViewController Dealloc!!!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setLayerShadow
{
    self.view.layer.shadowOffset = CGSizeMake(-4.0, 4.0);
    self.view.layer.shadowRadius =  4.0;
    self.view.layer.shadowOpacity = 0.7;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    self.view.layer.shadowPath = [UIBezierPath bezierPathWithRect: self.view.layer.bounds].CGPath;
}

-(void)viewDidLoad
{
    UIImage * img =[UIImage imageNamed:@"background.png"];
    
    // MSDebug(@"viewOx%f , viewOy%f",self.view.frame.origin.x,self.view.frame.origin.y);
    // MSDebug(@"viewWidth%f , viewHeight%f",self.view.frame.size.width,self.view.frame.size.height);
    
    //意外的 self.view.frame 并非预期的那样。加到屏幕上。
    CGRect frame = self.view.frame;
    frame.origin.y = 0;
    self.view.frame = frame;
    
    // UIImage * img =[UIImage imageNamed:@"background.png"];
    UIImageView * tableViewBackgroundIV = [[UIImageView alloc]initWithFrame:frame];
    tableViewBackgroundIV.tag = 100;
    //tableViewBackgroundIV.contentMode = UIViewContentModeScaleAspectFill;
    
    tableViewBackgroundIV.image = img;
    [self.view addSubview:tableViewBackgroundIV];
    
    
    self.hTitleView = [[HTitleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, NAVBARHEIGHT)];
    
    self.hTitleView.layer.shadowOffset = CGSizeMake(0, 5.0);
    self.hTitleView.layer.shadowRadius =  2.0;
    self.hTitleView.layer.shadowOpacity =  0.0;
    self.hTitleView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.hTitleView.layer.shadowPath = [UIBezierPath bezierPathWithRect: self.hTitleView.layer.bounds].CGPath;
    
    [self.view addSubview:self.hTitleView];

    
    [self setLayerShadow];
    

}

@end
