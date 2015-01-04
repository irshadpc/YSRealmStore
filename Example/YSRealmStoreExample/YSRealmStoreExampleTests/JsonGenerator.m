//
//  JsonGenerator.m
//  YSRealmExample
//
//  Created by Yu Sugawara on 2014/10/27.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "JsonGenerator.h"

@implementation JsonGenerator

+ (NSDictionary*)tweet
{
    return [self tweetWithID:INT64_MAX];
}

+ (NSDictionary*)tweetWithID:(int64_t)id
{
    return [self tweetWithTweetID:id userID:id];
}

+ (NSDictionary*)tweetWithTweetID:(int64_t)tweetID userID:(int64_t)userID
{
    return @{@"id" : @(tweetID),
             @"text" : @"sample text. サンプルテキストです。",
             @"user" : [self userWithID:userID],
             @"entities" : [self entities],
             @"source" : @"via Twitter"};
}

+ (NSDictionary*)tweetWithTweetID:(int64_t)tweetID userID:(int64_t)userID urlCount:(NSUInteger)urlCount
{
    return @{@"id" : @(tweetID),
             @"text" : @"sample text. サンプルテキストです。",
             @"user" : [self userWithID:userID],
             @"entities" : [self entitiesWithURLCount:urlCount],
             @"source" : @"via Twitter"};
}

+ (NSDictionary*)user
{
    return [self userWithID:INT64_MAX];
}

+ (NSDictionary*)userWithID:(int64_t)id
{
    return @{@"id" : @(id),
             @"name" : [NSString stringWithFormat:@"name%zd", id]};
}

+ (NSDictionary*)entities
{
    return [self entitiesWithURLCount:1];
}

+ (NSDictionary*)entitiesWithURLCount:(NSUInteger)urlCount
{
    NSMutableArray *urls = @[].mutableCopy;
    for (NSUInteger i = 0; i < urlCount; i++) {
        switch (i) {
            case 0:
                [urls addObject:@{@"url" : @"http://realm.io"}];
                break;
            case 1:
                [urls addObject:@{@"url" : @"http://apple.com"}];
                break;
            default:
                [urls addObject:@{@"url" : @"http://picospec.co.jp"}];
                break;
        }
    }
    
    return @{@"urls" : urls};
}

#pragma mark -

+ (NSDictionary*)entitiesOfEmptyArray
{
    return @{@"urls" : @[]};
}

+ (NSDictionary*)entitiesOfConstainNSNull
{
    return @{@"urls" : [NSNull null]};
}

#pragma mark -

+ (NSDictionary*)tweetOfContainEmptyArray
{
    return @{@"id" : @(INT64_MAX),
             @"text" : @"sample text. サンプルテキストです。",
             @"user" : [self user],
             @"entities" : [self entitiesOfEmptyArray]};
}

+ (NSDictionary*)tweetOfContainNSNull
{
    return @{@"id" : [NSNull null],
             @"text" : [NSNull null],
             @"user" : [NSNull null],
             @"entities" : [self entitiesOfConstainNSNull]};
}

#pragma mark -

+ (NSDictionary*)tweetOfKeyIsNotEnough
{
    return @{};
}

@end