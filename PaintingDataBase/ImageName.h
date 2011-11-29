//
//  ImageName.h
//  PaintingDataBase
//
//  Created by Ivan Sergienko on 11-11-24.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Painting;

@interface ImageName : NSManagedObject

@property (nonatomic, retain) NSString * iPadFull;
@property (nonatomic, retain) NSString * iPadThumbnail;
@property (nonatomic, retain) NSString * webImage;
@property (nonatomic, retain) Painting *painting;

@end
