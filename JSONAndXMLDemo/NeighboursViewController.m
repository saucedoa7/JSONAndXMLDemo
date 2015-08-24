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

@property (nonatomic, strong) NSXMLParser *xmlParser;
@property (nonatomic, strong) NSMutableArray *arrNeighboursData;
@property (nonatomic, strong) NSMutableDictionary *dicTempDataStorage;
@property (nonatomic, strong) NSMutableString *foundValue;
@property (nonatomic, strong) NSString *currentElenent;

/*
 - The xmlParser property is the one that we’ll use to parse the XML data.
 - The arrNeighboursData property is the array that will contain all of the desired data after the parsing has finished.
 - The dictTempDataStorage property is the dictionary in which we’ll temporarily store the two values we seek for each neighbour country until we add it to the array.
 - The foundValue mutable string will be used to store the found characters of the elements of interest.
 - The currentElement string will be assigned with the name of the element that is parsed at any moment.
 */
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
            
            self.xmlParser = [[NSXMLParser alloc] initWithData:data];
            self.xmlParser.delegate = self;
            
            self.foundValue = [NSMutableString new];
            
            //Start Parsing
            [self.xmlParser parse];
            
        }
    }];
    
}

#pragma mark - Parsing Methods

-(void)parserDidStartDocument:(NSXMLParser *)parser{
    self.arrNeighboursData = [NSMutableArray new];
}

-(void)parserDidEndDocument:(NSXMLParser *)parser{
    [self.tblNeighbours reloadData];
}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"%@", [parseError localizedDescription]);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    //If the Element name is equal to "geoname" then initialize the temp dict
    
    if ([elementName isEqualToString:@"geoname"]) {
        self.dicTempDataStorage = [NSMutableDictionary new];
    }
    
    //Keep the current element
    self.currentElenent = elementName;
    
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"geoname"]) {
        // If the Element name is == to "geoname" then all the data of a neighbor country has been parsed and the dict should be added to the neighbours data array
        [self.arrNeighboursData addObject:[[NSDictionary alloc] initWithDictionary:self.dicTempDataStorage]];
    } else if ([elementName isEqualToString:@"name"]){
        // If the country's name element was found then store it
        [self.dicTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"name"];
    } else if ([elementName isEqualToString:@"toponymName"]){
        // If the toponymNameElem
        [self.dicTempDataStorage setObject:[NSString stringWithString:self.foundValue] forKey:@"toponymName"];
    }
    
    //clear the mutable string
    [self.foundValue setString:@""];
    NSLog(@"Dict %@", self.dicTempDataStorage);
    NSLog(@"Current Element %@", elementName);

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
