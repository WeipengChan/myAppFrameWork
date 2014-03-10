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
    self.hInfoCenterController = nil;
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
        
        self.sideBarController = [[XHDrawerController alloc]init];
         self.sideBarController.springAnimationOn = YES;
      
        self.hChannelListViewController = [[HChannelListViewController alloc]init];
        self.hContentViewController = [[HContentViewController alloc]init];
        self.hInfoCenterController = [[UIInfoCenterViewController alloc]init];
        
        self.sideBarController.view.frame = frame;
        self.hChannelListViewController.view.frame = frame;
        self.hContentViewController.view.frame = frame;
        
        
        
        self.sideBarController.leftViewController = self.hChannelListViewController;
        UINavigationController * nav= [[UINavigationController alloc] initWithRootViewController:self.hContentViewController];
        //nav.navigationBarHidden = YES;
        
        self.sideBarController.centerViewController = nav;
        self.sideBarController.rightViewController = self.hInfoCenterController;
      
    
        [self.view addSubview:_sideBarController.view];
        
        [self setMainBacground:nil];
    }
}


-(void)setMainBacground:(UIImage*)img
{
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MenuBackground"]];
    [backgroundImageView setContentMode:UIViewContentModeCenter];
    self.sideBarController.backgroundView = backgroundImageView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
