#import "FlutterSocketPlugin.h"
#import <flutter_socket_plugin/flutter_socket_plugin-Swift.h>

@implementation FlutterSocketPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterSocketPlugin registerWithRegistrar:registrar];
}
@end
