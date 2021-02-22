//
//  PublisherState.swift
//  Stuffed
//
//  Created by neutralradiance on 1/29/21.
//

import Foundation

public enum PublisherState: String {
  case
    initialize,
    change,
    update,
    load,
    unload,
    reload,
    finalize
}
