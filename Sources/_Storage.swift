//
//  _Storage.swift
// 
//
//  Created by neutralradiance on 10/25/20.
//

//import SwiftUI
//import Unwrap
//
///// A non-failiable wrapper for `UserDefaults`
// Not sure about how useful this is with `AppStorage` 
//@propertyWrapper
//struct Storage<Value>: DefaultsWrapper where Value: Infallible {
//    var store: UserDefaults = .standard
//    let key: String
//    var wrappedValue: Value {
//        get { (store.object(forKey: key) as? Value).unwrap }
//        nonmutating set { store.set(newValue, forKey: key) }
//    }
//    public var projectedValue: Binding<Value> {
//        Binding<Value>(
//            get: { self.wrappedValue },
//            set: { self.wrappedValue = $0 }
//        )
//    }
//
//    init(wrappedValue: Value, _ key: String, store: UserDefaults? = nil) {
//        self.key = key
//        if let store = store { self.store = store }
//        if self.store.object(forKey: key) == nil {
//            self.wrappedValue = wrappedValue
//        }
//    }
//}
