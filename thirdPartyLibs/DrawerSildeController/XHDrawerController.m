//
//  XHDrawerController.m
//  XHDrawerController
//
//  Created by 曾 宪华 on 13-12-27.
//  Copyright (c) 2013年 曾宪华 开发团队(http://iyilunba.com ) 本人QQ:543413507. All rights reserved.
//

#import "XHDrawerController.h"
#import "XHZoomDrawerView.h"
#import "XHDrawerControllerHeader.h"

#import <objc/runtime.h>

static const CGFloat XHAnimateDuration = 0.3f;
static const CGFloat XHAnimationDampingDuration = 0.5f;
static const CGFloat XHAnimationVelocity = 20.f;


const char *XHDrawerControllerKey = "XHDrawerControllerKey";

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

//这是一个给类别增添属性的方法，使用objc runtime
@implementation UIViewController (XHDrawerController)

- (XHDrawerController *)drawerController {
    XHDrawerController *panDrawerController = objc_getAssociatedObject(self, &XHDrawerControllerKey);
    if (!panDrawerController) {
        panDrawerController = self.parentViewController.drawerController;
    }
    
    return panDrawerController;
}


- (void)setDrawerController:(XHDrawerController *)drawerController {
    objc_setAssociatedObject(self, &XHDrawerControllerKey, drawerController, OBJC_ASSOCIATION_ASSIGN);
}

@end


@interface XHDrawerController () <UIScrollViewDelegate>
@property (nonatomic, assign, readwrite) XHDrawerSide openSide;

@property (nonatomic, strong) XHZoomDrawerView *zoomDrawerView;

@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, assign) NSInteger cuurrentContentOffsetX;

//添加抽拉的手势
@property (nonatomic, retain) UIPanGestureRecognizer* tractPanGestureRecognizer;
@property (nonatomic, assign) CGFloat currentTranslate;

@end

@implementation XHDrawerController

#pragma mark - UIViewController Overrides

- (void)_setup {
    self.animateDuration = XHAnimateDuration;
    self.animationDampingDuration = XHAnimationDampingDuration;
    self.animationVelocity = XHAnimationVelocity;
    self.openSide = XHDrawerSideNone;
}

- (id)init {
    self = [super init];
    if (self) {
        [self _setup];
    }
    return self;
}

- (void)loadView {
    _zoomDrawerView = [[XHZoomDrawerView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.zoomDrawerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.zoomDrawerView.autoresizesSubviews = YES;
    self.view = self.zoomDrawerView;
}

- (void)viewDidLoad {
    self.zoomDrawerView.scrollView.delegate = self;
    self.zoomDrawerView.contentContainerButton.userInteractionEnabled = NO;
    [self.zoomDrawerView.contentContainerButton addTarget:self action:@selector(contentContainerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //手势
    self.tractPanGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panInContentView:)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Open/Close methods

- (void)toggleDrawerSide:(XHDrawerSide)drawerSide animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    NSParameterAssert(drawerSide != XHDrawerSideNone);
    if(self.openSide == XHDrawerSideNone){
        [self openDrawerSide:drawerSide animated:animated completion:completion];
    } else {
        if((drawerSide == XHDrawerSideLeft &&  self.openSide == XHDrawerSideLeft)
           ||  (drawerSide == XHDrawerSideRight && self.openSide == XHDrawerSideRight))
        {
               [self closeDrawerAnimated:animated completion:completion];
        }
        else if(completion) {
            completion(NO);
        }
    }
}

//这一层将插入手势。
- (void)closeDrawerAnimated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    
    //add @ 2014年02月07日14:45:10
    [self.view removeGestureRecognizer:self.tractPanGestureRecognizer];

    
    [self closeDrawerAnimated:animated velocity:self.animationVelocity animationOptions:UIViewAnimationOptionCurveEaseInOut completion:completion];
}

//关闭边边的菜单
- (void)closeDrawerAnimated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion {
    
  
    
    CGFloat damping = [self isSpringAnimationOn] ? 0.7f : 1.0f;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:damping initialSpringVelocity:velocity options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [self.scrollView setContentOffset:CGPointMake(XHContentContainerViewOriginX, 0.0f) animated:NO];
        } completion:^(BOOL finished) {
            self.openSide = XHDrawerSideNone;
            self.zoomDrawerView.contentContainerButton.userInteractionEnabled = NO;
            if (completion) {
                completion(finished);
            }
        }];
    } else {
        [UIView animateWithDuration:0.3 delay:0 options:options animations:^{
            [self.scrollView setContentOffset:CGPointMake(XHContentContainerViewOriginX, 0.0f) animated:NO];
        } completion:^(BOOL finished) {
            self.openSide = XHDrawerSideNone;
            self.zoomDrawerView.contentContainerButton.userInteractionEnabled = NO;
            if (completion) {
                completion(finished);
            }
        }];
    }
}

//打开边边的菜单
- (void)openDrawerSide:(XHDrawerSide)drawerSide animated:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    NSParameterAssert(drawerSide != XHDrawerSideNone);
    
    //add @ 2014年02月07日14:45:10
    [self.view addGestureRecognizer:self.tractPanGestureRecognizer];
    
    
    [self openDrawerSide:drawerSide animated:animated velocity:self.animationVelocity animationOptions:UIViewAnimationOptionCurveEaseInOut completion:completion];
}

#define RIGHTSIDE (CGRectGetWidth(self.scrollView.frame)+50)

- (void)openDrawerSide:(XHDrawerSide)drawerSide animated:(BOOL)animated velocity:(CGFloat)velocity animationOptions:(UIViewAnimationOptions)options completion:(void (^)(BOOL finished))completion {
    NSParameterAssert(drawerSide != XHDrawerSideNone);
    self.openSide = drawerSide;
    
    CGFloat damping = [self isSpringAnimationOn] ? 0.7f : 1.0f;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:damping initialSpringVelocity:velocity options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            if (drawerSide == XHDrawerSideLeft) {
                [self.scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
            } else if (drawerSide == XHDrawerSideRight) {
                [self.scrollView setContentOffset:CGPointMake(RIGHTSIDE, 0.0f) animated:NO];
            }
        } completion:^(BOOL finished) {
            self.openSide = drawerSide;
            self.zoomDrawerView.contentContainerButton.userInteractionEnabled = YES;
            if (completion) {
                completion(finished);
            }
        }];
    } else {
        [UIView animateWithDuration:0.3 delay:0 options:options animations:^{
            if (drawerSide == XHDrawerSideLeft) {
                [self.scrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
            } else if (drawerSide == XHDrawerSideRight) {
                [self.scrollView setContentOffset:CGPointMake(RIGHTSIDE, 0.0f) animated:NO];
            }
            
        } completion:^(BOOL finished) {
            self.openSide = drawerSide;
            self.zoomDrawerView.contentContainerButton.userInteractionEnabled = YES;
            if (completion) {
                completion(finished);
            }
        }];
    }
}

#pragma mark - Accessors

- (void)setBackgroundView:(UIView *)backgroundView {
    self.zoomDrawerView.backgroundView = backgroundView;
}

- (UIView *)backgroundView {
    return self.zoomDrawerView.backgroundView;
}

- (UIScrollView *)scrollView {
    return self.zoomDrawerView.scrollView;
}

//这个方法要做形变适配，因为一开始设置进来的视图都处于原始状态。
- (void)setCenterViewController:(UIViewController *)centerViewController {
    if (![self isViewLoaded]) {
        [self view];
    }
    UIViewController *currentContentViewController =self.centerViewController;
    _centerViewController = centerViewController;
    
    UIView *contentContainerView = self.zoomDrawerView.contentContainerView;
    CGAffineTransform currentTransform = [contentContainerView transform];
    [contentContainerView setTransform:CGAffineTransformIdentity];
    
    [self replaceController:currentContentViewController
              newController:self.centerViewController
                  container:self.zoomDrawerView.contentContainerView];
    
    [contentContainerView setTransform:currentTransform];
    [self.zoomDrawerView setNeedsLayout];
}

- (void)setLeftViewController:(UIViewController *)leftViewController {
    if (![self isViewLoaded]) {
        [self view];
    }
    UIViewController *currentLeftViewController = self.leftViewController;
    _leftViewController = leftViewController;
    [self replaceController:currentLeftViewController
              newController:self.leftViewController
                  container:self.zoomDrawerView.leftContainerView];
}

- (void)setRightViewController:(UIViewController *)rightViewController {
    if (![self isViewLoaded]) {
        [self view];
    }
    UIViewController *currentLeftViewController = self.rightViewController;
    _rightViewController = rightViewController;
    [self replaceController:currentLeftViewController
              newController:self.rightViewController
                  container:self.zoomDrawerView.rightContainerView];
}


#pragma mark - Instance Methods

- (void)contentContainerButtonPressed:(id)sender {
    [self closeDrawerAnimated:YES completion:NULL];
}

- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController container:(UIView *)container
{
    if (newController) {
        [self addChildViewController:newController];
        [[newController view] setFrame:[container bounds]];
        [newController setDrawerController:self];
        
        if (oldController) {
            [self transitionFromViewController:oldController toViewController:newController duration:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:nil completion:^(BOOL finished) {
                
                [newController didMoveToParentViewController:self];
                
                [oldController willMoveToParentViewController:nil];
                [oldController removeFromParentViewController];
                [oldController setDrawerController:nil];
                
            }];
        } else {
            [container addSubview:[newController view]];
            [newController didMoveToParentViewController:self];
        }
    } else {
        [[oldController view] removeFromSuperview];
        [oldController willMoveToParentViewController:nil];
        [oldController removeFromParentViewController];
        [oldController setDrawerController:nil];
    }
}

- (void)updateContentContainerButton {
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGFloat contentOffsetX = contentOffset.x;
    if (contentOffsetX < XHContentContainerViewOriginX) {
        self.zoomDrawerView.contentContainerButton.userInteractionEnabled = YES;
    } else if (contentOffsetX > XHContentContainerViewOriginX) {
        self.zoomDrawerView.contentContainerButton.userInteractionEnabled = YES;
    } else {
        self.zoomDrawerView.contentContainerButton.userInteractionEnabled = NO;
    }
}

#pragma mark - UIScrollViewDelegate Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.cuurrentContentOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint contentOffset = [scrollView contentOffset];
    
    CGFloat currentContentOffsetX = contentOffset.x;
    if (currentContentOffsetX > 0 && currentContentOffsetX < XHContentContainerViewOriginX && self.cuurrentContentOffsetX > currentContentOffsetX) {
        self.openSide = XHDrawerSideLeft;
    } else if (currentContentOffsetX > XHContentContainerViewOriginX && currentContentOffsetX < (XHContentContainerViewOriginX * 2) && self.cuurrentContentOffsetX < currentContentOffsetX) {
        self.openSide = XHDrawerSideRight;
    }
    
    CGFloat contentOffsetX = 0.0;
    if (self.openSide == XHDrawerSideRight) {
        contentOffsetX = XHContentContainerViewOriginX * 2 - contentOffset.x;
    } else if (self.openSide == XHDrawerSideLeft) {
        contentOffsetX = contentOffset.x;
    }
    
    
    CGFloat contentContainerScale = powf((contentOffsetX + XHContentContainerViewOriginX) / (XHContentContainerViewOriginX * 2.0f), .5f);
    if (isnan(contentContainerScale)) {
        contentContainerScale = 0.0f;
    }

    CGAffineTransform contentContainerViewTransform = CGAffineTransformMakeScale(contentContainerScale, contentContainerScale);
    CGAffineTransform leftContainerViewTransform = CGAffineTransformMakeTranslation(contentOffsetX / 1.5f, 0.0f);
    CGAffineTransform rightContainerViewTransform = CGAffineTransformMakeTranslation(contentOffsetX / -1.5f, 0.0f);
    
    self.zoomDrawerView.contentContainerView.transform = contentContainerViewTransform;
    
    self.zoomDrawerView.leftContainerView.transform = leftContainerViewTransform;
    self.zoomDrawerView.leftContainerView.alpha = 1 - contentOffsetX / XHContentContainerViewOriginX;
    
    self.zoomDrawerView.rightContainerView.transform = rightContainerViewTransform;
    self.zoomDrawerView.rightContainerView.alpha = 1 - contentOffsetX / XHContentContainerViewOriginX;
    
    if (self.openSide == XHDrawerSideLeft) {
        static BOOL leftContentViewControllerVisible = NO;
        if (contentOffsetX >= XHContentContainerViewOriginX) {
            if (leftContentViewControllerVisible) {
                [self.leftViewController beginAppearanceTransition:NO animated:YES];
                [self.leftViewController endAppearanceTransition];
                leftContentViewControllerVisible = NO;
                if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                    [self setNeedsStatusBarAppearanceUpdate];
            }
        } else if (contentOffsetX < XHContentContainerViewOriginX && !leftContentViewControllerVisible) {
            [self.leftViewController beginAppearanceTransition:YES animated:YES];
            leftContentViewControllerVisible = YES;
            [self.leftViewController endAppearanceTransition];
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                [self setNeedsStatusBarAppearanceUpdate];
        }
    } else if (self.openSide == XHDrawerSideRight) {
        static BOOL rightContentViewControllerVisible = NO;
        if (contentOffsetX >= XHContentContainerViewOriginX) {
            if (rightContentViewControllerVisible) {
                [self.rightViewController beginAppearanceTransition:NO animated:YES];
                [self.rightViewController endAppearanceTransition];
                rightContentViewControllerVisible = NO;
                if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                    [self setNeedsStatusBarAppearanceUpdate];
            }
        } else if (contentOffsetX < XHContentContainerViewOriginX && !rightContentViewControllerVisible) {
            [self.rightViewController beginAppearanceTransition:YES animated:YES];
            rightContentViewControllerVisible = YES;
            [self.rightViewController endAppearanceTransition];
            if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
                [self setNeedsStatusBarAppearanceUpdate];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self updateContentContainerButton];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self updateContentContainerButton];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    CGFloat targetContentOffsetX = targetContentOffset->x;
    CGFloat drawerPadding = XHContentContainerViewOriginX * 2 / 3.;
    if ((targetContentOffsetX >= drawerPadding && targetContentOffsetX < XHContentContainerViewOriginX && self.openSide == XHDrawerSideLeft) || (targetContentOffsetX > XHContentContainerViewOriginX && targetContentOffsetX <= (XHContentContainerViewOriginX * 2 - drawerPadding) && self.openSide == XHDrawerSideRight)) {
        targetContentOffset->x = XHContentContainerViewOriginX;
    } else if ((targetContentOffsetX >= 0 && targetContentOffsetX <= drawerPadding && self.openSide == XHDrawerSideLeft)) {
        targetContentOffset->x = 0.0f;
        self.openSide = XHDrawerSideLeft;
    } else if ((targetContentOffsetX > (XHContentContainerViewOriginX * 2 - drawerPadding) && targetContentOffsetX <= (XHContentContainerViewOriginX * 2) && self.openSide == XHDrawerSideRight)) {
        targetContentOffset->x = XHContentContainerViewOriginX * 2;
        self.openSide = XHDrawerSideRight;
    }
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    UIViewController *viewController;
    if (self.scrollView.contentOffset.x < XHContentContainerViewOriginX) {
        viewController = self.leftViewController;
    } else if (self.scrollView.contentOffset.x > XHContentContainerViewOriginX) {
        viewController = self.rightViewController;
    } else {
        viewController = self.centerViewController;
    }
    return viewController;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    UIViewController *viewController;
    if (self.scrollView.contentOffset.x < XHContentContainerViewOriginX) {
        viewController = self.leftViewController;
    } else if (self.scrollView.contentOffset.x > XHContentContainerViewOriginX) {
        viewController = self.rightViewController;
    } else {
        viewController = self.centerViewController;
    }
    return viewController;
}


//首先是检测手势的偏移量，由手势的偏移量决定显示什么视图，view实时跟着手势移动。 手势停止后，决定放在什么位置
#pragma mark UIPanGestureRecognizer delegate
- (void)panInContentView:(UIPanGestureRecognizer *)panGestureReconginzer
{
    
    
	if (panGestureReconginzer.state == UIGestureRecognizerStateChanged)
    {
        
        CGFloat translation = [panGestureReconginzer translationInView:self.centerViewController.view.superview].x;
        
       CGFloat  newContentOffset =  0 ;
     
       //当 self.zoomDrawerView.scrollView.contentOffset.x 为 0 时， 往右拉x就小于0，往左拉就大于0
        
//        NSLog(@"self.openSide :  %d",self.openSide);
        
        if(self.openSide == XHDrawerSideLeft)
        {
            newContentOffset =  -translation;//这样写的原因是translation是相对于中间view的，其方向相对左边的view来说是相反的。
            
           if (newContentOffset < 0 ||newContentOffset > XHContentContainerViewOriginX) {
            return;
           }
            
            
            CGPoint newPoint = CGPointMake(newContentOffset, 0);
            [self.zoomDrawerView.scrollView setContentOffset:newPoint animated:NO];

        }
        if(self.openSide == XHDrawerSideRight)
        {
            CGFloat winWidth = self.scrollView.frame.size.width;
            newContentOffset = winWidth - translation;
//                 NSLog(@"newContentset : %f ",newContentOffset);
            if (newContentOffset > XHContentContainerViewOriginX && newContentOffset < winWidth) {//这里的winWidth是写死成最小值的
                CGPoint newPoint = CGPointMake(newContentOffset, 0);
                [self.zoomDrawerView.scrollView setContentOffset:newPoint animated:NO];
            }
            
      
            
        }
        
        
	}
    else if (panGestureReconginzer.state == UIGestureRecognizerStateEnded)
    {
      
//        NSLog(@"self.currentTranslate : %f ",self.currentTranslate);
        CGFloat newContentsetEnd =  self.zoomDrawerView.scrollView.contentOffset.x ;
        
        if(self.openSide == XHDrawerSideLeft)
        {
            //这个表示 当中间边框的左边缘离 坐标XHContentContainerViewOriginX 周围不到80时，还原至原来的状态，也就是说，用户必须拉出80以上的平移才能驱动界面 进行改变
            if (fabs(newContentsetEnd - XHContentContainerViewOriginX)<80) {
                
             
                [self closeDrawerAnimated:YES completion:nil];
           
            }
            else
            {
                self.openSide = XHDrawerSideLeft;
                [self openDrawerSide:XHDrawerSideLeft animated:YES completion:nil];
            }
            
            if (self.openSide == XHDrawerSideNone) {
                [self.view removeGestureRecognizer:self.tractPanGestureRecognizer];
            }
        }//self.openSide == XHDrawerSideLeft
        
        if(self.openSide == XHDrawerSideRight)
        {
            
            if (fabs(newContentsetEnd - XHContentContainerViewOriginX)<80) {
                
                
                [self closeDrawerAnimated:YES completion:nil];
                
            }
            else
            {
                self.openSide = XHDrawerSideRight;
                [self openDrawerSide:XHDrawerSideRight animated:YES completion:nil];
            }
            
            if (self.openSide == XHDrawerSideNone) {
                [self.view removeGestureRecognizer:self.tractPanGestureRecognizer];
            }
        }//self.openSide == XHDrawerSideLeft
	}
}



@end
