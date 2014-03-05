//
//  HomeViewController.m
//  恒大
//
//  Created by YunInfo on 13-10-9.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//

#import "HomeViewController.h"



@interface HomeViewController ()

@end

@implementation HomeViewController


-(void)dealloc
{
    MSDebug(@"HomeViewController Dealloc!!!!");
    self.sideBarController = nil;
    self.hChannelListViewController = nil;
    self.hContentViewController = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    if (!self.sideBarController) {
        CGSize size = self.view.frame.size;
        CGRect frame = CGRectMake(0, 0, size.width, size.height);
        
        self.sideBarController = [[UISideBarViewController alloc]init];
        self.hChannelListViewController = [[HChannelListViewController alloc]init];
        self.hContentViewController = [[HContentViewController alloc]init];
        
        self.sideBarController.view.frame = frame;
        self.hChannelListViewController.view.frame = frame;
        self.hContentViewController.view.frame = frame;
        
        
        
        self.sideBarController.leftSideBarViewController = self.hChannelListViewController;
        self.sideBarController.contentViewController = self.hContentViewController;
        
        
        self.hChannelListViewController.delegate = self.sideBarController;
        self.hContentViewController.delegate = self.sideBarController;
    
        [self.view addSubview:_sideBarController.view];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
