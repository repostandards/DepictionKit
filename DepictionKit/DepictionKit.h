//
//  DepictionKit.h
//  DepictionKit
//
//  Created by Adam Demasi on 4/8/21.
//

#import <Foundation/Foundation.h>

//! Project version number for DepictionKit.
FOUNDATION_EXPORT double DepictionKitVersionNumber;

//! Project version string for DepictionKit.
FOUNDATION_EXPORT const unsigned char DepictionKitVersionString[];

//! Private API required for TextView sandboxing.
@import WebKit;

@interface WKWebViewConfiguration (Private)
@property (nonatomic, setter=_setOverrideContentSecurityPolicy:) NSString *_overrideContentSecurityPolicy API_AVAILABLE(macos(10.12.3), ios(10.3));
@property (nonatomic, setter=_setLoadsFromNetwork:) BOOL _loadsFromNetwork API_AVAILABLE(macos(11.0), ios(14.0));
@property (nonatomic, copy, setter=_setAllowedNetworkHosts:) NSSet <NSString *> *_allowedNetworkHosts API_AVAILABLE(macos(11.0), ios(15.0));
@property (nonatomic, setter=_setLoadsSubresources:) BOOL _loadsSubresources API_AVAILABLE(macos(11.0), ios(14.0));
@end
