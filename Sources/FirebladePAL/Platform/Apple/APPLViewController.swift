//
// APPLViewController.swift
// Fireblade PAL
//
// Copyright © 2018-2023 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_APPL

    #if canImport(AppKit)
        import AppKit
    #endif

    #if canImport(UIKit)
        import UIKit
    #endif

    import FirebladeMath

    class APPLViewController: _APPLViewController {
        let _view: APPLView

        init(view: APPLView) {
            _view = view
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder _: NSCoder) { nil }

        override func loadView() {
            view = _view
        }

        override func viewDidLoad() {
            super.viewDidLoad()
        }
    }

    #if FRB_PLATFORM_APPL_IOS || targetEnvironment(macCatalyst)
        extension APPLViewController {
            override func viewDidLayoutSubviews() {
                super.viewDidLayoutSubviews()
                Events.sendWindowEvent(windowID: 0, event: .resized(Size(size: view.frame.size)))
            }
        }
    #endif

#endif
