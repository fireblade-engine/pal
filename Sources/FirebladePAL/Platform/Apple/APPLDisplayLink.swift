//
// APPLDisplayLink.swift
// Fireblade PAL
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_APPL

    import class Dispatch.DispatchQueue
    import class Dispatch.DispatchSource
    import protocol Dispatch.DispatchSourceUserDataAdd

    import CoreVideo
    import func ObjectiveC.autoreleasepool

    #if FRB_PLATFORM_APPL_IOS || targetEnvironment(macCatalyst)
        import QuartzCore
    #endif

    protocol APPLDisplayLinkDelegate: AnyObject {
        func displayLinkDidRequestFrameOutput()
    }

    // <https://developer.apple.com/documentation/metal/drawable_objects/creating_a_custom_metal_view>

    #if FRB_PLATFORM_APPL_MACOS
        typealias APPLDisplayLink = APPLDisplayLinkMacOS
        final class APPLDisplayLinkMacOS {
            private let dispatchSource: DispatchSourceUserDataAdd
            private var displayLink: _APPLDisplayLink?

            private weak var delegate: APPLDisplayLinkDelegate?

            init(delegate: APPLDisplayLinkDelegate, targetQueue: DispatchQueue?) {
                self.delegate = delegate

                dispatchSource = DispatchSource.makeUserDataAddSource(vkQueue: targetQueue)

                dispatchSource.setEventHandler { [weak self] in
                    autoreleasepool { [weak self] in
                        self?.delegate?.displayLinkDidRequestFrameOutput()
                    }
                }
            }

            /// Indicates whether a given display link is running.
            var isRunning: Bool {
                guard let displayLink = self.displayLink else {
                    return false
                }

                return CVDisplayLinkIsRunning(displayLink)
            }

            @discardableResult
            func start(on screen: Screen?) -> Bool {
                guard !isRunning else {
                    return false
                }

                guard createDisplayLink() else {
                    return false
                }

                guard attach(to: screen) else {
                    return false
                }

                guard let displayLink = self.displayLink else {
                    assertionFailure("Display link is nil.")
                    return false
                }

                dispatchSource.resume()
                let result = CVDisplayLinkStart(displayLink)
                assert(result == kCVReturnSuccess, "Display link start failed.")
                return result == kCVReturnSuccess
            }

            func stop() -> Bool {
                guard isRunning, let displayLink = self.displayLink else {
                    return false
                }

                let result = CVDisplayLinkStop(displayLink)
                dispatchSource.cancel()
                self.displayLink = nil
                assert(result == kCVReturnSuccess, "Display link stop failed.")
                return result == kCVReturnSuccess
            }

            private func createDisplayLink() -> Bool {
                guard !isRunning || self.displayLink != nil else {
                    return true
                }

                var result = CVDisplayLinkCreateWithActiveCGDisplays(&self.displayLink)

                guard result == kCVReturnSuccess else {
                    assertionFailure("Failed to create display link for active displays.")
                    return false
                }

                guard let displayLink = self.displayLink else {
                    assertionFailure("Display link nil.")
                    return false
                }

                // CVDisplayLinkOutputCallback
                func callback(_: CVDisplayLink, // The display link requesting the frame.
                              _: UnsafePointer<CVTimeStamp>, // A pointer to the current time.
                              _: UnsafePointer<CVTimeStamp>, // A pointer to the time that the frame will be displayed.
                              _: CVOptionFlags, // Currently unused. Pass 0.
                              _: UnsafeMutablePointer<CVOptionFlags>, // Currently unused. Pass 0.
                              _ displayLinkContext: UnsafeMutableRawPointer?) -> CVReturn
                {
                    guard let context = displayLinkContext else {
                        assertionFailure("Display link context not set.")
                        return kCVReturnError
                    }

                    // get the dispatch source
                    let dispatchSource = Unmanaged<DispatchSourceUserDataAdd>.fromOpaque(context).takeUnretainedValue()

                    // Merge the dispatch source setup for the queue so that rendering occurs on the target queue's thread.
                    // After you call this method, the dispatch source submits its event handler to its target queue to process the data.
                    dispatchSource.add(data: 1)

                    return kCVReturnSuccess
                }

                // setup display link output callback passing dispatch source as user data.
                result = CVDisplayLinkSetOutputCallback(displayLink,
                                                        callback,
                                                        Unmanaged.passUnretained(dispatchSource).toOpaque())

                assert(result == kCVReturnSuccess, "Display link output callback setup failed.")
                return result == kCVReturnSuccess
            }

            private func attach(to screen: Screen?) -> Bool {
                guard let displayLink = self.displayLink else {
                    assertionFailure("Display link nil.")
                    return false
                }

                let displayID: CGDirectDisplayID
                if let screenID = screen?.screenID {
                    displayID = CGDirectDisplayID(screenID)
                } else {
                    displayID = CGMainDisplayID()
                }
                let result = CVDisplayLinkSetCurrentCGDisplay(displayLink, displayID)
                assert(result == kCVReturnSuccess, "Attaching to screen failed.")
                return result == kCVReturnSuccess
            }
        }
    #else

        typealias APPLDisplayLink = APPLDisplayLinkIOS
        final class APPLDisplayLinkIOS {
            private lazy var displayLink = _APPLDisplayLink(target: self, selector: #selector(didRequestFrameOutput))
            init() {}

            var isRunning: Bool {
                !displayLink.isPaused
            }

            @discardableResult
            func start(on runLoop: RunLoop = .current) -> Bool {
                #warning("❗TODO: display link iOS")
                _ = runLoop.currentMode ?? .default
                // displayLink.add(to: runLoop, forMode: mode)
                // displayLink.preferredFramesPerSecond
                //
                // displayLink.isPaused
                fatalError()
            }

            @discardableResult
            func stop() -> Bool {
                fatalError()
            }

            @objc private func didRequestFrameOutput() {}
        }
    #endif

#endif
