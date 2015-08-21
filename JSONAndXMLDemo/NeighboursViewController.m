//
//  NeighboursViewController.m
//  JSONAndXMLDemo
//
//  Created by Gabriel Theodoropoulos on 24/7/14.
//  Copyright (c) 2014 Appcoda. All rights reserved.
//

#import "NeighboursViewController.h"
#import "AppDelegate.h"

@interface NeighboursViewController ()
-(void)downLoadNeibouringCountries;
@end

@implementation NeighboursViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Make self the delegate and datasource of the table view.
    self.tblNeighbours.delegate = self;
    self.tblNeighbours.dataSource = self;
    
    [self downLoadNeibouringCountries];
}

-(void)downLoadNeibouringCountries{
    
    NSString *urlString = [NSString stringWithFormat:@"http://api.geonames.org/neighbours?geonameId=%@&username=%@", self.geoNameID, kUsername];
    NSURL *url = [NSURL URLWithString:urlString];
    
    //Download the data
    
    [AppDelegate downloadDataFromURL:url withCompletionHandeler:^(NSData *data) {
        if (data != nil) {
            //
        }
    }];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UITableView method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

@end
