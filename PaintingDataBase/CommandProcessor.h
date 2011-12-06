//
//  CommandProcessor.h
//  PaintingDataBase
//
//  Created by Ivan Sergienko on 11-11-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Painting.h"

@interface CommandProcessor : NSObject

/** 
 * \brief Converts string in yyyy/mm/dd format into NSDate object.
 */
+(NSDate*) dateFromString:(NSString*) dateString;

/**
 * \brief Converts an NSDate object into string in yyyy/mm/dd format.
 */
+(NSString*) stringFromDate:(NSDate*) date;

/** \return normalized version of string.
 *  White spaces removed, 1st letter of every word capitalized.
 */
+(NSString*) normalizedString:(NSString*) aString;

+(void) help: (NSString*) command;

-(id) initWithCommand:(NSString*) command
           parameters:(NSDictionary*) parameters
 managedObjectContext:(NSManagedObjectContext* ) context;

-(id) init;

/** Fetches painting from store for various reasons: 
 *  to just check if it is already there, or change/report something
 */
-(Painting *) fetchPaintingByTitle;


-(BOOL) execute;

@property (strong, nonatomic) NSString*     _command;
@property (strong, nonatomic) NSDictionary* _parameters;

@property (weak,nonatomic) NSManagedObjectContext* managedObjectContext;

/**
 * \return normalized version of painting title. No white spaces and first letter of every word capitalized.
 * "title" command line attribute must be set. If it is not - returns nil.
 */
@property (strong,nonatomic,readonly) NSString* normalizedIDInRequest;

@end
