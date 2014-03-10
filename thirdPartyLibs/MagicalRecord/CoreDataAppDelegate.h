//
//  CoreDataAppDelegate.h
//  头版
//
//  Created by YunInfo on 14-3-6.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface CoreDataAppDelegate : UIResponder<UIApplicationDelegate>
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;



@end


//这是一个给类别增添属性的方法
@interface UIViewController (CoreDataAppDelegate)

- (NSManagedObjectContext *)managedObjectContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;


@end