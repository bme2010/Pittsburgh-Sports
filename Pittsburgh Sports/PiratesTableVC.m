//
//  PiratesTableVC.m
//  Pittsburgh Sports
//
//  Created by Brandon Everett on 4/3/14.
//  Copyright (c) 2014 Brandon Everett. All rights reserved.
//

#import "PiratesTableVC.h"
#import "PiratesRepo.h"
#import "WebVC.h"
@interface PiratesTableVC ()
{
    NSArray* pirateArray;
    NSArray* picArray;
}
@end

@implementation PiratesTableVC

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
    PiratesRepo* pirate = [[PiratesRepo alloc]init];
    [pirate loadData];
    while(pirateArray==nil)
    {
        pirateArray=pirate.storedData;
        picArray = pirate.pictures;
    }
    
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
    return [pirateArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"pirateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if(cell==nil)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    // Configure the cell...
    UILabel* pHeadline = (UILabel*) [cell viewWithTag:3];
    pHeadline.text = [[pirateArray objectAtIndex:indexPath.row]headline];
    
    UIImageView* iView = (UIImageView*) [cell viewWithTag:5];
    iView.image = picArray[indexPath.row];
    
    return cell;
}

-(void) tableView:(UITableView*) tablView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Apple sytle guideline deseclect table cells when clicked on
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.savedPath = indexPath;
    return indexPath;
    
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
    PiratesRepo* p = [[PiratesRepo alloc]init];
    p = [pirateArray objectAtIndex:self.savedPath.row];
    web.text = p.url;
}


@end
