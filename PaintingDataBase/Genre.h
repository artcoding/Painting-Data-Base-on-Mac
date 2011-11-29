//
//  Genre.h
//  PaintingDataBase
//
//  Created by Ivan Sergienko on 11-11-24.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Painting;

@interface Genre : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *paintings;
@end

@interface Genre (CoreDataGeneratedAccessors)

- (void)addPaintingsObject:(Painting *)value;
- (void)removePaintingsObject:(Painting *)value;
- (void)addPaintings:(NSSet *)values;
- (void)removePaintings:(NSSet *)values;

@end
