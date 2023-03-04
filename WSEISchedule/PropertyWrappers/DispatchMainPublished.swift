//
//  DispatchMainPublished.swift
//  WSEISchedule
//
//  Created by Maksymilian Galas on 04/03/2023.
//  Copyright © 2023 Infinity Pi Ltd. All rights reserved.
//

import Foundation
import Combine

@propertyWrapper
struct DispatchMainPublished<Value> {
    static subscript<T: ObservableObject>(
        _enclosingInstance instance: T,
        wrapped wrappedKeyPath: ReferenceWritableKeyPath<T, Value>,
        storage storageKeyPath: ReferenceWritableKeyPath<T, Self>
    ) -> Value {
        get {
            instance[keyPath: storageKeyPath].storage
        }
        set {
            instance[keyPath: storageKeyPath].storage = newValue

            let publisher = instance.objectWillChange as? ObservableObjectPublisher
            DispatchQueue.main.async {
                publisher?.send()
            }
        }
    }

    @available(*, unavailable, message: "@Published can only be applied to classes" )
    var wrappedValue: Value {
        get { fatalError() }
        set { fatalError() }
    }

    private var storage: Value

    init(wrappedValue: Value) {
        storage = wrappedValue
    }
}
