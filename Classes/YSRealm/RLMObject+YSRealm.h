//
//  RLMObject+YSRealm.h
//  YSRealmExample
//
//  Created by Yu Sugawara on 2014/10/27.
//  Copyright (c) 2014年 Yu Sugawara. All rights reserved.
//

#import "RLMObject.h"

@interface RLMObject (YSRealm)

- (NSString *)ys_stringWithObject:(NSDictionary *)object forKey:(NSString *)key;

@end
