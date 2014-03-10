//
//  XHDrawerController.h
//  XHDrawerController
//
//  Created by 曾 宪华 on 13-12-27.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XHDrawerSide){
    XHDrawerSideNone = 0,
    XHDrawerSideLeft,
    XHDrawerSideRight,
};


@interface XHDrawerController : UIViewController

@property (nonatomic, assign, readonly) XHDrawerSide openSide;

@property (nonatomic, assign) CGFloat animateDuration;
@property (nonatomic, assign) CGFloat animationDampingDuration;
@property (nonatomic, assign) CGFloat animationVelocity;
@property (nonatomic, strong) UIViewController *centerViewController;
@property (nonatomic, strong) UIViewController *leftViewController;
@property (nonatomic, strong) UIViewController *rightViewController;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, assign, getter = isSpringAnimationOn) BOOL springAnimationOn;

#pragma mark - Open/Close methods
- (void)toggleDrawerSide:(XHDrawerSide)drawerSide animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

//这两个方法是最重要的，第一个是关闭边边的菜单，第二个是打开边边的菜单
- (void)closeDrawerAnimated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

- (void)openDrawerSide:(XHDrawerSide)drawerSide animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

@end

//这是一个给类别增添属性的方法
@interface UIViewController (XHDrawerController)

@property (nonatomic, readonly) XHDrawerController *drawerController;

@end
