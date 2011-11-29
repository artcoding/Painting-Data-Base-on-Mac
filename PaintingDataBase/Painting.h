//
//  Painting.h
//  PaintingDataBase
//
//  Created by Ivan Sergienko on 11-11-24.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Painting : NSManagedObject

// Strings
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * normalizedID;
@property (nonatomic, retain) NSManagedObject *genre;
@property (nonatomic, retain) NSManagedObject *imageName;

// Dates
@property (nonatomic, retain) NSDate * dateAdded;
@property (nonatomic, retain) NSDate * dateSold;

// Size
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * width;

// Booleans
@property (nonatomic, retain) NSNumber * isMyFavourite;
@property (nonatomic, retain) NSNumber * isNew;
@property (nonatomic, retain) NSNumber * isSold;
@property (nonatomic, retain) NSNumber * doNotShow;


@end
