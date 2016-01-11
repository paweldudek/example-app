# Example App

## Running project

Just go to Xcode and hit build & run!

## Running tests

You'll need to install dependencies from Ruby gems first. If you haven't set up your environment please follow the steps as described [here](https://rvm.io). After setting up ruby call

```bash
gem install bundler && bundle install
```

and you should be all set with the environment!

Then you can just call `rake` to execute tests.

## Known bugs & shortcomings

* There might be a weird glitch with `UISearchController` when quickly dismissing the search controller just after (or during) `UINavigationController` pop animation.
* Table view updates are not animated due to time constraint
* Core Data model does not use relationships as they would create additional implementation and maintenance overhead and at this point they don't seem to be worth it.
* Core Data performance is less than suboptimal, however given timeframe and data set I didn't focus much on optimizing it
* Some components could be more reusable, like for instance `UsersViewController` is a great candidate for a generic list presentation view controller.
* User cells layout seems to be off (<3 Autolayout in xibs, need to move this to code)
* Data in content providers is loaded too often, this should be done using a `NSFetchedResultsController`, but again - time constraint ;)

One thing that I'd finally consider as a potential problem is loose coupling in `TableContentViewController` as you can provide a `ContentProvider` with different objects than `TableContentPresentationController` expects. This could, of course, be solved by adding runtime assertions to catch such issues early, however one would prefer compile time checks. This is, unfortunately, not yet possible in Objective-C as you can't declare a protocol that handle a specific type (aka `typealias` from Swift protocols).

If we could we could then declare our `TableContentPresentationController` as

```
@interface TableContentViewController <__covariant ObjectType> : UIViewController <ContentProviderDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, readonly) id <ContentProvider <ObjectType>> contentProvider;

@property(nonatomic, readonly) id <TableContentPresentationController <ObjectType>> tableContentPresentationController;

```

(I'm making up syntax as this is not yet available). That way we could declare

```
TableContentViewController <User *> *viewController = (...)
```

and then get compile-time checks whether we added right objects.

But unfortunately this is only a wish right now ;)
