//
//  Publisher.swift
//  Stuffed
//
//  Created by neutralradiance on 1/30/21.
//

import Foundation
import SwiftUI

public protocol StateObservable: ObservableObject {
  var state: PublisherState { get set }
}

extension StateObservable {
  public func update(
    _ state: PublisherState = .change,
    _ void: @escaping () throws -> Void
  ) {
    DispatchQueue.main.async { [weak self] in
      do {
        try void()
        self?.state = state
      } catch {
        debugPrint(error.localizedDescription)
      }
    }
  }
}
