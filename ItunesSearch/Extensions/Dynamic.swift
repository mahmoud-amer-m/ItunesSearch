//
//  Dynamic.swift
//  MVVMDemo
//
//  Created by Mohamed Matloub on 3/6/18.
//  Copyright © 2018 mohamed matloub. All rights reserved.
//

class Dynamic<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?

    func bind(listener: Listener?) {
        self.listener = listener
    }

    func unbind() {
        self.listener = nil
    }

    func bindAndFire(listener: Listener?) {
        self.listener = listener
        listener?(value)
    }

    var value: T {
        didSet {
            listener?(value)
        }
    }

    init(_ v: T) {
        value = v
    }
}
