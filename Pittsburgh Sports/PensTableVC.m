//
//  PensTableVC.m
//  Pittsburgh Sports
//
//  Created by Brandon Everett on 4/3/14.
//  Copyright (c) 2014 Brandon Everett. All rights reserved.
//

#import "PensTableVC.h"
#import "PensRepo.h"
#import "WebVC.h"
@interface PensTableVC ()
{
    NSArray* pensArray;
    NSArray* picArray;
}
@end

@implementation PensTableVC
@synthesize count;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //NSThread* thread = [[NSThread alloc]initWithTarget:self selector:@selector(threadMain) object:nil];
   //[thread start];
    PensRepo* pens = [[PensRepo alloc]init];
    [pens loadData];
    //waits until the thread completes and there is data in storedData
    while(pensArray==nil)
    {
        pensArray = pens.storedData;
        picArray = pens.pictures;
    }
    [self addObserver:self forKeyPath:@"count" options:0 context:nil];

    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [pensArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifier = @"pensCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell==nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    UILabel* hdLine = (UILabel *) [cell viewWithTag:1];
    UIImageView* pic = (UIImageView*) [cell viewWithTag:3];
    hdLine.text = [[pensArray objectAtIndex:indexPath.row] headline];
    pic.image = picArray[indexPath.row];
//    if([[pensArray objectAtIndex:indexPath.row]picUrl] !=nil)
//    {
//        NSURL* url = [[NSURL alloc] initWithString:[[pensArray objectAtIndex:indexPath.row] picUrl]];
//        NSData* data = [[NSData alloc] initWithContentsOfURL:url];
//        pic.image = [UIImage imageWithData:data];
//    }

    // Configure the cell...
    
    return cell;
}

-(void) viewWillAppear:(BOOL)animated
{
    //test for now until I figure out how to do
    //something similar to asyn calls in ios
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
-(void) tableView:(UITableView*) tablView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Apple sytle guideline deseclect table cells when clicked on
    [self setValue:[NSNumber numberWithInt:[count intValue] +1] forKey:@"count"];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.savePath = indexPath;
    return indexPath;
    
}
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"count"])
    {
        if([self.count intValue] ==2)
        {
            UILocalNotification* notif = [[UILocalNotification alloc]init];
            notif.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
            notif.alertAction =@"Yay!";
            notif.alertBody = @"You viewed 2 Penguins Articles!";
            [[UIApplication sharedApplication] scheduleLocalNotification:notif];
            self.count=0;
        }
        
    }
}
-(void) viewWillDisappear:(BOOL)animated
{
   [super viewWillDisappear:animated];
    //[self removeObserver:self forKeyPath:@"count"];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    WebVC* web = segue.destinationViewController;
    PensRepo* p = [[PensRepo alloc]init];
    p = [pensArray objectAtIndex:self.savePath.row];
    web.text = p.url;
}


@end
