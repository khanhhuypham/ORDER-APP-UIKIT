//
//  TSCPrinter.m
//  TechresOrder
//
//  Created by Pham Khanh Huy on 15/06/2024.
//

#import <Foundation/Foundation.h>
#import "TECHRES_ORDER-Swift.h"
#import "TSCPrinterSDK.h"
#import "TSCPrinter.h"
#import "POSPrinter.h"


@implementation TSCPrinter

// Declaring the static variable which will hold
// the shared instance of MyClass
static TSCPrinter *shared = nil;

// Implementing the shared method
+ (TSCPrinter *)shared{
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

    _ids = [[NSMutableArray alloc] init];;
    _isPrintLive = YES;
//    _printer = [Printer new];
    
    _bleManager = [TSCBLEManager sharedInstance];
    _bleManager.delegate = self;
    
    _wifiManager = [TSCWIFIManager sharedInstance];
    _wifiManager.delegate = self;
    
    self.connectType = WIFI;
    
    return self;
}


-(void)sendNotifiErr:(NSString *)message printer:(Printer*)printer{
    
    NSError *customErr = [NSError
        errorWithDomain: [NSString stringWithFormat:@"%d",kCFStreamErrorDomainNetDB]
        code:8
        userInfo:@{
        NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@: %@",printer.name, message]
    }];
    
    NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
   
    // Set value for key i.e adding an entry
    
    NSMutableDictionary *identifier = [_ids lastObject];
    [_ids removeLastObject];
    
    [dictionary setValue:[identifier valueForKey:@"id"] forKey:@"id"];
    [dictionary setValue:customErr forKey:@"error"];
    [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODTSCPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];

    [[NSNotificationCenter defaultCenter] postNotificationName:PRINTER_NOTIFI.CONNECT_FAIL object:dictionary];
    
    [self wifiDisconnect];
}




-(void)wifiConnect:(Printer*)printer Id:(NSDictionary*)Id{
    _printer = printer;
    [_ids insertObject:Id atIndex:0];
    
    
    if ([_printer.printer_port length] == 0) {
        
        [self sendNotifiErr:@"port is invalid" printer:_printer];
        
    }else if ([_printer.printer_ip_address length] == 0){
        
        [self sendNotifiErr:@"ip address is invalid" printer:_printer];
        
    }else if ([_printer.printer_ip_address length] == 0 && [_printer.printer_port length] == 0){
        
        [self sendNotifiErr:@"ip address and port are invalid" printer:_printer];
        
    }else if(_printer.connection_type != CONNECTION_TYPEWifi){
        
        [self sendNotifiErr:@"Thiết bị đang sử dụng chỉ hỗ trợ đối với máy in rời" printer:_printer];
        
    }else{
    
        if (_wifiManager.isConnect) {
            [_wifiManager disconnect];
        }
        

        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        UInt16 portNumber = [[formatter numberFromString:_printer.printer_port] unsignedShortValue];
        
        [_wifiManager connectWithHost:_printer.printer_ip_address port:portNumber];
    }
 
 
}

- (void)wifiDisconnect{
    _printer = nil;
    switch (self.connectType) {
        case BT:
            [_bleManager disconnectRootPeripheral];
            break;
            
        case WIFI:
            [_wifiManager disconnect];
            break;
            
        default:
            break;
    }
}


-(void)printWithData:(NSMutableData *)printData ids:(NSDictionary*)ids{

    switch (self.connectType) {
        case NONE:
            break;
            
        case WIFI:
            [_wifiManager writeCommandWithData:printData];
            
            break;
            
        case BT:
            [_bleManager writeCommandWithData:printData writeCallBack:^(CBCharacteristic *characteristic, NSError *error) {
                if(!error) {
                    NSLog(@"send success");
                } else {
                    NSLog(@"error:%@",error);
                }
            }];
            break;
            
        default:
            break;
    }
    
}


-(void)printPicture:(UIImage *)image ids:(NSDictionary*)ids{
    [_ids insertObject:ids atIndex:0];
    NSMutableData *dataM = [[NSMutableData alloc] init];

    [dataM appendData:[TSCCommand cls]];
    [dataM appendData:[TSCCommand initialPrinter]];
    [dataM appendData:[TSCCommand referenceWithX:0 andY:0]];
    
    _printer.printer_paper_size == 30
    ? [dataM appendData:[TSCCommand sizeBymmWithWidth:68 andHeight:20]]
    : [dataM appendData:[TSCCommand sizeBymmWithWidth:48 andHeight:28]];

    [dataM appendData:[TSCCommand bitmapWithX:0 andY:0 andMode:0 andImage:image]];
//    [dataM appendData:[TSCCommand formFeed]];
    [dataM appendData:[TSCCommand print:1]];
//    [dataM appendData:[TSCCommand cut]];
    [_wifiManager writeCommandWithData:dataM];

}

#pragma mark - POSBLEManagerDelegate

//connect success
- (void)POSbleConnectPeripheral:(CBPeripheral *)peripheral {
  
}


// disconnect
- (void)POSbleDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
  
}

#pragma mark - POSWIFIManagerDelegate

//connected success
- (void)TSCwifiConnectedToHost:(NSString *)host port:(UInt16)port{

    NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
   
    NSMutableDictionary *identifier = [_ids lastObject];
    [_ids removeLastObject];
    [dictionary setValue:[identifier valueForKey:@"id"]  forKey:@"id"];
    
    [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODTSCPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.CONNECT_SUCCESS : PRINTER_NOTIFI.BACKGROUND_CONNECT_SUCCESS object:dictionary];
    
    
//    NSMutableData *dataM = [[NSMutableData alloc] init];
//    
//    [dataM appendData:[TSCCommand direction:1]];
//    [dataM appendData:[TSCCommand formFeed]];


    
}
/**
 * disconnect error
 */
- (void)TSCwifiDisconnectWithError:(NSError *)error;{
    
    if (_bleManager.isConnecting) {
        _connectType = BT;
    } else {
        _connectType = NONE;
//        [self buttonStateOff];
    }
    

    
    if (error) {
        
        NSError *customErr = [NSError
            errorWithDomain:error.domain
            code:error.code
            userInfo:@{
            NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@: %@",_printer.name, error.localizedDescription]
        }];
        
        NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
       
        // Set value for key i.e adding an entry
        
        NSMutableDictionary *identifier = [_ids lastObject];
        [_ids removeLastObject];
        
        [dictionary setValue:[identifier valueForKey:@"id"] forKey:@"id"];
        [dictionary setValue:customErr forKey:@"error"];
        [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODTSCPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];

        [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.CONNECT_FAIL : PRINTER_NOTIFI.BACKGROUND_CONNECT_FAIL object:dictionary];
        
        [self wifiDisconnect];
        
    }else{
        
    }
    
    if (_isPrintLive){
        NSLog(@"YES");
    }else{
        NSLog(@"NO");
    }
    
    

}


/**
 * send data success
 */
- (void)TSCwifiWriteValueWithTag:(long)tag{
    
    NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *identifier = [_ids lastObject];
    
    [_ids removeLastObject];
    

    [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODTSCPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];
    [dictionary setValue:[identifier valueForKey:@"id"] forKey:@"id"];
    [dictionary setValue:[identifier valueForKey:@"isLastItem"] forKey:@"isLastItem"];

    [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.PRINT_SUCCESS : PRINTER_NOTIFI.BACKGROUND_PRINT_SUCCESS object:dictionary];
    
}

- (void)TSCwifiReceiveValueForData:(NSData *)data{

}

#pragma mark - Test Print


@end
