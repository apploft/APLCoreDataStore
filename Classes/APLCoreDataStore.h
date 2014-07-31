
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface APLCoreDataStore : NSObject

/** The managed object model in use. By default, this is a merged model of all models found in the main bundle. */
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

/** Get an APLCoreDataStore object as shared instance. */
+ (instancetype)sharedInstance;

/** Set the shared instance (e.g. with a mock object for unit testing). */
+ (void)setSharedInstance:(APLCoreDataStore *)instance;

/** Managed object context with NSMainQueueConcurrencyType, synchronized with the privateQueueContext. */
+ (NSManagedObjectContext *)mainQueueContext;

/** Managed object context with NSPrivateQueueConcurrencyType, synchronized with the mainQueueContext. */
+ (NSManagedObjectContext *)privateQueueContext;

/** The application's documents directory. */
+ (NSURL *)applicationDocumentsDirectory;

/** URL of the persistent store, default is 'Model.sqlite' in the application's documents directory. If you prefer a different name or location, you should override this method in a subclass. */
+ (NSURL *)persistentStoreURL;

/** Called before initialization of persistentStoreCoordinator. You should override this method in a subclass if you want to perform custom actions right before persistentStoreCoordinator initialization, e.g. initializing the persistent store with an existing database which needs to be copied from main bundle first. */
- (void)preparePersistentStoreCoordinator;

@end
