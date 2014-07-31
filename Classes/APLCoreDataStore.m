#import "APLCoreDataStore.h"

@interface APLCoreDataStore ()

@property (strong, nonatomic) NSManagedObjectContext *mainQueueContext;
@property (strong, nonatomic) NSManagedObjectContext *privateQueueContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation APLCoreDataStore

static APLCoreDataStore *_sharedInstance = nil;
static dispatch_once_t once_token = 0;

#pragma mark - class methods

+ (instancetype)sharedInstance {
    dispatch_once(&once_token, ^{
        if (_sharedInstance == nil) {
            _sharedInstance = [[self class] new];
        }
    });
    return _sharedInstance;
}

+ (void)setSharedInstance:(APLCoreDataStore *)instance {
    once_token = 0; // resets the once_token so dispatch_once will run again
    _sharedInstance = instance;
}

+ (NSManagedObjectContext *)mainQueueContext {
    return ((APLCoreDataStore*)[self sharedInstance]).mainQueueContext;
}

+ (NSManagedObjectContext *)privateQueueContext {
    return ((APLCoreDataStore*)[self sharedInstance]).privateQueueContext;
}

+ (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSURL *)persistentStoreURL {
    return [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
}

#pragma mark - instance methods

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveContext:) name:UIApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSavePrivateQueueContext:) name:NSManagedObjectContextDidSaveNotification object:[self privateQueueContext]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSaveMainQueueContext:) name:NSManagedObjectContextDidSaveNotification object:[self mainQueueContext]];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)saveContext:(NSNotification *)notification {
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.mainQueueContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
#if defined(DEBUG) || defined(ENTERPRISE)
            abort();
#endif
        }
    }
}

- (void)contextDidSavePrivateQueueContext:(NSNotification *)notification {
    @synchronized(self) {
        [self.mainQueueContext performBlock:^{
            [self.mainQueueContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

- (void)contextDidSaveMainQueueContext:(NSNotification *)notification {
    @synchronized(self) {
        [self.privateQueueContext performBlock:^{
            [self.privateQueueContext mergeChangesFromContextDidSaveNotification:notification];
        }];
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)mainQueueContext {
    if (!_mainQueueContext) {
        _mainQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        _mainQueueContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _mainQueueContext;
}

- (NSManagedObjectContext *)privateQueueContext {
    if (!_privateQueueContext) {
        _privateQueueContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        _privateQueueContext.persistentStoreCoordinator = self.persistentStoreCoordinator;
    }
    
    return _privateQueueContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    _managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    [self preparePersistentStoreCoordinator];
    
    NSError *error = nil;
    NSURL *storeURL = [[self class] persistentStoreURL];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options: @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Second attempt with unresolved error %@, %@", error, [error userInfo]);
            
#if defined(DEBUG) || defined(ENTERPRISE)
            abort();
#endif
        }
    }
    
    return _persistentStoreCoordinator;
}

- (void)preparePersistentStoreCoordinator {
    
}

@end
