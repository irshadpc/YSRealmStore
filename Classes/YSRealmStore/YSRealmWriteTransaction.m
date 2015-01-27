//
//  YSRealmWriteTransaction.m
//  YSRealmStoreExample
//
//  Created by Yu Sugawara on 2014/12/08.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSRealmWriteTransaction.h"

@interface YSRealmWriteTransaction ()

@property (copy, nonatomic) NSString *realmPath;
@property (nonatomic) RLMNotificationToken *notificationToken;

@property (readwrite, getter=isInterrupted) BOOL interrupted;

@end

@implementation YSRealmWriteTransaction

#pragma mark - Life cycle

- (instancetype)initWithRealmPath:(NSString*)realmPath
{
    if (self = [super init]) {
        NSParameterAssert(realmPath != nil);
        self.realmPath = realmPath;
    }
    return self;
}

- (void)dealloc
{
    DDLogInfo(@"%s", __func__);
}

#pragma mark - Utility

- (RLMRealm*)realm
{
    return [RLMRealm realmWithPath:self.realmPath];
}

#pragma mark - Transaction

+ (void)writeTransactionWithRealmPath:(NSString*)realmPath
                           writeBlock:(YSRealmWriteTransactionWriteBlock)writeBlock
{
    YSRealmWriteTransaction *trans = [[self alloc] initWithRealmPath:realmPath];
    [trans writeTransactionWithWriteBlock:writeBlock];
}

+ (instancetype)writeTransactionWithRealmPath:(NSString*)realmPath
                                        queue:(dispatch_queue_t)queue
                                   writeBlock:(YSRealmWriteTransactionWriteBlock)writeBlock
                                   completion:(YSRealmWriteTransactionCompletion)completion
{
    YSRealmWriteTransaction *trans = [[self alloc] initWithRealmPath:realmPath];
    [trans writeTransactionWithQueue:queue writeBlock:writeBlock completion:completion];
    return trans;
}

#pragma mark - Transaction Private

- (void)writeTransactionWithWriteBlock:(YSRealmWriteTransactionWriteBlock)writeBlock
{    
    RLMRealm *realm = [self realm];
    [realm beginWriteTransaction];
    
    if (writeBlock) writeBlock(self, realm);
    
    [realm commitWriteTransaction];
}

- (void)writeTransactionWithQueue:(dispatch_queue_t)queue
                       writeBlock:(YSRealmWriteTransactionWriteBlock)writeBlock
                       completion:(YSRealmWriteTransactionCompletion)completion
{
    __weak typeof(self) wself = self;
    
    self.notificationToken = [[self realm] addNotificationBlock:^(NSString *notification, RLMRealm *realm) {
        [realm removeNotification:wself.notificationToken];
        if (completion) completion(wself);
    }];
    
    dispatch_async(queue, ^{
        [wself writeTransactionWithWriteBlock:writeBlock];
    });
}

#pragma mark - State

- (void)interrupt
{
    self.interrupted = YES;
}

@end
