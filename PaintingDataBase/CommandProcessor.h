//
//  CommandProcessor.h
//  PaintingDataBase
//
//  Created by Ivan Sergienko on 11-11-23.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommandProcessor : NSObject

+(NSString*) normalizedString:(NSString*) aString;

+(void) help: (NSString*) command;

-(id) initWithCommand:(NSString*) command
           parameters:(NSDictionary*) parameters
 managedObjectContext:(NSManagedObjectContext* ) context;

-(void) execute;

@property (weak,nonatomic) NSManagedObjectContext* managedObjectContext;

/**
 * Return normalized version of painting title. No white spaces and first letter of every word capitalized.
 * "title" field in
 * \todo Should throw an exception if 
 */
@property (strong,nonatomic,readonly) NSString* normalizedIDInRequest;

@end
