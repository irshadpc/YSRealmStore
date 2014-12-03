//
//  YSRealm.m
//  YSRealmExample
//
//  Created by Yu Sugawara on 2014/10/26.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "YSRealm.h"

@interface YSRealm ()

@property (nonatomic) NSMutableArray *operations;

@end

@implementation YSRealm

+ (instancetype)sharedInstance
{
    static id __sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance =  [[self alloc] init];
    });
    return __sharedInstance;
}

- (instancetype)init
{
    if (self = [super init]) {
        self.operations = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Realm

- (RLMRealm*)realm
{
    return [RLMRealm defaultRealm];
}

#pragma mark - Operation
#pragma mark Write

- (void)writeObjectsWithObjectsBlock:(YSRealmOperationObjectsBlock)objectsBlock
{
    [YSRealmOperation writeOperationWithRealmPath:[[self realm] path] objectsBlock:objectsBlock];
}

- (YSRealmOperation*)writeObjectsWithObjectsBlock:(YSRealmOperationObjectsBlock)objectsBlock
                                       completion:(YSRealmOperationCompletion)completion
{
    __weak typeof(self) wself = self;
    YSRealmOperation *ope = [YSRealmOperation writeOperationWithRealmPath:[[self realm] path] objectsBlock:objectsBlock completion:^(YSRealmOperation *operation) {
        [wself.operations removeObject:operation];
        completion(operation);
    }];
    [self.operations addObject:ope];
    return ope;
}

#pragma mark Delete

- (void)deleteObjectsWithObjectsBlock:(YSRealmOperationObjectsBlock)objectsBlock
{
    [YSRealmOperation deleteOperationWithRealmPath:[[self realm] path] objectsBlock:objectsBlock];
}

- (YSRealmOperation*)deleteObjectsWithObjectsBlock:(YSRealmOperationObjectsBlock)objectsBlock
                                        completion:(YSRealmOperationCompletion)completion
{
    __weak typeof(self) wself = self;
    YSRealmOperation *ope = [YSRealmOperation deleteOperationWithRealmPath:[[self realm] path] objectsBlock:objectsBlock completion:^(YSRealmOperation *operation) {
        [wself.operations removeObject:operation];
        completion(operation);
    }];
    [self.operations addObject:ope];
    return ope;
}

#pragma mark Fetch

- (YSRealmOperation*)fetchObjectsWithObjectsBlock:(YSRealmOperationObjectsBlock)objectsBlock
                                       completion:(YSRealmOperationFetchCompletion)completion
{
    __weak typeof(self) wself = self;
    YSRealmOperation *ope = [YSRealmOperation fetchOperationWithRealmPath:[[self realm] path] objectsBlock:objectsBlock completion:^(YSRealmOperation *operation, NSArray *results) {
        [wself.operations removeObject:operation];
        completion(operation, results);
    }];
    [self.operations addObject:ope];
    return ope;
}

@end
