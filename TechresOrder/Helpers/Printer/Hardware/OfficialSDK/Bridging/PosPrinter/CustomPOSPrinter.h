//
//  CustomPOSPrinter.h
//  TechresOrder
//
//  Created by Pham Khanh Huy on 19/06/2024.
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





typedef NS_ENUM(NSInteger, ConnectType) {
    NONE = 0,   //None
    BT,         //Bluetooth
    WIFI,       //WiFi
};

typedef NS_ENUM(NSInteger, ENCRYPT) {
    ENCRYPT_NULL = 0,
    ENCRYPT_WEP64,
    ENCRYPT_WEP128,
    ENCRYPT_WPA_AES_PSK,
    ENCRYPT_WPA_TKIP_PSK,
    ENCRYPT_WPA_TKIP_AES_PSK,
    ENCRYPT_WP2_AES_PSK,
    ENCRYPT_WP2_TKIP,
    ENCRYPT_WP2_TKIP_AES_PSK,
    ENCRYPT_WPA_WPA2_MixedMode
};
@class Printer;

@interface CustomPOSPrinter:NSObject  <POSBLEManagerDelegate, POSWIFIManagerDelegate, CodePageViewDelegate,NSCopying>


// Declaring the sharedInstance method which
// returns a MyClass instance
+ (CustomPOSPrinter *)shared;

@property (strong, nonatomic) Printer *printer;

@property (nonatomic, readwrite) NSMutableArray* ids;

@property (nonatomic, readwrite) BOOL isPrintLive; //is app printing live or under background

// connect type
@property (assign, nonatomic) ConnectType connectType;


// wifi manager
@property (strong, nonatomic) POSWIFIManager *wifiManager;

-(instancetype)init;

-(void)wifiConnect:(Printer*)printer queuedItem:(NSDictionary*)queuedItem;

-(void)wifiDisconnect;

-(void)printWithData:(NSData *)printData printedItems:(NSDictionary*)printedItems;

-(void)printPicture:(UIImage *)image printedItems:(NSDictionary*)printedItems;


-(void)checkPOSPrinterStatus;


-(void)sendNotifiErr:(NSString *)message printer:(Printer*)printer;


@end
