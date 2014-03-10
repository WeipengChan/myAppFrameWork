

##主UI框架
这个工程是继承我自己的开发框架。
在HomeViewController导入 DrawerSlide的框架demo的代码之后。有空把HomeViewController的代码封一下，就又可以壮大那个框架了


##CoreData
接下来的改动是 添加CoreData改动。我先上传SourceTree。

CoreDta已经可以用，并且CoreDataAppDelegate已经封装到MagicRecord中，以后使用CoreData只需要在bundle中建立模型就可以了，然后根据模型生成响应的NSManagedObject对象，现在可以很方便地使用CRUD。

####添加数据库的数据对象时要做的事情



     
  
    1-(void)setValue:(id)value forUndefinedKey:(NSString *)key
		{
    if ([key isEqualToString:@"id"]) {
        [self setValue:[(NSNumber*)value stringValue ] forKey:@"articleId"];
    }
        if ([key isEqualToString:@"id"]) {
        [self setValue:[(NSNumber*)value stringValue ] forKey:@"articleId"];
    }
     //甚至存 相关联的数组对象。
    if ([key isEqualToString:@"pictureList"]) {
        NSArray * array = value;
        for (NSDictionary * each in array) {
            //建立新对象
            PictureOfArticle * pa = [PictureOfArticle MR_createInContext:[NSManagedObjectContext MR_defaultContext]];
            [pa setValuesForKeysWithDictionary:each];
            //增加
            [self addpictureListSetObject:pa];
        }
    }
   	 }

     2属性名相同时检查你的类型
    NSNumber 和 其它类型 不相兼容,但是在SetValuesWithDictionary中，我们可以在json到coreData的Object转换中任意选择。
 
     3对象进行description重写，便于调试。
   


CREATE       

		  ArticleContentObject * object = [ArticleContentObject MR_createInContext:[self managedObjectContext]];
        [object setValuesForKeysWithDictionary:dict];
        [self.managedObjectContext MR_saveToPersistentStoreAndWait];
R&U 
   
   


		MR_findAllInContext 
        。。。   



D      

		 MR_delete…

##网络请求
我决定把之前项目散乱的网络请求集合到一个类中，这样可以在一个地方隔离掉网络请求。存储机制已经变化，不需要原来的manager的写法了。


##测试网络请求调用 

 我大概地测试了放置网络请求的新类。它是可用的。
 
#至此，框架搭建完毕，UI任务开始
# 


