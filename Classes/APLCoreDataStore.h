#import <Foundation/Foundation.h>

@interface APLCoreDataStore : NSObject

/** Get an APLCoreDataStore object as shared instance */
+ (instancetype)sharedInstance;

/** Set the shared instance (e.g. with a mock object for unit testing) */
+ (void)setSharedInstance:(APLCoreDataStore *)instance;

/** Managed object context with NSMainQueueConcurrencyType, synchronized with the privateQueueContext. */
+ (NSManagedObjectContext *)mainQueueContext;

/** Managed object context with NSPrivateQueueConcurrencyType, synchronized with the mainQueueContext. */
+ (NSManagedObjectContext *)privateQueueContext;

/** application's documents directory */
+ (NSURL *)applicationDocumentsDirectory;

/** URL of the managed object model file, default is Model.momd in the application's main bundle. If your CoreData model has a different name, you should override the method in a subclass. */
+ (NSURL *)managedObjectModelURL;

/** URL of the persitent store, default is Model.sqlite in the application's documents directory. If your CoreData model has a different name, you should override the method in a subclass. */
+ (NSURL *)persistentStoreURL;

/** Called before initialization of persistentStoreCoordinator. You should override this method in a subclass if you want to perform custom actions right before persistentStoreCoordinator initialization, e.g. initializing the persistent store with an existing database which needs to be copied from main bundle first. */
- (void)preparePersistentStoreCoordinator;

@end
