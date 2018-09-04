#import "FlutterPhotokitPlugin.h"
#import <flutter_photokit/flutter_photokit-Swift.h>

@implementation FlutterPhotokitPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPhotokitPlugin registerWithRegistrar:registrar];
}
@end
