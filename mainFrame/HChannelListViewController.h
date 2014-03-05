//
//  HChannelListViewController.h
//  恒大
//
//  Created by YunInfo on 13-10-9.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//

#import "UISideBarSubViewController.h"

@interface HChannelListViewController : UISideBarSubViewController<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)UITableView *  tableView ;
@property(nonatomic,retain)UIImageView *  titleIV;

@end
