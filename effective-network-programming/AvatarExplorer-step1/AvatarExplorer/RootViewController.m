//
//  RootViewController.m
//  AvatarExplorer
//
//  Created by Ben Scheirman on 3/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "ASIHTTPRequest.h"

@implementation RootViewController

- (NSString *)avatarPlistPath {
    return [[NSBundle mainBundle] pathForResource:@"Avatars" ofType:@"plist"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    avatarInfo = [[NSDictionary dictionaryWithContentsOfFile:[self avatarPlistPath]] retain];
    
    imageRequestQueue = [[NSOperationQueue alloc] init];
    [imageRequestQueue setMaxConcurrentOperationCount:2];

}

- (NSArray *)avatars {
    return [avatarInfo objectForKey:@"Avatars"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self avatars] count];
}

- (UIImage *)imageForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *filename = [[self avatars] objectAtIndex:indexPath.row];
    NSString *baseURL = [avatarInfo objectForKey:@"BaseURL"];
    
    NSString *urlString = [baseURL stringByAppendingString:filename];
    NSURL *url = [NSURL URLWithString:urlString];

    if ([imageCache objectForKey:url]) {
        return [imageCache objectForKey:url];
    }
    
    if (!imageRequests) {
        imageRequests = [[NSMutableSet alloc] init];
    }
    if ([imageRequests containsObject:url] ) {
        return nil;
    }
    
    [imageRequests addObject:url];
    NSLog(@"Requesting avatar: %@", url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.delegate = self;
    request.userInfo = [NSDictionary dictionaryWithObject:indexPath forKey:@"indexPath"];
    
    [imageRequestQueue addOperation:request];
    
    return nil;
}

#pragma mark -
#pragma mark ASI HTTP REQUEST

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    [imageRequests removeObject:request.url];
    
    if ([request responseStatusCode] != 200) {
        return;
    }
    
    NSData *imageData = [request responseData];
    UIImage *image = [UIImage imageWithData:imageData];
    
    if (!imageCache) {
        imageCache = [[NSMutableDictionary alloc] init];
    }
    
    [imageCache setObject:image forKey:[request url]];
    
    //reload table row
    NSIndexPath *indexPath = [[request userInfo] objectForKey:@"indexPath"];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.imageView.image = [self imageForRowAtIndexPath:indexPath];
    cell.textLabel.text = [[self avatars] objectAtIndex:indexPath.row];

    // Configure the cell.
    return cell;
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
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
	*/
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    [imageCache release];
    imageCache = nil;
    
    [imageRequestQueue cancelAllOperations];
    [imageRequestQueue release];
    imageRequestQueue = nil;
    
    [imageRequests release];
    imageRequests = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)dealloc
{
    [imageRequests release];
    [imageRequestQueue release];
    [imageCache release];
    [avatarInfo release];
    [super dealloc];
}

@end
