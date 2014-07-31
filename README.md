APLCoreDataStore
=========

CoreData stack with synchronized NSManagedObjectContexts for main and private queue.

Concept and code is from ['A Guide to Core Data Concurrency' by Theodore Calmes](http://robots.thoughtbot.com/core-data).


## Installation
Install via cocoapods by adding this to your Podfile:

	pod "APLCoreDataStore"

## Usage
Import header file:

	#import "APLCoreDataStore.h"
	
You need to subclass APLCoreDataStore and override `managedObjectModelURL` and `persistentStoreURL` if your CoreData model name is not "Model".

You can use mainQueueContext and privateQueueContext like this:

	[[APLCoreDataStore privateQueueContext] executeFetchRequest:fetchRequest error:&error];