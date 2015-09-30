//
//  WebVC.h
//  Pittsburgh Sports
//
//  Created by Brandon Everett on 4/8/14.
//  Copyright (c) 2014 Brandon Everett. All rights reserved.
//

#import "ViewController.h"
@class WebVC;
@protocol web <NSObject>
//-(void)

@end
@interface WebVC : ViewController
@property (strong) NSString* text;
@property (strong, nonatomic) IBOutlet UIWebView *web;
@end
