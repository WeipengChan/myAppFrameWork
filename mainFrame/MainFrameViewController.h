//
//  MainFrameViewController.h
//  恒大
//
//  Created by YunInfo on 13-10-9.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@interface MainFrameViewController : UIViewController


@property(nonatomic,retain)UINavigationController * homeViewControllerNav;
@property(nonatomic,assign)HomeViewController * homeViewController;
@end
