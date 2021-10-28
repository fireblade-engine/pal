//
// APPLPlatform.swift
// Fireblade PAL
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_APPL

    #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
        import AppKit
    #elseif FRB_PLATFORM_APPL_IOS || targetEnvironment(macCatalyst)
        import UIKit
    #endif

    enum APPLPlatform: PlatformInitialization {
        static func initialize() {
            #warning("❗TODO: initialize APPLPlatform")
        }

        static func quit() {
            #warning("❗TODO: quit APPLPlatform")
        }

        static func main() -> Int {
            #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
                return Int(mainAppKit())
            #elseif FRB_PLATFORM_APPL_IOS || targetEnvironment(macCatalyst)
                return Int(mainUIKit(app: app))
            #endif
        }

        #if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)

            // MARK: - AppKit

            static func mainAppKit() -> Int32 {
                let nsApp = _APPLApplication.shared
                let strongDelegate = APPLAppDelegate()

                nsApp.delegate = strongDelegate
                let status = NSApplicationMain(CommandLine.argc,
                                               CommandLine.unsafeArgv)

                return status
            }

        #elseif FRB_PLATFORM_APPL_IOS || targetEnvironment(macCatalyst)

            // MARK: - UIKit

            static func mainUIKit(app: AppDelegate) -> Int32 {
                APPLAppDelegate.app = app
                let status = UIApplicationMain(
                    CommandLine.argc,
                    CommandLine.unsafeArgv,
                    nil,
                    NSStringFromClass(APPLAppDelegate.self)
                )
                return status
            }
        #endif
    } // -- APPLAppMain

#endif
