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

public extension StateObservable {
  func update(
    _ state: PublisherState = .change,
    deadline: DispatchTime = .now(),
    _ perform: @escaping () throws -> Void
  ) {
    DispatchQueue.main
      .asyncAfter(deadline: deadline) { [weak self] in
        do {
          try perform()
          self?.state = state
        } catch {
          debugPrint(error.localizedDescription)
        }
      }
  }
}
