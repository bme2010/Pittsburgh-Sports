//
//  PiratesRepo.h
//  Pittsburgh Sports
//
//  Created by Brandon Everett on 4/8/14.
//  Copyright (c) 2014 Brandon Everett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PiratesRepo : NSObject <NSURLSessionDownloadDelegate>
-(void) loadData;
@property (strong) NSString* headline;
@property (strong) NSString* url;
@property (strong) NSArray* storedData;
@property (strong) NSMutableArray* pictures;
@property (strong) NSString* picUrl;

@end
