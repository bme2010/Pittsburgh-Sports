//
//  PensRepo.m
//  Pittsburgh Sports
//
//  Created by Brandon Everett on 4/4/14.
//  Copyright (c) 2014 Brandon Everett. All rights reserved.
//

#import "PensRepo.h"

@implementation PensRepo
@synthesize storedData,pictures;
-(void) loadData
{
    NSOperationQueue* queue =[[NSOperationQueue alloc]init];
    NSOperation* op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(downloadData) object:nil];
    [queue addOperation:op];
    [queue waitUntilAllOperationsAreFinished];
//    NSThread* thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadData) object:nil];
//    [thread start];
}

-(void) downloadData
{

    @autoreleasepool {
        
        NSURL* url = [NSURL URLWithString:@"http://api.espn.com/v1/sports/hockey/nhl/news/?teams=16&disable=audio%2Ccategories&&apikey=hcjn26vamxcxzzvyk58fnytb"];
        NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession* session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        NSURLSessionDownloadTask* dTask = [session downloadTaskWithURL:url ];
        [dTask resume];

    }
}
-(void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSData* data = [NSData dataWithContentsOfURL:location];
    NSDictionary* dict = [[NSDictionary alloc]init];
    dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary* headlne = [[NSDictionary alloc]initWithDictionary:dict];
    
        
    
    headlne = (NSDictionary*)dict[@"headlines"];
    NSMutableArray* temp = [[NSMutableArray alloc]init];
    
    for(id key in headlne)
    {
        //create object arry and add objects to it
        PensRepo* pens = [[PensRepo alloc]init];
        [pens setValue:key[@"headline"] forKey:@"headline"];
        NSDictionary* t = key[@"links"];
        NSArray* images = key[@"images"];
        for(id ob in images)
        {
            [pens setValue:ob[@"url"] forKey:@"picUrl"];
            break;
        }
        NSDictionary* sub = t[@"web"];
        [pens setValue:sub[@"href"] forKey:@"url"];
      
            //[pens setValue:images[@"url"] forKey:@"picUrl"];

        [temp addObject:pens];
        
    

    }
    pictures = [[NSMutableArray alloc]init];
    for(PensRepo* pen in temp)
    {
        if(pen.picUrl !=nil)
        {
            NSURL* url = [[NSURL alloc]initWithString:pen.picUrl];
            NSData* data = [[NSData alloc]initWithContentsOfURL:url];
            UIImage* image = [[UIImage alloc]initWithData:data];
            [pictures addObject:image];
            
        }
        else
        {
            //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pens" ofType:@"jpeg"];
            UIImage* image = [UIImage imageNamed:@"pens.jpeg"];            
            [pictures addObject:image];
        }
    }
    self.storedData = temp;
    
    
    
    
   
}
-(void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}
-(void) URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}
@end
