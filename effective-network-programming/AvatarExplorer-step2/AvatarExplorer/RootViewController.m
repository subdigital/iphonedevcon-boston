//
//  RootViewController.m
//  AvatarExplorer
//
//  Created by Ben Scheirman on 3/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"

@implementation RootViewController

- (NSString *)avatarPlistPath {
    return [[NSBundle mainBundle] pathForResource:@"Avatars" ofType:@"plist"];
}

- (NSArray *)avatars {
    return [avatarInfo objectForKey:@"Avatars"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    avatarInfo = [[NSDictionary dictionaryWithContentsOfFile:[self avatarPlistPath]] retain];
    imageQueue = [[NSOperationQueue alloc] init];
    currentRequests = [[NSMutableSet alloc] init];
    
    self.title = @"Avatar Explorer";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark -
#pragma ASI HTTP REQUEST

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSLog(@"Received a %d", [request responseStatusCode]);

    if (![request error]) {
        UIImage *image = [UIImage imageWithData:[request responseData]];
        if (!imageCache) {
            imageCache = [[NSMutableDictionary alloc] init];
        }
        
        [imageCache setObject:image forKey:[request url]];
        [currentRequests removeObject:[request url]];
        
        NSIndexPath *indexPath = [[request userInfo] objectForKey:@"indexPath"];
        
        BOOL rowVisible = [[self.tableView indexPathsForVisibleRows] containsObject:indexPath];
        
        //show cached responses status
        
        if (rowVisible) {
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    } else {
        NSLog(@"An error occured (%@) ==> %@", [request url], [[request error] localizedDescription]);
    }
}

/*
 // Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
 */

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self avatars] count];
}

- (UIImage *)imageForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *filename = [[self avatars] objectAtIndex:indexPath.row];
    NSString *baseURL = [avatarInfo objectForKey:@"BaseURL"];
    
    NSString *urlString = [baseURL stringByAppendingString:filename];
    NSURL *url = [NSURL URLWithString:urlString];

    
    if ([[imageCache allKeys] containsObject:url]) {
        return [imageCache objectForKey:url];
    }
    
    if (![currentRequests containsObject:url]) {
        
        [currentRequests addObject:url];
        
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setQueue:imageQueue];
        [request setDelegate:self];
        [request setDownloadCache:[ASIDownloadCache sharedCache]];
        [request setCachePolicy:ASIAskServerIfModifiedCachePolicy];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [request setUserInfo:[NSDictionary dictionaryWithObject:indexPath forKey:@"indexPath"]];
        
        NSLog(@"Requesting avatar: %@", url);
        [request startAsynchronous];        
    }
    
    //check for cached image
    NSData *cachedImageData = [[ASIDownloadCache sharedCache] cachedResponseDataForURL:url];
    if (cachedImageData) {
        return [UIImage imageWithData:cachedImageData];
    }
    
    return [UIImage imageNamed:@"default_avatar.png"];
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
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [currentRequests release];
    [imageCache release];
    [avatarInfo release];
    [imageQueue release];
    [super dealloc];
}

@end
