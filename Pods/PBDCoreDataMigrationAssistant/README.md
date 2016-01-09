# The Problem

You probably remember all those headaches you had because of the nasty crashes your app has had when you when Core Data migration failed as you changed your model without creating a new version. 

Or perhaps you have code that handles that the 'default' way - by removing the store completely. It's also not the perfect solution - users loose their data. Best scenario - they have to redownload it. Worst - their data is lost forever. 

# The Solution

Enter `PBDCoreDataMigrationAssistant`. This small framework aims at simplifying working with Core Data versioning by ensuring that your app always has access to previous `NSManagedObjectModel` version and automatically performing migration on your behalf (if possible, see below). 

# Usage

You should create an instance of `PBDCoreDataMigrationAssistant` using

```
- (instancetype)initWithStoreURL:(NSURL *)storeURL sourceModel:(NSManagedObjectModel *)sourceModel destinationModel:(NSManagedObjectModel *)destinationModel;
```

Store URL is, of course, your persistent store URL. Source model is the one that you have previously saved using `PBDManagedObjectModelController` (see below). Destination model is your current model. 

Migration is performed using 

```
- (BOOL)migrateStoreWithError:(NSError **)error;
```

method which will return `YES` if migration was successful and `NO` if it failed. You can consult `error` for additional information why migration might have failed. 

Additionally if mapping model cannot be infered automatically (aka heavy migration is required) `PBDCoreDataMigrationAssistant` will ask its `id<PBDMigrationAssistantDelegate> delegate` for a mapping model. If none is provided migration will fail. 

## Example usage

In your init method of your persistence controller you should create a `PBDManagedObjectModelController` instance

```
self.modelController = [[PBDManagedObjectModelController alloc] initWithManagedObjectModelURL:[self modelURL]];
```

Then, when you're setting up your stack you should check whether a saved model already exists and whether it differs from what you currently have in your apps bundle. If so you should attempt to perform a migration:

```
NSManagedObjectModel *unarchivedModel = [[self modelController] unarchivedManagedObjectModel];

if (unarchivedModel && ![unarchivedModel isEqual:model]) {
    PBDCoreDataMigrationAssistant *migrationAssistant = [[PBDCoreDataMigrationAssistant alloc] initWithStoreURL:self.storeURL
                                                                                                        sourceModel:unarchivedModel
                                                                                                   destinationModel:model];
    [migrationAssistant migrateStoreWithError:nil];
}
[self.modelController archiveManagedObjectModel:model];
```

## PBDManagedObjectModelController

This is a helper class whose purpose is to help you save managed object model. You should instantiate it with an URL under which you would like to have your `NSManagedObjectModel` stored. Using your apps library folder is recommended. 
Use 

```
- (NSManagedObjectModel *)unarchivedManagedObjectModel;
```

to obtain already existing model (will return `nil` if no model is available). 

You should use

```
- (void)archiveManagedObjectModel:(NSManagedObjectModel *)model;
```

to write your model to given URL. 
