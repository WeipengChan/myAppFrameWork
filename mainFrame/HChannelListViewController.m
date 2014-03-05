//
//  HChannelListViewController.m
//  恒大
//
//  Created by YunInfo on 13-10-9.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//

#import "HChannelListViewController.h"

//列表
#import "HChannelListCell.h"

@interface HChannelListViewController ()
@property (nonatomic,retain) NSIndexPath * lastSelectedIndexPath;

@end

@implementation HChannelListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//在loadView方法后这个一定会被执行
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
 
//    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
    
    
    self.titleIV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width, (SYSTEMVERSION>=7.0)? 64 :44 )];
   // self.titleIV.contentMode = UIViewContentModeScaleAspectFill;
    self.titleIV.clipsToBounds = YES;
   
    if (SYSTEMVERSION >= 7.0)
    {
        self.titleIV.image = [UIImage imageNamed:@"title-bar-ios7-left.png"];
    }
    else
    {
        self.titleIV.image = [[UIImage imageNamed:@"region-start-title-bar"]stretchableImageWithLeftCapWidth:self.view.frame.size.width/2 topCapHeight:1];
    }

    [self.view addSubview:self.titleIV];
    
    //初始化一个列表
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake( 0 , self.titleIV.frame.size.height , 250, self.view.frame.size.height -  self.titleIV.frame.size.height)];
//test for background
   UIImage * img =[UIImage imageNamed:@"region-start--background.png"];
    // UIImage * img =[UIImage imageNamed:@"background.png"];
    UIImageView * tableViewBackgroundIV = [[UIImageView alloc]initWithFrame:self.tableView.frame];
    tableViewBackgroundIV.image = img;
    [self.view addSubview:tableViewBackgroundIV];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    self.tableView.bounces = NO;
   self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    	// Do any additional setup after loading the view.
    
    //跳往新闻页面
    NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:[NSIndexPath indexPathForRow:0 inSection:0], @"channelIndex", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToRightVCs" object:self userInfo:userInfo];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    MSDebug(@"HChannelListViewController Dealloc");
    [self.tableView removeFromSuperview];
    self.tableView =nil;
    
    [self.titleIV removeFromSuperview];
    self.titleIV = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [iPhoneTools getMennuNameDictionary].count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * CellIdentifier = @"HChannelListCell";
    
    HChannelListCell *cell = (HChannelListCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[HChannelListCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier] ;
    }
  
    //UI 和 分割线

    
    return cell;
}

//
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
// 
//}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    HChannelListCell *  cell = nil;
    if (self.lastSelectedIndexPath)
    {
        cell = (HChannelListCell*)[tableView cellForRowAtIndexPath:self.lastSelectedIndexPath];
//      cell.channelIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"region-start-%d.png",self.lastSelectedIndexPath.row]];
    }
    cell = (HChannelListCell*)[tableView cellForRowAtIndexPath:indexPath];


    self.lastSelectedIndexPath = indexPath;
    
    
    NSDictionary * userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:indexPath, @"channelIndex", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"jumpToRightVCs" object:self userInfo:userInfo];
}


@end
