#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "SpectaTypes.h"

@class SPTExample;
@class SPTCallSite;

@interface SPTExampleGroup : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, weak) SPTExampleGroup *root;
@property (nonatomic, weak) SPTExampleGroup *parent;
@property (nonatomic, strong) NSMutableArray *children;
@property (nonatomic, strong) NSMutableArray *beforeAllArray;
@property (nonatomic, strong) NSMutableArray *afterAllArray;
@property (nonatomic, strong) NSMutableArray *beforeEachArray;
@property (nonatomic, strong) NSMutableArray *afterEachArray;
@property (nonatomic, strong) NSMutableArray *actionArray;
@property (nonatomic, strong) NSMutableDictionary *sharedExamples;
@property (nonatomic) unsigned int exampleCount;
@property (nonatomic) unsigned int ranExampleCount;
@property (nonatomic) unsigned int pendingExampleCount;
@property (nonatomic, getter=isFocused) BOOL focused;

- (id)initWithName:(NSString *)name parent:(SPTExampleGroup *)parent root:(SPTExampleGroup *)root;

- (SPTExampleGroup *)addExampleGroupWithName:(NSString *)name focused:(BOOL)focused;
- (SPTExample *)addExampleWithName:(NSString *)name callSite:(SPTCallSite *)callSite focused:(BOOL)focused block:(SPTVoidBlock)block;

- (void)addBeforeAllBlock:(SPTVoidBlock)block;
- (void)addAfterAllBlock:(SPTVoidBlock)block;
- (void)addActionBlock:(SPTVoidBlock)block;
- (void)addBeforeEachBlock:(SPTVoidBlock)block;
- (void)addAfterEachBlock:(SPTVoidBlock)block;

- (NSArray *)compileExamplesWithStack:(NSArray *)stack;

@end
