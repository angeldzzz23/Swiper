//
//  Bindable.swift
//  TinderClone
//
//  Created by Angel Zambrano on 12/23/21.
//

import Foundation

//
class Bindable<T> {
   //
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?)->())?
    
    // make sure the obsever is called 
    func bind(observer: @escaping (T?) ->()) {
        self.observer = observer
    }
}
