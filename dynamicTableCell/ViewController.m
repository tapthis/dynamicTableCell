//
//  ViewController.m
//  dynamicTableCell
//
//  Created by Patrik Boras on 15/09/14.
//  Copyright (c) 2014 tapthis. All rights reserved.
//

#import "ViewController.h"
#import "TTDynamicCell.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *_tableItems;
    __weak IBOutlet UITableView *_tableView;
}

@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    if(_tableItems == nil){
        _tableItems = [[NSMutableArray alloc]initWithObjects:@"Bacon ipsum dolor sit amet leberkas frankfurter ",@"Bacon ipsum dolor sit amet leberkas frankfurter capicola ground round, flank pastrami chicken ham ribeye bacon pancetta. Meatball hamburger shank pork loin sausage meatloaf. Pastrami swine boudin bacon spare ribs",@"Chicken flank pastrami, venison rump shoulder swine biltong andouille tenderloin", @"Porchetta swine corned beef, turkey salami brisket pork loin hamburger chuck boudin pork chop chicken sirloin. Ribeye tenderloin fatback jerky brisket spare ribs, short ribs capicola pig. Strip steak tongue spare ribs, venison pork short ribs bacon short loin tri-tip bresaola. Tri-tip pork belly boudin capicola brisket beef shank beef ribs swine ball tip prosciutto ham kevin t-bone leberkas.", nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view data source methods

/*
 The data source methods are handled primarily by the fetch results controller
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tableItems count];
}



- (UITableViewCell *)tableView:(UITableView *)_atableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"TTDynamicCell"];
    TTDynamicCell *cell = (TTDynamicCell*)[_atableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[TTDynamicCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.cellLabel.text = [_tableItems objectAtIndex:indexPath.row];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static UIFont *labelFont;
    static CGRect textFrame;
    static CGFloat extraHeight;
    if(!labelFont){
        // verwendete Zelle auswählen
        TTDynamicCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TTDynamicCell"];
        
        // verwendete Schriftart auswählen
        labelFont = cell.cellLabel.font;
        
        // frame der Zelle
        CGRect cellFrame = cell.frame;
        
        // frame des labels
        textFrame = cell.cellLabel.frame;
        
        // extra Puffer
        extraHeight = cellFrame.size.height-textFrame.size.height+30;
    }
    
    // der anzuzeigende Text
    NSString* text = [_tableItems objectAtIndex:indexPath.row];
    
    // NSAttributedString erstellen
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    // LineBreakMode auf "BreakByWordWrapping" setzen
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [attributedString setAttributes:@{NSParagraphStyleAttributeName:paragraphStyle} range:NSMakeRange(0, attributedString.length)];
    
    // Schriftart auswählen
    [attributedString setAttributes:@{NSFontAttributeName:labelFont} range:NSMakeRange(0, attributedString.length)];
    
    // Hier wird die Höhe berechnet - mit max. Höhe 300
    CGSize expectedSize = [attributedString boundingRectWithSize:CGSizeMake(textFrame.size.width, 300) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return expectedSize.height+extraHeight;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
