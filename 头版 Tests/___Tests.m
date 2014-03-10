//
//  ___Tests.m
//  头版 Tests
//
//  Created by YunInfo on 14-3-7.
//  Copyright (c) 2014年 Yuninfo. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CoreData+MagicalRecord.h"
#import "ContactInfo.h"
#import "ContactDetailInfo.h"
#import "HttpRequestManager.h"
#import "头版-Prefix.pch"


@interface ___Tests : XCTestCase

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation ___Tests
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

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
    
    __managedObjectContext = [NSManagedObjectContext MR_contextWithStoreCoordinator:[self persistentStoreCoordinator]];
    return __managedObjectContext;
    
    
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



//Method For Study ************************ start ****************************************
- (void)insertCoreData
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    ContactInfo *contactInfo = [NSEntityDescription insertNewObjectForEntityForName:@"ContactInfo" inManagedObjectContext:context];
    [contactInfo setValue:@"name B" forKey:@"name"];
    [contactInfo setValue:@"birthday B" forKey:@"birthday"];
    [contactInfo setValue:@"age B" forKey:@"age"];
    
    NSManagedObject *contactDetailInfo = [NSEntityDescription insertNewObjectForEntityForName:@"ContactDetailInfo" inManagedObjectContext:context];
    [contactDetailInfo setValue:@"address B" forKey:@"address"];
    [contactDetailInfo setValue:@"name B" forKey:@"name"];
    [contactDetailInfo setValue:@"telephone B" forKey:@"telephone"];
    
    [contactDetailInfo setValue:contactInfo forKey:@"info"];
    [contactInfo setValue:contactDetailInfo forKey:@"details"];
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"不能保存：%@",[error localizedDescription]);
    }
}

- (void)dataFetchRequest
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    /*这是core data 原始写法
     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init] ;
     NSEntityDescription *entity = [NSEntityDescription entityForName:@"ContactInfo" inManagedObjectContext:context];
     [fetchRequest setEntity:entity];
     NSError *error;
     NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
     for (NSManagedObject *info in fetchedObjects) {
     NSLog(@"name:%@", [info valueForKey:@"name"]);
     NSLog(@"age:%@", [info valueForKey:@"age"]);
     NSLog(@"birthday:%@", [info valueForKey:@"birthday"]);
     NSManagedObject *details = [info valueForKey:@"details"];
     NSLog(@"address:%@", [details valueForKey:@"address"]);
     NSLog(@"telephone:%@", [details valueForKey:@"telephone"]);
     }
     */
    
    NSArray * eachInfoArray = [ContactInfo MR_findAllInContext:context];
    for (ContactInfo * eachInfo in eachInfoArray) {
        NSLog(@"%@",eachInfo);
    }
    
    NSArray * eachDetailsInfoArray = [ContactDetailInfo MR_findAllInContext:context];
    for (ContactDetailInfo * eachDI in eachDetailsInfoArray) {
        NSLog(@"%@",eachDI);
    }
}

//Method For Study ************************ end ****************************************



- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

-(void)testA
{
    // //www.21cn.com/api/client/v2/getArticleContent.do?articleId=26649465&userSerialNumber=qewq
    HttpRequestManager * hrm = [[HttpRequestManager alloc]init];
    [hrm loadArticleContentUsingArticleId:26649465];
    hrm.httpRequestFinishedNSMutableArrayBlock = ^(NSMutableArray * array){
        
        MSDebug(@"%@",array);
    };
}


- (void)testExample
{
    //[self insertCoreData];
    [self dataFetchRequest];
}

@end
