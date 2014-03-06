//
//  HTitleView.m
//  恒大
//
//  Created by YunInfo on 13-10-12.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//

#import "HTitleView.h"

@implementation HTitleView

-(void)dealloc
{
    [self.titleLabel removeFromSuperview];
    self.titleLabel = nil;
    
    
    [self.titleBackgroundIV removeFromSuperview];
    self.titleBackgroundIV = nil;


}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
        self.titleBackgroundIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        if (SYSTEMVERSION >= 7.0)
        {
            self.titleBackgroundIV.image = [UIImage imageNamed:@"title-bar-ios7.png"];
        }
        else
        {
                self.titleBackgroundIV.image = [UIImage imageNamed:@"title-bar.png"];
        }
    
        [self addSubview:self.titleBackgroundIV];

        
        // Initialization code
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, IOS7DELTA, self.frame.size.width, self.frame.size.height- IOS7DELTA)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font=[UIFont boldSystemFontOfSize:20.0];
        self.titleLabel.textColor=[UIColor whiteColor];
        [self addSubview:self.titleLabel];
        
    
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
