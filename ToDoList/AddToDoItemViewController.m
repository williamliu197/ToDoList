//
//  AddToDoItemViewController.m
//  ToDoList
//
//  Created by William Liu on 2/22/16.
//  Copyright © 2016 William Liu. All rights reserved.
//

#import "AddToDoItemViewController.h"

@interface AddToDoItemViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation AddToDoItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textField.text = self.toDoItem.itemName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if (sender == self.saveButton && self.textField.text.length > 0) {
        if (self.toDoItem.itemId == nil) {
            self.toDoItem = [[ToDoItem alloc] init];
            self.toDoItem.itemName = self.textField.text;
            self.toDoItem.completed = NO;
            [self.toDoItem assignCreationDate];
        } else {
            self.toDoItem.itemName = self.textField.text;
        }
    } else {
        self.toDoItem = nil;
    }
}

@end
