//
//  ToDoListTableViewController.m
//  ToDoList
//
//  Created by William Liu on 2/22/16.
//  Copyright © 2016 William Liu. All rights reserved.
//

#import "ToDoListTableViewController.h"
#import "ToDoItem.h"
#import "AddToDoItemViewController.h"

@interface ToDoListTableViewController ()

@property NSMutableArray *toDoItems;

@end

@implementation ToDoListTableViewController

- (IBAction)unwindToList:(UIStoryboardSegue *)segue {
    AddToDoItemViewController *source = [segue sourceViewController];
    ToDoItem *item = source.toDoItem;
    if (item != nil) {
        if (item.itemId == nil) {
            // Add a new toDoItem.
            for (int i = 0; i < [self.toDoItems count]; i++) {
                ((ToDoItem *)self.toDoItems[i]).itemId = [NSNumber numberWithInt:(i)];
            }
            item.itemId = [NSNumber numberWithInt:[self.toDoItems count] + 1I];
            [self.toDoItems addObject:item];
            [self.tableView reloadData];
        } else {
            // Update an existing toDoItem.
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemId == %@", item.itemId];
            NSArray *filteredArray = [self.toDoItems filteredArrayUsingPredicate:predicate];
            ((ToDoItem *)filteredArray[0]).itemName = item.itemName;
            [self.tableView reloadData];
        }
        // Save the toDoItems.
        [self saveToDoItems];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    self.toDoItems = [self loadToDoItems];
    if (self.toDoItems == nil) {
        self.toDoItems = [[NSMutableArray alloc] init];
        [self loadInitialData];
    }
    [self.tableView reloadData];
}

#pragma mark - NSCoding

- (void)saveToDoItems {
    NSURL *archiveURL = [ToDoItem getArchivingPaths];
    BOOL isSuccessfulSave = [NSKeyedArchiver archiveRootObject:self.toDoItems toFile:archiveURL.path];
    if (!isSuccessfulSave) {
        NSLog(@"%@", @"Failed to save toDoItems...");
    }
}

- (id)loadToDoItems {
    NSURL *archiveURL = [ToDoItem getArchivingPaths];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:archiveURL.path];
}

- (void)loadInitialData {
    ToDoItem *item1 = [[ToDoItem alloc] init];
    item1.itemId = [NSNumber numberWithInt:0];
    item1.itemName = @"Buy milk";
    [item1 assignCreationDate];
    [self.toDoItems addObject:item1];
    ToDoItem *item2 = [[ToDoItem alloc] init];
    item2.itemId = [NSNumber numberWithInt:1];
    item2.itemName = @"Buy eggs";
    [item2 assignCreationDate];
    item2.completed = YES;
    item2.completionDate = [NSDate date];
    [self.toDoItems addObject:item2];
    ToDoItem *item3 = [[ToDoItem alloc] init];
    item3.itemId = [NSNumber numberWithInt:2];
    item3.itemName = @"Read a book";
    [item3 assignCreationDate];
    [self.toDoItems addObject:item3];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.toDoItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListPrototypeCell" forIndexPath:indexPath];
    ToDoItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = toDoItem.itemName;
    if (toDoItem.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"'Completed on' MM/dd/yyyy 'at' HH:mm"];
        NSString *formattedDateString = [dateFormatter stringFromDate:toDoItem.completionDate];
        cell.detailTextLabel.text = formattedDateString;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.editingAccessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.text = nil;
    }
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.toDoItems removeObjectAtIndex:indexPath.row];
        [self saveToDoItems];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSString *stringToMove = [self.toDoItems objectAtIndex:fromIndexPath.row];
    [self.toDoItems removeObjectAtIndex:fromIndexPath.row];
    [self.toDoItems insertObject:stringToMove atIndex:toIndexPath.row];
    [self saveToDoItems];
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (!self.editing && [identifier isEqualToString:@"ShowDetail"]) {
        return NO;
    } else {
        return YES;
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if (self.editing && [[segue identifier] isEqualToString:@"ShowDetail"]) {
        // Get the new view controller using [segue destinationViewController].
        AddToDoItemViewController *destination = [segue destinationViewController];
        // Pass the selected object to the new view controller.
        destination.toDoItem = [self.toDoItems objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.editing) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        ToDoItem *tappedItem = [self.toDoItems objectAtIndex:indexPath.row];
        if (tappedItem.completed == false) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Have completed?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [tappedItem markAsCompleted:true];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self saveToDoItems];
            }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
            [alert addAction:cancelAction];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Confirmation" message:@"Have not yet completed?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [tappedItem markAsCompleted:false];
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self saveToDoItems];
            }];
            UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {}];
            [alert addAction:cancelAction];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}

@end
