//
//  CoreDataAppDelegate.m
//  头版
//
//  Created by YunInfo on 14-3-6.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import "CoreDataAppDelegate.h"




@implementation UIViewController (CoreDataAppDelegate)

- (void)saveContext
{
    CoreDataAppDelegate * coreDataAppDelegate = [UIApplication sharedApplication].delegate;
    
    return [coreDataAppDelegate saveContext];
}
- (NSManagedObjectContext *)managedObjectContext
{
    CoreDataAppDelegate * coreDataAppDelegate = [UIApplication sharedApplication].delegate;
    
    return coreDataAppDelegate.managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel
{
    CoreDataAppDelegate * coreDataAppDelegate = [UIApplication sharedApplication].delegate;
    
    return coreDataAppDelegate.managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    CoreDataAppDelegate * coreDataAppDelegate = [UIApplication sharedApplication].delegate;
    
    return coreDataAppDelegate.persistentStoreCoordinator;

}
@end



@implementation CoreDataAppDelegate

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

- (void)saveContext
{
    /*
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    */
    [self.managedObjectContext MR_saveToPersistentStoreAndWait];
}

//Documents目录路径

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
//被管理的数据上下文

//初始化的后，必须设置持久化存储助理


- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    /*这是core data 原始写法
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    */
    
    
    
    
    //update 于 2014年03月10日14:01:35 因为便利性要设置默认的context
     [NSManagedObjectContext MR_initializeDefaultContextWithCoordinator:[self persistentStoreCoordinator]];
  
    
    return [NSManagedObjectContext MR_defaultContext];
    

}



//被管理的数据模型

//初始化必须依赖.momd文件路径，而.momd文件由.xcdatamodeld文件编译而来


- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    
   /*这是core data 原始写法
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Test" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
   */
    
    __managedObjectModel = [NSManagedObjectModel MR_defaultManagedObjectModel];
    
    return __managedObjectModel;
    
    
}

//持久化存储助理

//初始化必须依赖NSManagedObjectModel，之后要指定持久化存储的数据类型，默认的是NSSQLiteStoreType，即SQLite数据库；并指定存储路径为Documents目录下，以及数据库名称


- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    /*这是core data 原始写法
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TestApp.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
     */
    
    __persistentStoreCoordinator = [NSPersistentStoreCoordinator
    //@"CoreDataStore.sqlite"
    MR_coordinatorWithSqliteStoreNamed:[MagicalRecord defaultStoreName]];
    return __persistentStoreCoordinator;
}
@end
