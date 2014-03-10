//
//  HContentViewController.m
//  恒大
//
//  Created by YunInfo on 13-10-9.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//

#import "HContentViewController.h"


@interface HContentViewController ()

//@property(nonatomic,retain) HNewsViewController * hNewsViewController;
//@property(nonatomic,retain) HCompetitionViewController * hCompetitionViewController;
//@property(nonatomic,retain) HClubViewController * hClubViewController;
@end

@implementation HContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jumpToRightVCs:) name:@"jumpToRightVCs" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifyGoTOLeft) name:@"notifyGoTOLeft" object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    	// Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Left", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(left)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Right", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(right)];	// Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor grayColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:@"me"];
    [self.view addSubview:imageView];
}


- (void)left {
    [self.drawerController toggleDrawerSide:XHDrawerSideLeft animated:YES completion:NULL];
}

- (void)right {
    [self.drawerController toggleDrawerSide:XHDrawerSideRight animated:YES completion:^(BOOL finished) {
        
    }];
}

-(void)dealloc
{
    MSDebug(@"HContentViewController Dealloc!!!");
    self.currentController = nil;

}

-(void)jumpToRightVCs:(NSNotification*) notification
{
    NSIndexPath * indexPath = [notification.userInfo objectForKey:@"channelIndex"];
    
    switch (indexPath.row) {
    
        case 0:
        {
            
        }
        break;
        
        
        default:
            break;
    }

    
}



//这里只管刷新UI的操作，内容应该是先填充到参数中的(UIViewController*) vcToDispay的
-(void)showTheViewUsingcontroller:(UIViewController*) vcToDispay
{   
    if (vcToDispay == self.currentController) {
      //  [vcToDispay.view setNeedsDisplay];
        return;
    }
    
    if (self.currentController) {
       // [self.currentController viewWillDisappear:YES];
        [self.currentController.view removeFromSuperview];
        //[self.currentController viewDidDisappear:YES];
    }

   // [vcToDispay viewWillAppear:YES];
    [self.view addSubview:vcToDispay.view];
    //[vcToDispay viewDidAppear:YES];
    
    self.currentController = vcToDispay;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
