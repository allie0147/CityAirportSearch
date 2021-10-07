//
//  Router.swift
//  CityAirportSearch
//
//  Created by Allie Kim on 2021/10/05.
//

import UIKit

final class Router: NSObject {

    private let navigationController: UINavigationController

    private var closures: [String: NavigationBackClosure] = [:]

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        super.init()
        self.navigationController.delegate = self // UINavigationControllerDelegate
    }
}

extension Router: Routing {
    func push(_ drawable: Drawable,
              isAnimated: Bool,
              onNavigationBack closure: NavigationBackClosure?
    ) {
        guard let viewController = drawable.viewController else { return }

        // capture NavigationBackClosure
        if let closure = closure {
            closures.updateValue(closure, forKey: viewController.description)
        }

        navigationController.pushViewController(viewController, animated: isAnimated)
    }

    func pop(_ isAnimated: Bool) {
        navigationController.popViewController(animated: isAnimated)
    }

    func popToRoot(_ isAnimated: Bool) {
        navigationController.popToRootViewController(animated: isAnimated)
    }

    func present(_ drawable: Drawable,
                 isAnimated: Bool,
                 onDismiss: NavigationBackClosure?
    ) {
        guard let viewController = drawable.viewController else { return }

        if let closure = onDismiss {
            closures.updateValue(closure, forKey: viewController.description)
        }

        navigationController.present(viewController, animated: isAnimated)
        viewController.presentationController?.delegate = self // UIAdaptivePresentationControllerDelegate
    }


    func executeClosure(_ viewController: UIViewController) {
        guard let closure = closures.removeValue(forKey: viewController.description) else {
            return
        }

        closure()
    }
}

// MARK: - Extension: UINavigationControllerDelegate
extension Router: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool
    ) {
        // .from: A key that identifies the view controller that is visible at the beginning of the transition, or at the end of a canceled transition.
        guard let previousController = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }

        guard !navigationController.viewControllers.contains(previousController) else {
            // previousController still in navigation stack
            return
        }

        // pop - remove child coordinator
        executeClosure(previousController)
    }
}

// MARK: - Extension: UIAdaptivePresentationControllerDelegate
extension Router: UIAdaptivePresentationControllerDelegate {

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        // dismiss - remove presentedViewController
        executeClosure(presentationController.presentedViewController)
    }
}
