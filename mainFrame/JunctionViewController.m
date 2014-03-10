//
//  JunctionViewController.m
//  恒大
//
//  Created by YunInfo on 13-10-9.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//

#import "JunctionViewController.h"
#import "YTitleViewController.h"

@interface JunctionViewController ()

@end

@implementation JunctionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showVCToShowInNav:) name:@"showVCToShowInNav" object:nil];
      
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hNavBackForBTDidDown) name:@"hNavBackForBTDidDown" object:nil];
    }
    return self;
}

-(void)dealloc
{
    MSDebug(@"JunctionViewController dealloc!!!!!!!");
    [[NSNotificationCenter defaultCenter]removeObserver:nil];
    self.homeViewController = nil;
}

- (void)viewDidLoad
{
        

//HomeViewController即便自重启也不需重新初始化。
    if (!self.homeViewController) {
        
        
        HomeViewController * hVC = [[HomeViewController alloc]init];
        self.homeViewController = hVC;
        self.homeViewControllerNav =   [[UINavigationController alloc]initWithRootViewController:hVC];
        self.homeViewControllerNav.navigationBarHidden = YES;
        
        CGSize size = self.view.frame.size;
        CGRect frame = CGRectMake(0, 0, size.width, size.height);
        self.homeViewControllerNav.view.frame = frame;
        
        [self.view addSubview:self.homeViewControllerNav.view];
    }
	// Do any additional setup after loading the view.
}


#pragma mark - Nsnotifications
-(void)hNavBackForBTDidDown
{
    [self.homeViewControllerNav popViewControllerAnimated:YES];
    [self.homeViewController.hContentViewController.currentController  viewWillAppear:YES];
}

-(void)showVCToShowInNav:(NSNotification*)notification
{
    NSAssert(self.homeViewController, @"self.homeViewController == nil");
    
    YTitleViewController * vc =(YTitleViewController*) [notification.userInfo objectForKey:@"VCToShowInNav"];
    
    //TODO:
//    if([vc isKindOfClass:[YTitleViewController class]])
//    {
//        
//        [vc changeTONavStackBack];
//    }
    [self.homeViewControllerNav pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
