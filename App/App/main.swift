import UIKit

// Launch unit tests without AppDelegate to make them faster
let delegate = CommandLine.arguments.contains("unit_testing") ?
	nil :
	NSStringFromClass(AppDelegate.self)

UIApplicationMain(
	CommandLine.argc,
	CommandLine.unsafeArgv,
	nil,
	delegate
)
