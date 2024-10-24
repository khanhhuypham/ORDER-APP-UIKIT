//
//  BLEPrinter.m
//  TechresOrder
//
//  Created by Pham Khanh Huy on 18/07/2024.
//


#import <Foundation/Foundation.h>
#import "POSPrinterSDK.h"
#import "BLEPrinter.h"
#import "TECHRES_ORDER-Swift.h"



@implementation BLEPrinter

// Declaring the static variable which will hold
// the shared instance of MyClass
static BLEPrinter *shared = nil;

// Implementing the shared method
+ (BLEPrinter *)shared{
    // Checking if shared is nil (i.e.
    // the shared instance hasn't been created yet)
    if (shared == nil){
        // Creating a new instance of MyClass using
        // the superclass's allocWithZone method
        shared = [[super allocWithZone:NULL] init];
    }

    // Returning the shared instance
    return shared;
}

// Overriding the allocWithZone method to always
// return the shared instance
+ (id)allocWithZone:(NSZone *)zone{
    return [self shared];
}
 
// Overriding the copyWithZone method to always
// return the same instance (since this is a singleton)
- (id)copyWithZone:(NSZone *)zone{
    return self;
}
 
// Implementing the init method to initialize any
// instance variables (if needed)
- (id)init{
    self = [super init];
    if (self != nil){
        // Initialize instance variables here
    }
    
    _printedItems = [[NSMutableArray alloc] init];
    
    _bleManager = [POSBLEManager sharedInstance];
    _bleManager.delegate = self;
    
    

    return self;
}
 
- (void)dealloc {
    [_bleManager removeDelegate:self];
}

-(void)printWithData:(NSData *)printData printedItems:(NSDictionary*)printedItems{
  
    [_printedItems insertObject:printedItems atIndex:0];

    [_bleManager writeCommandWithData:printData writeCallBack:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"%@",characteristic);
        if(!error) {
            NSLog(@"send success");
        } else {
            NSLog(@"error:%@",error);
        }
    }];
    
}


-(void)BLEConnect:(CBPeripheral *)peripheral{
    [_bleManager connectDevice:peripheral];
}



#pragma mark - POSBLEManagerDelegate
//connect success
- (void)POSbleConnectPeripheral:(CBPeripheral *)peripheral {
    NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
    // Set value for key i.e adding an entry
    [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODBLEPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];

    [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.CONNECT_SUCCESS object:dictionary];
    

    [_bleManager writeCommandWithData:[POSCommand CancelChineseCharModel]];
    [_bleManager writeCommandWithData:[POSCommand setCodePage:27]];
    [_bleManager writeCommandWithData:[POSCommand selectCharacterCodePage:27]];
    
}


// disconnect
- (void)POSbleDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
   
    NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
   
    [dictionary setValue:error forKey:@"error"];
    [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODBLEPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.CONNECT_FAIL object:dictionary];
}


/**
 *  send data success
 */
- (void)POSbleWriteValueForCharacteristic:(CBCharacteristic *)character error:(NSError *)error{
    
    
    if (error){
        NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
       
        [dictionary setValue:error forKey:@"error"];
        [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODBLEPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.CONNECT_FAIL object:dictionary];
        return;
    }else{
        
        NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
        NSMutableArray *printedItem = [_printedItems lastObject];
        [_printedItems removeLastObject];

        if (printedItem.count > 0) {

            [dictionary setValue:[printedItem valueForKey:@"id"] forKey:@"id"];
            [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODBLEPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];
            [dictionary setValue:[printedItem valueForKey:@"isLastItem"] forKey:@"isLastItem"];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName: PRINTER_NOTIFI.PRINT_SUCCESS object:dictionary];
    }
}



@end
