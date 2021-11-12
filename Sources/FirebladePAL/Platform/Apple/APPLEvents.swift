//
// APPLEvents.swift
// Fireblade PAL
//
// Copyright © 2018-2021 Fireblade Team. All rights reserved.
// Licensed under MIT License. See LICENSE file for details.

#if FRB_PLATFORM_APPL

    struct APPLEvents: PlatformEvents {
        func pushEvent(_: Event) {
            #warning("❗TODO: implement")
        }

        func pumpEvents() {
            #warning("❗TODO: implement")
        }

        func pollEvent(_: inout Event) -> Bool {
            #warning("❗TODO: implement")
            return false
        }
    }

#endif
