//
//  BridgingHeader.h
//  ExampleApp
//
//  Created by Andromeda on 01/08/2021.
//

#ifndef BridgingHeader_h
#define BridgingHeader_h

@import WebKit;


@interface WKWebViewConfiguration (Private)
@property (nonatomic, setter=_setOverrideContentSecurityPolicy:) NSString *_overrideContentSecurityPolicy API_AVAILABLE(macos(10.12.3), ios(10.3));
@property (nonatomic, setter=_setLoadsFromNetwork:) BOOL _loadsFromNetwork API_AVAILABLE(macos(11.0), ios(14.0));
@property (nonatomic, copy, setter=_setAllowedNetworkHosts:) NSSet <NSString *> *_allowedNetworkHosts API_AVAILABLE(macos(11.0), ios(15.0));
@property (nonatomic, setter=_setLoadsSubresources:) BOOL _loadsSubresources API_AVAILABLE(macos(11.0), ios(14.0));
@end




#endif /* BridgingHeader_h */
