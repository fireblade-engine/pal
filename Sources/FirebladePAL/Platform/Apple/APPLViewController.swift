//
// APPLViewController.swift
// Fireblade Engine
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under GNU General Public License v3.0. See LICENSE file for details.

#if FRB_PLATFORM_APPL

#if FRB_PLATFORM_APPL_MACOS && !targetEnvironment(macCatalyst)
import AppKit
#elseif FRB_PLATFORM_APPL_IOS || targetEnvironment(macCatalyst)
import UIKit
#endif

import Math

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
