//
//  Coordinator.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import UIKit

protocol CoordinatorDelegate {
    func pushViewController(viewController: UIViewController?)
    func popViewController()
    func popToRootViewController()
}

class Coordinator: CoordinatorDelegate {
    private let window: UIWindow
    private var navigationController: UINavigationController?
    private var oauthManager: OauthManager?
    
    init(withWindow window: UIWindow) {
        self.window = window
    }
    
    func start() {
        navigationController = UINavigationController(rootViewController: getPetsViewController())
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        
        loadOauth()
    }
    
    func pushViewController(viewController: UIViewController?) {
        guard let viewController = viewController else {
            return
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension Coordinator: PetsViewControllerDelegate {
    private func getPetsViewController() -> PetsViewController {
        let viewController = PetsViewController()
        viewController.petsViewControllerDelegate = self
        
        return viewController
    }
    
    func openSettings(settingsViewModel: SettingsViewModel?) {
        let viewController = getSettingsViewController(withSettingsViewModel: settingsViewModel)
        pushViewController(viewController: viewController)
    }
    
    func didSelectPet(pet: Pet) {
        
    }
}

extension Coordinator: SettingsViewControllerDelegate {
    private func getSettingsViewController(withSettingsViewModel settingsViewModel: SettingsViewModel?) -> SettingsViewController {        
        let viewController = SettingsViewController(withSettingsViewModel: settingsViewModel)
        viewController.settingsViewControllerDelegate = self
        
        return viewController
    }
    
    func save(settingsViewModel: SettingsViewModel?) {        
        popViewController()
        
        let viewController = navigationController?.viewControllers.first as? PetsViewController
        viewController?.reloadData(withSettingsViewModel: settingsViewModel)
    }
}

extension Coordinator: OauthManagerDelegate {
    private func loadOauth() {
        oauthManager = OauthManager()
        oauthManager?.oauthManagerDelegate = self
        oauthManager?.loadOauth()
    }
    
    func oauthDidFetch(error: Error) {
        let viewController = navigationController?.viewControllers.last
        viewController?.showAlertController(error: error)
    }
    
    func oauthDidFetch(oauth: Oauth) {
        let viewController = navigationController?.viewControllers.first as? PetsViewController
        viewController?.setupViewModel(withOauth: oauth)
    }
}
