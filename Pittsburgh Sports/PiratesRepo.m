//
//  PiratesRepo.m
//  Pittsburgh Sports
//
//  Created by Brandon Everett on 4/8/14.
//  Copyright (c) 2014 Brandon Everett. All rights reserved.
//

#import "PiratesRepo.h"

@implementation PiratesRepo
@synthesize storedData,pictures;
-(void) loadData
{
    NSThread* thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadData) object:nil];
    [thread start];
}

-(void) downloadData
{
    @autoreleasepool {
        
        NSURL* url = [NSURL URLWithString:@"http://api.espn.com/v1/sports/baseball/news/?teams=23&disable=categories%2Caudio&apikey=hcjn26vamxcxzzvyk58fnytb"];
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
        PiratesRepo* pirate = [[PiratesRepo alloc]init];
        [pirate setValue:key[@"headline"] forKey:@"headline"];
        NSDictionary* t = key[@"links"];
        NSDictionary* sub = t[@"web"];
        [pirate setValue:sub[@"href"] forKey:@"url"];
        NSArray* images = key[@"images"];
        for(id ob in images)
        {
            [pirate setValue:ob[@"url"] forKey:@"picUrl"];
            break;
        }

        [temp addObject:pirate];
        
    }
    pictures = [[NSMutableArray alloc]init];
    for(PiratesRepo* pir in temp)
    {
        if(pir.picUrl !=nil)
        {
            NSURL* url = [[NSURL alloc]initWithString:pir.picUrl];
            NSData* data = [[NSData alloc]initWithContentsOfURL:url];
            UIImage* image = [[UIImage alloc]initWithData:data];
            [pictures addObject:image];
            
        }
        else
        {
            //NSString *filePath = [[NSBundle mainBundle] pathForResource:@"pittsburgh pirates" ofType:@"jpg"];
            UIImage* image = [UIImage imageNamed:@"pittsburgh pirates.jpg"];
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
