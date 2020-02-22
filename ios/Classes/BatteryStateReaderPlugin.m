#import "BatteryStateReaderPlugin.h"
#if __has_include(<battery_state_reader/battery_state_reader-Swift.h>)
#import <battery_state_reader/battery_state_reader-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "battery_state_reader-Swift.h"
#endif

@implementation BatteryStateReaderPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftBatteryStateReaderPlugin registerWithRegistrar:registrar];
}
@end
