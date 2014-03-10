//
//  ContactInfo.h
//  头版
//
//  Created by YunInfo on 14-3-6.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ContactDetailInfo;

@interface ContactInfo : NSManagedObject

@property (nonatomic, retain) NSString * age;
@property (nonatomic, retain) NSString * birthday;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) ContactDetailInfo *details;

@end
