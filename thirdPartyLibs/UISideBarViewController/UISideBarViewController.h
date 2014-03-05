//
//  UISideBarViewController.h
//  21CNNews
//
//  Created by chenggk on 13-4-4.
//  Copyright (c) 2013年 21cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UISideBarSubViewController.h"


@interface UISideBarViewController : UIViewController<SideBarViewSelectedDelegate>

@property (nonatomic, retain) UISideBarSubViewController* leftSideBarViewController;
@property (nonatomic, retain) UISideBarSubViewController* rightSideBarViewController;
@property (nonatomic, retain) UISideBarSubViewController* contentViewController;

@property (nonatomic, readwrite) CGFloat contentOffset;

//还对方向转换做了适配
- (void)didRotateFromInterfaceOrientation;

@end
