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
* Some components could be more reusable, like for instance `UsersViewController` is a great candidate for a generic list presentation view controller.
* User cells layout seems to be off (<3 Autolayout in xibs, need to move this to code)
* Data in content providers is loaded too often, this should be done using a `NSFetchedResultsController`, but again - time constraint ;)
