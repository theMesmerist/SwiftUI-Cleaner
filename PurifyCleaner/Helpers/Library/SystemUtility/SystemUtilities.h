//
//  SystemUtilities.h
//  SystemUtilities
//
//  v2.0 New functions 1/27/13
//  v3.0 New Text2Speech functions 2/28/13 - marked as 'NEW'
//  v3.1 New network data counter function
//  v3.2 Fixed Text2Speech with lines > 100 characters. No breaks into lines at word breaks.
//  v3.6
//  v3.7 New screen display functions
//  v3.8 fixed getTotalMemory function
//  v3.8.1 bug fixes
//  v4.0 added support for all devices
//  v4.1 ARC and added a method to get DNS Servers details
//  v4.2 added to determine if device has Siri or TouchID
//  v5.0 new demo, ARC and code cleanup
//  v5.1 iPhone 6 support, new demo, ARC and code cleanup
//  v5.2 iPhone 6 support
//  v5.3 new AirPlay, Bonjour and Location methods
//
//  Copyright (c) 2014 MarkelSoft, Inc. All rights reserved.
//
// Text to speech uses Google Text to Speech API - GNU Lesser General Public License (LGPL) - free to use

#import <Foundation/Foundation.h>
#import <ExternalAccessory/ExternalAccessory.h>
#import <ExternalAccessory/EAAccessoryManager.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AVFoundation/AVFoundation.h>

#import <arpa/inet.h>
#import <sys/ioctl.h>
#import <sys/socket.h>
#import <sys/sysctl.h>
#import <sys/utsname.h>
#import <sys/times.h>
#import <sys/stat.h>
#import <sys/_structs.h>
#import <resolv.h>
#import <dns.h>
#import <errno.h>
#import <net/if.h>
#import <asl.h>
#import <ifaddrs.h>
#include <stdio.h>

#include <sys/types.h>
#include <mach/mach_traps.h>
#include <mach/thread_info.h>
#include <mach/thread_act.h>
#include <mach/vm_region.h>
#include <mach/vm_map.h>
#include <mach/task.h>

#include <mach/mach_init.h>
#include <mach/mach_host.h>
#include <mach/mach_port.h>
#include <mach/task_info.h>
#include <mach/thread_info.h>
#include <mach/thread_act.h>

#include <stdbool.h>

#import "ALHardware.h"
#import "IPAddress.h"
#import "UIDevice+IdentifierAddition.h"
#import "UIDevice+Resolutions.h"

#import "AirPlayUtils.h"
#import "BonjourUtils.h"
#import "LocationUtils.h"

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface SystemUtilities : NSObject <AirPlayUtilsDelegate, BonjourUtilsDelegate> {
    
}

//
// System Utility Functions
//

// new v5.3 (AirPlay, Bonjour and Location)

// AirPlay Services functions
+ (int)getAirPlayServicesCount;
+ (NSMutableArray *)getAirPlayServicesNames;
+ (NSString *)getAirPlayServicesStr;
// end of AirPlay Services functions

// Bonjour services functions
+ (int)getBonjourServicesCount;
+ (NSMutableArray *)getBonjourServicesNames;
+ (NSString *)getBonjourServicesStr;
// end of Bonjour Services functions

// Location-based functions

+ (BOOL)isIOS8AndAbove;                          // check for if running iOS8+ and above

+ (void)setAirPlayVerbose:(BOOL)verbose;         // turn AirPlay services verbose mode on
+ (void)setBonjourVerbose:(BOOL)verbose;        // turn Bonjour services verbose mode on
+ (void)setLocationVerbose:(BOOL)verbose;        // turn location services verbose mode on

+ (void)sendAirPlayNotifications:(id<AirPlayUtilsDelegate>)airPlayDelegate;   // request AirPlay Services notifications
+ (void)sendBonjourNotifications:(id<BonjourUtilsDelegate>)bonjourDelegate;   // request Bonjour Services notifications

+ (BOOL)locationServicesAreEnabled;              // are location-based services enabled
+ (BOOL)isGettingAddress;                        // determine whether is in process of getting address
+ (BOOL)isNewAddress;                            // determine whether current address is a new address

+ (CLLocationDistance)getDistanceFilter;         // get the distance filter being used by the Location Manager
+ (void)setDistanceFilter:(CLLocationDistance)distance;    // set the distance filter being used by the Location Manager
+ (CLLocationAccuracy)getDesiredAccuracy;        // get the desired accuracy being used by the Location Manager
+ (void)setDesiredAccuracy:(CLLocationAccuracy)accuracy;   // set the desired accuracy used by the Location Manager

+ (CLLocation *)getCurrentLocation;              // get the current location
+ (CLLocation *)getOldLocation;                  // get the old (previous) location
+ (BOOL)isSameLocation:(CLLocation *)location1 location2:(CLLocation*)location2;    // see if 2 locations are the same location

+ (CLLocationDistance)getDistanceBetween:(CLLocation *)fromLocation toLocation:(CLLocation *)toLocation;   // get distance between two locations
+ (NSString *)getFormattedDistanceBetween:(CLLocation *)fromLocation toLocation:(CLLocation *)toLocation;  // get distance between 2 locations formatted

+ (CLLocationCoordinate2D)getCurrentCoordinate;  // get the current location coordinate
+ (NSString *)getCurrentFormattedCoordinate;     // get the current location coordinate formatted (e.g. lat long)

+ (NSString *)getCurrentAddress;                 // get the current location address
+ (NSString *)getCurrentAddressNotify:(id<LocationUtilsDelegate>)locationDelegate;  // get current address and
                                                 // notify 'locationDelegate' when address changes

+ (NSString *)getCurrentGPSSignal;               // get the current GPS Signal strength
+ (int)getCurrentGPSSignalAccuracy;              // get the current GPS Signal accuracy

+ (NSString *)getCurrentHeading;                 // current GPS heading
+ (int)getCurrentHeadingAccuracy;                // current heading accuracy

+ (float)getCurrentLatitude;                     // get current location latitude
+ (float)getCurrentLongitude;                    // get current location longitude
+ (float)getCurrentAltitude;                     // get current location altitude
+ (float)getCurrentSpeed;                        // get current location speed

+ (NSString *)getCurrentFormattedLatitude;       // get current location latitude formatted (e.g. 38 degrees 47' N)
+ (NSString *)getCurrentFormattedLongitude;      // get current location longitude formatted (e.g.  77 degrees 25' N)
+ (NSString *)getCurrentFormattedAltitude;       // get current location altitude formatted (e.g. 283.73 feet (86.48 m)
+ (NSString *)getCurrentFormattedSpeed;          // get current location speed formatted (e.g. 0 m/s (0 mph))

// end of Location-based functions

+ (BOOL)hasSiri;                                 // determine if device has Siri
+ (BOOL)hasTouchID;                              // determine if device has TouchID

// get network data counters (WiFi and WWAN)
//
// return NSArray of 4 NSNumber unsigned int counters
//        [0] WiFi Sent, [1] WiFi Received, [2] WWAN Sent,  [3] WWAN Received
+ (NSArray *)getNetworkDataCounters;

//
// General file utilities:
//

+ (BOOL)doesFileAtPathExist:(NSString *)path;   // determine if the file at the path exists
+ (BOOL)doesFileExist:(NSURL *)fileUrl;         // determine if the file at the url exists
+ (BOOL)deleteFileAtPath:(NSString *)path;      // delete the file at the specified path
+ (BOOL)deleteFile:(NSURL *)fileUrl;            // delete the file at the specified url

//
// Text to Speech methods:
//

// start of Text to Speech
// ---------------------------------------------

// read specified text - include linebreaks for multiple lines and will speak each line
+ (BOOL)readText:(NSString *)text;

// read specified text - include linebreaks for multiple lines and will speak each line
// wait specifies whether to wait for the audio to be done playing
+ (BOOL)readText:(NSString *)text wait:(BOOL)wait;

// formats text into lines of a max length with all lines being on word breaks
+ (NSMutableArray *)formatTextLine:(NSString *)text maxLength:(int)maxLength;

// read specified text for single line
// wait specifies whether to wait for the audio to be done playing
+ (BOOL)readTextLine:(NSString *)text wait:(BOOL)wait;

// get the reading text language code (e.g. en, fr, es)
+ (NSString *)getReadingLocaleLanguageCode;

// get a description for the reading locale being used
+ (NSString *)getReadingLocaleDescription;

// get the locale used for reading text
// locale specifies the locale to use.  If nil then default of current locale used
+ (NSLocale *)getReadTextLocale;

// set the locale used for reading text
// locale specifies the locale to use.  If nil then default of current locale used
+ (void)setReadTextLocale:(NSLocale *)locale;

// get list of available locales
//
// return NSArray of localeIdentifiers (e.g. en, fr, es)
+ (NSArray *)getAvailableLocaleIdentifiers;

// read specified text - works best with single lines
//
// return file system path of the created audio file readtextfile.mp3 (default filename)
+ (NSString *)getAudioFileForText:(NSString *)text;

// read specified text - works best with single lines
// name specified name of output audio file (e.g. readtextfile.mp3)
//
// return file system path of the created audio file with your name
+ (NSString *)getAudioFileForText:(NSString *)text name:(NSString *)name;

// play audio file at specified path
// wait specifies whether to wait for the audio to be done playing
+ (BOOL)playAudioFileUsingPath:(NSString *)audioFilePath wait:(BOOL)wait;

// play audio file at specified URL
// wait specifies whether to wait for the audio to be done playing
+ (BOOL)playAudioFile:(NSURL *)audioFileUrl wait:(BOOL)wait;

// end of Text to Speech
// ---------------------------------------------


+ (CGFloat)getScreenBrightness;      // get screen brightness (from 0.0 to 1.0)
// set screen brightness - value from 0.0 to 1.0
+ (BOOL)setScreenBrightness:(CGFloat)brightness;

+ (UIDeviceResolution)getDeviceResolution;    // get the device resolution
+ (NSString *)getDeviceResolutionStr:(BOOL)includeDeviceName;    // get the device resolution
+ (NSString *)getScreenResolution;   // get the screen resolution details
+ (CGRect)getScreenRect;             // get screen rect
+ (CGRect)getScreenAppRect;          // get screen appication rect
+ (int)getScreenWidth;               // get screen width
+ (int)getScreenHeight;              // get screen height
+ (CGFloat)getScreenScale;           // get screen scale
+ (BOOL)isScreenRetina;              // is screen retina.  TRUE = retina, else not retina.

+ (BOOL)isMirroringSupported;          // is mirroring supported and active.  TRUE = yes and active, FALSE - no

+ (NSString *)getCPUUsageAsStr;        // CPU usage in string format
+ (NSString *)getCPUTimeCurrentThreadAsStr;  // CPU time for current thread in string format
+ (NSString *)getCPUTimeAllThreadsAsStr;     // CPU time for all threads in string format
+ (float)getCPUUsage;                  // get CPU Usage

//+ (NSString *)getDNSServers;           // get list of DNS Server IPs
+ (NSString *)getSSIDForWifi;          // get the WiFi SSID (network name)
+ (NSString *)getBSSIDForWifi;         // get the WiFi BSSID
+ (NSString *)getNetworkNameForWifi;   // get the WiFi network name (SSID)

+ (NSString *)getTxStr;                // get network bytes sent as string
+ (NSString *)getNetworkTxStr;         // get network bytes sent as string
+ (NSString *)getRxStr;                // get network bytes received as string
+ (NSString *)getNetworkRxStr;         // get network bytes received as string

+ (u_long)getNetworkTx;                // get network Tx bytes sent
+ (u_long)getNetworkBytesTransmitted;  // get network bytes sent
+ (u_long)getNetworkRx;                // get network Rx bytes received
+ (u_long)getNetworkBytesReceived;     // get network bytes received

+ (NSString *)getSystemUptime;      // system uptime in days, hours, minutes e.g. 1d 0h 7min

+ (NSString *)getProcessorInfo;     // procssor information including number of processors and number of processors active
+ (NSString *)getCPUFrequency;      // processor CPU speed (MHz)
+ (NSString *)getBusFrequency;      // processor BUS speed (MHz)

+ (NSString *)getAccessoryInfo;     // information on any accessories attach to the device

+ (NSString *)getCarrierInfo;       // phone carrier information including carrier name, carrier country and whether VOIP is allowed
+ (NSString *)getCarrierName;       // phone carrier name
+ (NSString *)getCarrierMobileCountryCode;  // phone carrier mobile country code
+ (NSString *)getCarrierISOCountryCode;     // phone carrier ISO country code
+ (NSString *)getCarrierMobileNetworkCode;  // phone carrier mobile network code
+ (BOOL)doesCarrierAllowVOIP;       // whether phone carrier allows VOIP (Voice over IP)
+ (NSString * )getMCC_country:(NSString *)carrierMobileCountryCode;  // mobile country for mobile country code
+ (NSString *)getCountry:(NSString *)_countryCode;  // country for country code

+ (NSString *)getBatteryLevelInfo;  // battery level information including percent charges and whether plugged in and charging
+ (float)getBatteryLevel;           // battery level percentage charged

+ (NSString *)getUniqueIdentifier;  // unique identifier for the device

+ (NSString *)getModel;             // model of the device
+ (NSString *)getName;              // name identifying the device
+ (NSString *)getSystemName;        // name the operating system (OS) running on the device
+ (NSString *)getSystemVersion;     // current version of the operating system (OS)

+ (NSString *)getDeviceType;        // device type e.g. 'iPhone4,1' for 'iPhone 4' and 'iPad3,3' and 'New iPad'
+ (NSString *)getRealDeviceType;    // real device type e.g. 'iPhone4,1' real device type is 'iPhone 4'
+ (NSString *)getDeviceTypeAndReal; // device type and real device type e.g. 'iPhone 4,1 iPhone 4'

+ (BOOL)onWifiNetwork;               // Determine if on Wifi network.  TRUE - yes, FALSE - no
+ (BOOL)on3GNetwork;                 // Determine if on a 3G (or 4G) network,  TRUE - yes, FALSE - no
+ (NSMutableArray *)getMacAddresses; // MAC (Media Access Control) addresses    
+ (NSString *)getCellAddress;        // Cell phone IP address (on 4G, 3G etc. network.  Note: getMacAddresses must be called beore getCellAddress)
+ (NSString *)getIPAddress;          // Device IP address on 
+ (NSString *)getIPAddressForWifi;   // IP address for Wifi
+ (NSString *)getNetmaskForWifi;     // Network mask for Wifi
+ (NSString *)getBroadcastForWifi;   // Boardcast IP address or Wifi

+ (NSMutableArray *)getAppLog:(NSString *)_name verbose:(BOOL)_verbose;  // Application log for a specific application

+ (NSMutableArray *)getProcessInfo;   // Process information including PID (process ID), process name, PPID (paren process ID) and status
+ (int)getParentPID:(int)pid;         // PID (parent ID) for a PID (process ID)

+ (NSString *)getDiskSpace;           // Total disk space formatted
+ (NSString *)getFreeDiskSpace;       // Free disk space formatted
+ (NSString *)getFreeDiskSpaceAndPct; // Free disk and percent disk free formatted
+ (NSString *)getFreeDiskSpacePct;    // Disk space free percentage formatted
+ (NSString *)getFreeMemoryAndPct;    // Free memory and percent memory free formatted
+ (NSString *)getUsedMemoryPct;       // Used memory percentage formatted
+ (NSString *)getTotalMemoryStr;      // Total memory formatted
+ (NSString *)getFreeMemoryStr;       // Free memory formatted
+ (long long)getlDiskSpace;           // Total disk space
+ (long long)getlFreeDiskSpace;       // Free disk space

+ (double)getFreeMemory;              // Free memory
+ (double)getTotalMemory;             // Total memory
+ (double)getUsedMemory;              // Used memory
+ (double)getAvailableMemory;         // Available memory
+ (double)getActiveMemory;            // Active memory (used by running apps)
+ (double)getInActiveMemory;          // Inactive memory (recently used by apps no loger running)
+ (double)getWiredMemory;             // Wired memory (used by OS)
+ (double)getPurgableMemory;          // Puragable memory (can be freed)

+ (BOOL)isRunningIPad;                // Determine if device running iPad.  TRUE - running iPad, FALSE running iPhone, iPod Touch, ...
+ (BOOL)isRunningIPad2;               // (Alternative method) Determine if device running iPad.  TRUE - running iPad, FALSE running iPhone, iPod Touch, ...
+ (BOOL)isIPhone;                     // Determine if device is an iPhone
+ (BOOL)isIPhone2;                    // (Alternative method) Determine if device is an iPhone
+ (BOOL)isIPhone4;                    // Determine if device running is an iPhone 4
+ (BOOL)doesSupportMultitasking;      // Determine if device supports multitasking. TRUE - yes, FALSE - no
+ (BOOL)isProximitySensorAvailable;   // Determine if proximity sensor is available for the device.   TRUE - yes, FALSE - no

//
// Utility methods
//

+ (void)loadCodes;   // utility method for loading country codes

// formatting...
//
+ (NSString *)formatBytes:(int)_number;
+ (NSString *)formatBytes2:(long long)_number;
+ (NSString *)formatBytes3:(u_long)_number;
+ (NSString *)formatDBytes:(double)_number;
+ (NSString *)formatNumber:(int)_number;
+ (NSString *)formatNumber2:(unsigned long long)_number;
+ (NSString *)formatNumber3:(unsigned long)_number;
+ (NSString *)formatNumber4:(unsigned int)_number;

// system utptime...
+ (NSTimeInterval)uptime:(NSNumber **)days hours:(NSNumber **)hours mins:(NSNumber **)mins;

// network related...
+ (NSString *)broadcastAddressForAddress:(NSString *)ipAddress withMask:(NSString *)netmask;
+ (NSString *)ipAddressForInterface:(NSString *)ifName;
+ (NSString *)ipAddressForWifi;
+ (NSString *)netmaskForInterface:(NSString *)ifName;
+ (NSString *)netmaskForWifi;

// --------------------------------------------------------
//
struct	tcpstat_ex {
	u_long	tcps_connattempt;	/* connections initiated */
	u_long	tcps_accepts;		/* connections accepted */
	u_long	tcps_connects;		/* connections established */
	u_long	tcps_drops;		    /* connections dropped */
	u_long	tcps_conndrops;		/* embryonic connections dropped */
	u_long	tcps_closed;		/* conn. closed (includes drops) */
	u_long	tcps_segstimed;		/* segs where we tried to get rtt */
	u_long	tcps_rttupdated;	/* times we succeeded */
	u_long	tcps_delack;		/* delayed acks sent */
	u_long	tcps_timeoutdrop;	/* conn. dropped in rxmt timeout */
	u_long	tcps_rexmttimeo;	/* retransmit timeouts */
	u_long	tcps_persisttimeo;	/* persist timeouts */
	u_long	tcps_keeptimeo;		/* keepalive timeouts */
	u_long	tcps_keepprobe;		/* keepalive probes sent */
	u_long	tcps_keepdrops;		/* connections dropped in keepalive */
    
	u_long	tcps_sndtotal;		/* total packets sent */
	u_long	tcps_sndpack;		/* data packets sent */
	u_long	tcps_sndbyte;		/* data bytes sent */
	u_long	tcps_sndrexmitpack;	/* data packets retransmitted */
	u_long	tcps_sndrexmitbyte;	/* data bytes retransmitted */
	u_long	tcps_sndacks;		/* ack-only packets sent */
	u_long	tcps_sndprobe;		/* window probes sent */
	u_long	tcps_sndurg;		/* packets sent with URG only */
	u_long	tcps_sndwinup;		/* window update-only packets sent */
	u_long	tcps_sndctrl;		/* control (SYN|FIN|RST) packets sent */
    
	u_long	tcps_rcvtotal;		/* total packets received */
	u_long	tcps_rcvpack;		/* packets received in sequence */
	u_long	tcps_rcvbyte;		/* bytes received in sequence */
	u_long	tcps_rcvbadsum;		/* packets received with ccksum errs */
	u_long	tcps_rcvbadoff;		/* packets received with bad offset */
	u_long	tcps_rcvshort;		/* packets received too short */
	u_long	tcps_rcvduppack;	/* duplicate-only packets received */
	u_long	tcps_rcvdupbyte;	/* duplicate-only bytes received */
	u_long	tcps_rcvpartduppack;	/* packets with some duplicate data */
	u_long	tcps_rcvpartdupbyte;	/* dup. bytes in part-dup. packets */
	u_long	tcps_rcvoopack;		/* out-of-order packets received */
	u_long	tcps_rcvoobyte;		/* out-of-order bytes received */
	u_long	tcps_rcvpackafterwin;	/* packets with data after window */
	u_long	tcps_rcvbyteafterwin;	/* bytes rcvd after window */
	u_long	tcps_rcvafterclose;	/* packets rcvd after "close" */
	u_long	tcps_rcvwinprobe;	/* rcvd window probe packets */
	u_long	tcps_rcvdupack;		/* rcvd duplicate acks */
	u_long	tcps_rcvacktoomuch;	/* rcvd acks for unsent data */
	u_long	tcps_rcvackpack;	/* rcvd ack packets */
	u_long	tcps_rcvackbyte;	/* bytes acked by rcvd acks */
	u_long	tcps_rcvwinupd;		/* rcvd window update packets */
};

@end
