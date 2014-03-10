//
//  YAppDelegate.m
//  YunMai
//
//  Created by YunInfo on 14-2-26.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import "YAppDelegate.h"

//model Data class
#import "ArticleContentObject.h"
#import "PictureOfArticle.h"

@implementation YAppDelegate

@synthesize window = _window;


#pragma mark -  异步网络请求测试
-(void)asynHttptest
{
    HttpRequestManager * hrm = [[HttpRequestManager alloc]init];
    [hrm loadArticleContentUsingArticleId:26649465];
    hrm.httpRequestFinishedNSDictionaryBlock = ^(NSDictionary * dict){
        
        MSDebug(@"%@",dict);
       // NSMutableArray * array = [[NSMutableArray alloc]init];
       ArticleContentObject * object = [ArticleContentObject MR_createInContext:self.managedObjectContext];
        [object setValuesForKeysWithDictionary:dict];
        [self.managedObjectContext MR_saveToPersistentStoreAndWait];
        
    };
    
    //
    // [self asynHttptest];
    
    NSArray *  array2 = [PictureOfArticle MR_findAllInContext:self.managedObjectContext];
    
    ArticleContentObject *  a1 = [ArticleContentObject MR_findFirst];
    
    
    MSDebug(@"a1.pictureListSet%@ count:%d",a1.pictureListSet,a1.pictureListSet.count);
    
    PictureOfArticle * p2 = [[a1.pictureListSet allObjects]objectAtIndex:0];
    
    MSDebug(@"%@",p2);
    
    MSDebug(@"%@",array2);
    
    //p2 和 array2 里的第一个对象描述是一样的
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self pushToMainController];
   

    return YES;
}

-(void)pushToMainController
{
    self.JunctionViewController = [[JunctionViewController alloc]init];
 
    [self setWindowViewVontrollerto:self.JunctionViewController];
    
}

-(void)setWindowViewVontrollerto:(UIViewController*)vc
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    //[ui]
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [super applicationWillTerminate:application];
}

@end
