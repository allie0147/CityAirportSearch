//
//  BaseCoordinator.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/09/18.
//

class BaseCoordinator: Coordinator {

    var childCoordinator: [Coordinator] = []

    /// After popViewController `NavigationBackClosure` will be handled using this variable
    /// presentedViewController deallocated
    var isCompleted: (() -> ())?

    /**
        1. Instantiate and show ViewController
        2. Build ViewModel
     */
    func start() {
        fatalError("Child coordinator should implement 'start' function.")
    }
}
