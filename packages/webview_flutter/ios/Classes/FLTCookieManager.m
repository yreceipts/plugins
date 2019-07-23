#import "FLTCookieManager.h"
#import "CookieDto.h"

@implementation FLTCookieManager {
}

NSSet *websiteDataTypes;
API_AVAILABLE(ios(9.0))
WKWebsiteDataStore *dataStore;
API_AVAILABLE(ios(11.0))
WKHTTPCookieStore *cookieStore;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FLTCookieManager *instance = [[FLTCookieManager alloc] init];

  FlutterMethodChannel *channel =
      [FlutterMethodChannel methodChannelWithName:@"plugins.flutter.io/cookie_manager"
                                  binaryMessenger:[registrar messenger]];
  [registrar addMethodCallDelegate:instance channel:channel];

  if (@available(iOS 11.0, *)) {
    websiteDataTypes = [NSSet setWithArray:@[ WKWebsiteDataTypeCookies ]];
    dataStore = [WKWebsiteDataStore defaultDataStore];
    cookieStore = [dataStore httpCookieStore];
  } else {
    NSLog(@"This plugin is not supported for iOS versions prior to iOS 11.");
  }
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result API_AVAILABLE(ios(11.0)) {
  if ([[call method] isEqualToString:@"clearCookies"]) {
    [self clearCookies:result];
  } else if ([[call method] isEqualToString:@"getCookies"]) {
    [self getCookies:result];
  } else if ([[call method] isEqualToString:@"setCookies"]) {
    [self setCookies:call result:result];
  } else {
    result(FlutterMethodNotImplemented);
  }
}

- (void)getCookies:(FlutterResult)result API_AVAILABLE(ios(11.0)) {
  [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> *cookies) {
    NSArray *serialized = [CookieDto manyToDictionary:[CookieDto manyFromNSHTTPCookies:cookies]];
    result(serialized);
  }];
}

- (void)setCookies:(FlutterMethodCall *)call result:(FlutterResult)result API_AVAILABLE(ios(11.0)) {
  NSArray<CookieDto *> *cookieDtos = [CookieDto manyFromDictionaries:[call arguments]];
  for (CookieDto *cookieDto in cookieDtos) {
    [cookieStore setCookie:[cookieDto toNSHTTPCookie]
         completionHandler:^(){
         }];
  }
}

- (void)clearCookies:(FlutterResult)result API_AVAILABLE(ios(11.0)) {
  [cookieStore getAllCookies:^(NSArray<NSHTTPCookie *> *allCookies) {
    for (NSHTTPCookie *cookie in allCookies) {
      [cookieStore deleteCookie:cookie
              completionHandler:^(){
              }];
    }
  }];
}

@end
