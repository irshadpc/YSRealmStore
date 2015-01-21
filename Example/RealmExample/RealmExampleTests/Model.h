//
//  Model.h
//  RealmExample
//
//  Created by Yu Sugawara on 2015/01/17.
//  Copyright (c) 2015年 Yu Sugawara. All rights reserved.
//

#import <Realm/Realm.h>
#import <UIKit/UIKit.h>
#import "SubModel.h"

@interface Model : RLMObject

@property BOOL boolean;
@property NSInteger integer;
@property int64_t int64;
@property CGFloat decimal;
@property NSString *string;
@property NSDate *date;
@property NSData *data;
@property SubModel *subModel;
@property RLMArray<SubModel> *arrayModel;

+ (NSString*)defaultString;
+ (NSDate*)defaultDate;
+ (NSData*)defaultData;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<Model>
RLM_ARRAY_TYPE(Model)
