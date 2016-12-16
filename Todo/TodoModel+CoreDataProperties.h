//
//  TodoModel+CoreDataProperties.h
//  Todo
//
//  Created by MichelleMeng on 16/11/17.
//  Copyright © 2016年 MichelleMeng. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "TodoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TodoModel (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *id;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSDate *date;

@end

NS_ASSUME_NONNULL_END
