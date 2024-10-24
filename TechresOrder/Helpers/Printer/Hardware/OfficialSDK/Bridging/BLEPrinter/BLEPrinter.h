//
//  BLEPrinter.h
//  TechresOrder
//
//  Created by Pham Khanh Huy on 18/07/2024.
//


#import "POSPrinterSDK.h"
#import "CodePagePopView.h"
#import "PTable.h"
#define Language @"Language"
#define Cancel @"Cancel"
#define Simplified @"Simplified"
#define Traditional @"Traditional"
#define Korea @"Korea"
#define Japanese @"Japanese"

#define Codepage @"Codepage"


@interface BLEPrinter:NSObject <POSBLEManagerDelegate,NSCopying>

// Declaring the sharedInstance method which
// returns a MyClass instance
+ (BLEPrinter *)shared;

// bluetooth manager
@property (strong, nonatomic) POSBLEManager *bleManager;
@property (nonatomic, readwrite) NSMutableArray* printedItems;

-(instancetype)init;

-(void)printWithData:(NSData *)printData printedItems:(NSDictionary*)printedItems;

-(void)BLEConnect:(CBPeripheral *)peripheral;



@end
