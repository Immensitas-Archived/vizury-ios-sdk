//
//  ViewController.m
//  HelloVizury
//
//  Created by Anurag on 9/7/17.
//  Copyright © 2017 Anurag. All rights reserved.
//

#import "ViewController.h"
#import <VizuryEventLogger/VizuryEventLogger.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad started");
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)normalEvent:(id)sender {
    NSDictionary *attributeDictionary  =   [[NSDictionary alloc] initWithObjectsAndKeys:
                                            @"AKSJDASNBD",@"productid",
                                            @"789", @"productPrice",
                                            @"Shirt",@"category",
                                            nil];
    
    [VizuryEventLogger logEvent:@"productPage" WithAttributes:attributeDictionary];
}

// you can send the attributes as JSONArray or JSONObject also
- (IBAction)JSONEvent:(UIButton *)sender {
    
    // sending a JSONObject
    NSDictionary *productDetail = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @"62112",@"product_id",
                                   @"1",@"quantity",
                                   @"50", @"price",
                                   nil];
    
    NSData *productjsonData = [NSJSONSerialization dataWithJSONObject:productDetail options:0 error:nil];
    NSString *productjsonStr = [[NSString alloc] initWithData:productjsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *productjsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                           productjsonStr,@"viz_data",
                                           nil];
    [VizuryEventLogger logEvent:@"productDetails" WithAttributes:productjsonDictionary];
    
    // sending a JSON Array of Objects
    NSMutableArray *products = [[NSMutableArray alloc] init];
    NSDictionary *productDetail1 = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"62112",@"product_id",
                                    @"1",@"quantity",
                                    @"50", @"price",
                                    nil];
    
    NSDictionary *productDetail2 = [NSDictionary dictionaryWithObjectsAndKeys:
                                    @"123123",@"product_id",
                                    @"1",@"quantity",
                                    @"50", @"price",
                                    nil];
    
    [products addObject:productDetail1];
    [products addObject:productDetail2];
    
    NSData *wishListjsonData = [NSJSONSerialization dataWithJSONObject:products options:0 error:nil];
    NSString *wishListjsonStr = [[NSString alloc] initWithData:wishListjsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *wishListjsonDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                            wishListjsonStr,@"viz_data",
                                            nil];
    
    [VizuryEventLogger logEvent:@"wishlist" WithAttributes:wishListjsonDictionary];
}

@end
