//
//  Routing.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/10/05.
//

import Foundation

typealias NavigationBackClosure = (() -> ())

protocol Routing {
    /// push a ViewController which implements Drawable
    func push(_ drawable: Drawable, isAnimated: Bool, onNavigationBack: NavigationBackClosure?)
    
    /// pop a ViewController
    func pop(_ isAnimated: Bool)
}
