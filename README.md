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
	
APLCoreDataStore uses a merged managed object model of all managed object models found in your application's main bundle.

It creates 'Model.sqlite' in your application's documents folder as persistent store. If you want a different name or location you could subclass APLCoreDataStore and override `persistentStoreURL`.

You can use mainQueueContext and privateQueueContext like this:

	[[APLCoreDataStore privateQueueContext] executeFetchRequest:fetchRequest error:&error];