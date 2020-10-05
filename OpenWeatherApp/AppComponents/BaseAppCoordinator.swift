//
//  BaseAppCoordinator.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import UIKit

open class BaseAppCoordinator: NSObject, AppCoordinatorProtocol {

    private let serviceLocator: ServiceLocator
    private let scenesViewControllerBuilder: ScenesViewControllerBuilder
    public private(set) var window: UIWindow?
    
    public var isUserInteractionEnabled: Bool {
        get {
            return window?.isUserInteractionEnabled ?? false
        }
        set {
            window?.isUserInteractionEnabled = newValue
        }
    }
    
    public override init() {
        serviceLocator = ServiceLocator()
        scenesViewControllerBuilder = ScenesViewControllerBuilder()
        super.init()
        registerServices(locator: serviceLocator)
        registerViewControllers(builder: scenesViewControllerBuilder)
    }
    
    func registerServices(locator: ServiceLocator) {
        locator.register(withBuilder: OpenWeatherClientServiceBuilder())
    }
    
    open func registerViewControllers(builder: ScenesViewControllerBuilder) {
        fatalError("registerViewControllers - should be overriden")
    }
    
    public func initializeScene() {
        window = UIWindow()
        window?.makeKeyAndVisible()
        setWindowRootViewController()
    }
    
    open func setWindowRootViewController() {
        fatalError("setWindowRootViewController - should be overriden")
    }
    
    public func createMainSceneViewController() -> UIViewController {
        return CurrentWeatherSceneBuilder().createScene(withAppCoordinator: self)
    }

}

// MARK: - AppCoordinatorResouresProtocol
extension BaseAppCoordinator: AppCoordinatorResouresProtocol {
    func getService<ReturnType>(type: ServiceTypes) -> ReturnType? {
        return serviceLocator.get(type: type)
    }
    
    func getSceneViewController(forViewModel viewModel: ViewModelProtocol, type: SceneTypes) -> ViewControllerProtocol? {
        return scenesViewControllerBuilder.get(forViewModel: viewModel, type: type)
    }
}
