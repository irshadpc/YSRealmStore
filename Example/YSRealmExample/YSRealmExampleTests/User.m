//
//  User.m
//  YSRealmExample
//
//  Created by Yu Sugawara on 2014/10/27.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "User.h"
#import <YSNSFoundationAdditions/NSDictionary+YSNSFoundationAdditions.h>
#import "RLMObject+YSRealm.h"

@implementation User

- (instancetype)initWithObject:(id)object
{
    if (self = [super init]) {
        self.id = [[object ys_objectOrNilForKey:@"id"] longLongValue];
        self.name = [self ys_stringWithObject:object forKey:@"name"];
    }
    return self;
}

@end
