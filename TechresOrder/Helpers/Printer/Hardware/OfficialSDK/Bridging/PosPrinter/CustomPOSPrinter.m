//
//  CustomPOSPrinter.m
//  TECHRES-ORDER
//
//  Created by Pham Khanh Huy on 19/06/2024.
//

#import "POSPrinterSDK.h"
#import "CodePagePopView.h"
#import "PTable.h"
#import "CustomPOSPrinter.h"
#import "TECHRES_ORDER-Swift.h"
#define Language @"Language"
#define Cancel @"Cancel"
#define Simplified @"Simplified"
#define Traditional @"Traditional"
#define Korea @"Korea"
#define Japanese @"Japanese"
#define Codepage @"Codepage"



@implementation CustomPOSPrinter

// Declaring the static variable which will hold
// the shared instance of MyClass
static CustomPOSPrinter *shared = nil;

// Implementing the shared method
+ (CustomPOSPrinter *)shared{
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
    
    
    _ids = [[NSMutableArray alloc] init];
    
    _isPrintLive = YES;

    _wifiManager = [POSWIFIManager sharedInstance];
    _wifiManager.delegate = self;
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
    [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODPOSPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];

    [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.CONNECT_FAIL : PRINTER_NOTIFI.BACKGROUND_CONNECT_FAIL object:dictionary];
    
    [self wifiDisconnect];
}

 

-(void)wifiConnect:(Printer*)printer queuedItem:(NSDictionary*)queuedItem{
    
    _printer = printer;
    [_ids insertObject:queuedItem atIndex:0];
    
    if ([_printer.printer_port length] == 0) {
        
        [self sendNotifiErr:@"port is invalid" printer:_printer];
        
    }else if ([_printer.printer_ip_address length] == 0){
        
        [self sendNotifiErr:@"ip address is invalid" printer:_printer];
        
    }else if ([_printer.printer_ip_address length] == 0 && [_printer.printer_port length] == 0){
        
        [self sendNotifiErr:@"ip address and port are invalid" printer:_printer];
        
    }else if((_printer.connection_type != CONNECTION_TYPEWifi) && (_printer.connection_type != CONNECTION_TYPEBlueTooth)){
        
        [self sendNotifiErr:@"Thiết bị đang sử dụng chỉ hỗ trợ đối với máy in rời" printer:_printer];
        
    } else{
    
    
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
      
        case WIFI:
            [_wifiManager disconnect];
            break;
            
        default:
            break;
    }
}

-(void)printWithData:(NSData *)printData printedItems:(NSDictionary*)printedItems{
    NSLog(@"%d",_ids.count);
    [_ids insertObject:printedItems atIndex:0];
    
    switch (self.connectType) {
            
        case NONE:
            break;
            
        case WIFI:
            
   
            [_wifiManager writeCommandWithData:printData];
            break;
            
        default:
            break;
    }
    
}



-(void)printPicture:(UIImage *)image printedItems:(NSDictionary*)printedItems{
    NSMutableData *dataM = [NSMutableData dataWithData:[POSCommand initializePrinter]];
    [dataM appendData:[POSCommand selectAlignment:1]];
    [dataM appendData:[POSCommand printRasteBmpWithM:RasterNolmorWH andImage:image andType:Dithering]];
 
    if ([printedItems count] > 0){
        [dataM appendData:[POSCommand printAndFeedForwardWhitN:5]];
        [dataM appendData:[POSCommand selectCutPageModelAndCutpage:0]];
    }
    
    [self printWithData:dataM printedItems:printedItems];
}


#pragma mark - CodePageViewDelegate
- (void)codepageView:(nonnull CodePagePopView *)codepagePopView selectValue:(nonnull NSString *)selectValue {

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
- (void)POSwifiConnectedToHost:(NSString *)host port:(UInt16)port{
    
//    [_wifiManager writeCommandWithData:[POSCommand CancelChineseCharModel]];
//    [_wifiManager writeCommandWithData:[POSCommand setCodePage:27]];
//    [_wifiManager writeCommandWithData:[POSCommand selectCharacterCodePage:22]];
//    [_wifiManager writeCommandWithData:[POSCommand selectPrintMode:1]];
//    
  
    NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
   
    NSMutableDictionary *identifier = [_ids lastObject];
    [_ids removeLastObject];
    
    [dictionary setValue:[identifier valueForKey:@"id"]  forKey:@"id"];
    [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODPOSPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.CONNECT_SUCCESS : PRINTER_NOTIFI.BACKGROUND_CONNECT_SUCCESS object:dictionary];
}
/**
 * disconnect error
 */
- (void)POSwifiDisconnectWithError:(NSError *)error{

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
        [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODPOSPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];

        [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.CONNECT_FAIL : PRINTER_NOTIFI.BACKGROUND_CONNECT_FAIL object:dictionary];
   
        [self wifiDisconnect];
    }
//    else{
//        
//        NSError *customErr = [NSError
//            errorWithDomain:@"Phạm khánh huy unknown Error"
//            code:0
//            userInfo:@{
//            NSLocalizedDescriptionKey:[NSString stringWithFormat:@"%@: unknown Error",_printer.name]
//        }];
//
//        NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
//       
//        // Set value for key i.e adding an entry
//        
//        NSMutableDictionary *identifier = [_ids lastObject];
//        [_ids removeLastObject];
//        
//        [dictionary setValue:[identifier valueForKey:@"id"] forKey:@"id"];
//        [dictionary setValue:customErr forKey:@"error"];
//        [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODPOSPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];
//
//        [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.CONNECT_FAIL : PRINTER_NOTIFI.BACKGROUND_CONNECT_FAIL object:dictionary];
//   
//        [self wifiDisconnect];
//        
//    }
}


/**
 * send data success
 * when our device send data successfully to printer the function below return  tag === 1000
 * when our device check status of  printer the function below return  tag === 1001
 */
- (void)POSwifiWriteValueWithTag:(long)tag{

    if (tag == 1000){
        
        NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
        
        NSMutableArray *printedItem = [_ids lastObject];
        [_ids removeLastObject];
        
        NSLog(@"%d",printedItem.count);
        
        if (printedItem.count > 0) {
            
            [dictionary setValue:[printedItem valueForKey:@"id"] forKey:@"id"];
            [dictionary setValue:[NSNumber numberWithInteger:PRINTER_METHODPOSPrinter] forKey:PRINTER_NOTIFI.PRINTER_METHOD_KEY];
            [dictionary setValue:[printedItem valueForKey:@"isLastItem"] forKey:@"isLastItem"];
          
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.PRINT_SUCCESS : PRINTER_NOTIFI.BACKGROUND_PRINT_SUCCESS object:dictionary];
     
    }else if (tag == 1001){
        
    }else{
        NSLog(@"Phạm Khánh huy else");
    }
}



/**
 * receive printer data
 */
- (void)POSwifiReceiveValueForData:(NSData *)data{

    __weak typeof(self) weakSelf = self;
    [weakSelf getStatusWithData:data];
    
}


// check status
- (void)checkPOSPrinterStatus{
    __weak typeof(self) weakSelf = self;
    if ([_wifiManager printerIsConnect]) {
      
        [_wifiManager printerStatus:^(NSData *status) {
            [weakSelf getStatusWithData:status];
        }];
        
    }else{
        NSLog(@"Pham khanh huy: data is returned from printer");
    }

}


- (void)getStatusWithData:(NSData *)responseData {
    
    if (responseData.length == 0) return;
    
    if (responseData.length == 1) {
        const Byte *byte = (Byte *)[responseData bytes];
        unsigned status = byte[0];
        
        NSMutableDictionary *dictionary =  [[NSMutableDictionary alloc] init];
    
        if (status == 0x12) {
            return;
        } else if (status == 0x16) {
      
            NSError *err = [NSError
                            errorWithDomain:@"pham khanh huy"
                            code:0
                            userInfo:@{NSLocalizedDescriptionKey:@"Nắp máy in đang mở"}
            ];
            
            [dictionary setValue:err forKey:@"error"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.PRINT_FAIL : PRINTER_NOTIFI.BACKGROUND_PRINT_FAIL object:dictionary];
        } else if (status == 0x32) {
           
            NSError *err = [NSError
                            errorWithDomain:@"Pham khanh huy"
                            code:0
                            userInfo:@{NSLocalizedDescriptionKey:@"Máy in hết giấy"}
            ];
            
            [dictionary setValue:err forKey:@"error"];
            [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.PRINT_FAIL : PRINTER_NOTIFI.BACKGROUND_PRINT_FAIL object:dictionary];
        } else if (status == 0x36) {
            
            NSError *err = [NSError
                            errorWithDomain:@"Pham khanh huy"
                            code:100
                            userInfo:@{NSLocalizedDescriptionKey:@"Nắp máy in đang mở &dx"}
            ];
            
            [dictionary setValue:err forKey:@"error"];
            [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.PRINT_FAIL : PRINTER_NOTIFI.BACKGROUND_PRINT_FAIL object:dictionary];
        } else {
           
            NSError *err = [NSError
                            errorWithDomain:@"some_domain"
                            code:100
                            userInfo:@{NSLocalizedDescriptionKey:@"unknown error"}
            ];
            
            [dictionary setValue:err forKey:@"error"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:_isPrintLive ? PRINTER_NOTIFI.PRINT_FAIL : PRINTER_NOTIFI.BACKGROUND_PRINT_FAIL object:dictionary];
        }
    }
}


#pragma mark - Test Print

@end
