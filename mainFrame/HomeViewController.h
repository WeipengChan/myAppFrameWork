//
//  HomeViewController.h
//  恒大
//
//  Created by YunInfo on 13-10-9.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//


#import <UIKit/UIKit.h>

#import "HChannelListViewController.h"
#import "HContentViewController.h"
#import "UIInfoCenterViewController.h"

@interface HomeViewController : UIViewController

//框架的控制指挥者
@property (nonatomic, retain) XHDrawerController* sideBarController;
//框架的左右控制器
@property (nonatomic, strong) HChannelListViewController * hChannelListViewController;
@property (nonatomic, strong) HContentViewController * hContentViewController;
@property(nonatomic,strong)  UIInfoCenterViewController * hInfoCenterController;


//
-(void)setMainBacground:(UIImage*)img;
@end
