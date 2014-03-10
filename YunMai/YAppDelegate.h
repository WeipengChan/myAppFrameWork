//
//  YAppDelegate.h
//  YunMai
//
//  Created by YunInfo on 14-2-26.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JunctionViewController.h"
#import "CoreDataAppDelegate.h"

@interface YAppDelegate : CoreDataAppDelegate <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JunctionViewController * JunctionViewController;

@end
