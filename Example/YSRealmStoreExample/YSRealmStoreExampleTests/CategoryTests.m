//
//  CategoryTests.m
//  YSRealmExample
//
//  Created by Yu Sugawara on 2014/12/14.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "RLMObject+YSRealmStore.h"
#import "RLMArray+YSRealmStore.h"
#import "TwitterRealmStore.h"

@interface CategoryTests : XCTestCase

@end

@implementation CategoryTests

- (void)setUp
{
    [super setUp];
    [[TwitterRealmStore sharedStore] deleteAllObjects];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRLMArray
{
    YSRealmStore *store = [[YSRealmStore alloc] init];
    int64_t tweetID = 0;
    NSUInteger userCount = 10;
    
    [[TwitterRealmStore sharedStore] addTweetWithTweetJsonObject:[JsonGenerator tweetWithTweetID:tweetID userID:0]];
    [store writeTransactionWithWriteBlock:^(RLMRealm *realm, YSRealmWriteTransaction *transaction) {
        for (NSUInteger userID = 0; userID < userCount; userID++) {
            User *user = [User objectForPrimaryKey:@(userID)];
            if (user == nil) {
                user = [[User alloc] initWithObject:[JsonGenerator userWithID:userID]];
            }
            [realm addObject:user];
        }
    }];
    XCTAssertEqual([[User allObjects] count], userCount);
    
    [store writeTransactionWithWriteBlock:^(RLMRealm *realm, YSRealmWriteTransaction *transaction) {
        Tweet *tweet = [Tweet objectForPrimaryKey:@(tweetID)];
        XCTAssertNotNil(tweet);
        RLMArray *watchers = tweet.watchers;
        XCTAssertNotNil(watchers);
        XCTAssertEqual([watchers count], 0);
        
        User *user0 = [User objectForPrimaryKey:@(0)];
        User *user1 = [User objectForPrimaryKey:@(1)];
        XCTAssertNotNil(user0);
        XCTAssertNotNil(user1);
        
        // ys_containsObject
        XCTAssertFalse([watchers ys_containsObject:user0]);
        
        [watchers addObject:user0];
        XCTAssertEqual([watchers count], 1);
        XCTAssertTrue([watchers ys_containsObject:user0]);
        XCTAssertFalse([watchers ys_containsObject:user1]);
        
        // ys_addUniqueObject:
        [watchers ys_addUniqueObject:user0];
        XCTAssertEqual([watchers count], 1);
        [watchers ys_addUniqueObject:user1];
        XCTAssertEqual([watchers count], 2);
        
        // ys_removeObject
        [watchers ys_removeObject:user1];
        XCTAssertEqual([watchers count], 1);
    }];
}
/*
- (void)testRLMArrayOfStandalone
{
    RLMArray *urls = [[RLMArray alloc] initWithObjectClassName:@"Url"];
    Url *url = [[Url alloc] initWithObject:@{@"url" : @"http://realm.io"}];
    
    [urls addObject:url];
    XCTAssertEqual([urls count], 1);
    
    XCTAssertTrue([urls ys_containsObject:url]);
    
    [urls ys_addUniqueObject:url];
    XCTAssertEqual([urls count], 1);
    
    [urls ys_removeObject:url];
    XCTAssertEqual([urls count], 0);
    
    Url *url2 = [[Url alloc] initWithObject:@{@"url" : @"http://realm.io"}];
    [url2 isEqual:url];
}
 */
/*
- (void)testRLMArrayOfNonPrimaryKeyObject
{
    YSRealm *ysRealm = [YSRealm sharedInstance];
    int64_t tweetID = 0;
    [Utility addTweetWithTweetJsonObject:[JsonGenerator tweetWithTweetID:tweetID userID:0 urlCount:1]];
    
    [ysRealm writeTransactionWithWriteBlock:^(RLMRealm *realm, YSRealmWriteTransaction *transaction) {
        Tweet *tweet = [Tweet objectForPrimaryKey:@(tweetID)];
        XCTAssertNotNil(tweet);
        
        Url *url = [[Url alloc] initWithObject:@{@"url" : @"http://realm.io"}];        
        [tweet.entities.urls addObject:url];
        XCTAssertEqual([tweet.entities.urls count], 2);
        
        XCTAssertTrue([tweet.entities.urls ys_containsObject:url]);
        
        [tweet.entities.urls indexOfObject:url];
    }];
}
*/
@end
