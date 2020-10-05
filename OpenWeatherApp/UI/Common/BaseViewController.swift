//
//  BaseViewController.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import UIKit
import RxSwift
import SnapKit

class BaseViewController<ViewModelType>: UIViewController, ViewControllerProtocol {

    let viewModel: ViewModelType
    let disposeBag: DisposeBag = DisposeBag()
    
    var viewModelInstance: Any {
        return viewModel
    }
    
    lazy var loadingView: BaseStateView = {
        return initializeLoadingView()
    }()
    
    lazy var emptyView: BaseStateView = {
        return initializeEmptyView()
    }()
    
    lazy var errorView: BaseStateView = {
        return initializeErrorView()
    }()
    
    required init(viewModel: ViewModelProtocol) {
        guard let viewModel = viewModel as? ViewModelType else {
            fatalError("cast failed \(ViewModelType.self)")
        }
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        resizeBarTitleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { [weak self] in
            self?.resizeBarTitleView()
        }
    }
    
    private func resizeBarTitleView() {
        (navigationItem.titleView)?.sizeToFit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
    }
    
    func prepareNavigationBar(withTitle title: String) {
        if navigationController?.viewControllers.count ?? 0 > 1 {
            addBarBackButton()
        }
        if !title.isEmpty {
            createBarTitleView(withTitle: title)
        }
    }
    
    private func addBarBackButton() {
        navigationItem.setLeftBarButton(UIBarButtonItem(image: UIImage(named: "backArrow")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(barBackButtonClicked)), animated: false)
    }
    
    @objc func barBackButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    private func createBarTitleView(withTitle title: String) {
        let barTitleLabel = createBarTitleLabel(withTitle: title)
        navigationItem.titleView = barTitleLabel
        resizeBarTitleView()
    }
    
    private func createBarTitleLabel(withTitle title: String) -> UILabel {
        let barTitleLabel = BaseLabel()
        barTitleLabel.textAlignment = .center
        barTitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        barTitleLabel.numberOfLines = 2
        barTitleLabel.minimumScaleFactor = 0.5
        barTitleLabel.adjustsFontSizeToFitWidth = true
        barTitleLabel.lineBreakMode = .byWordWrapping
        barTitleLabel.text = title
        return barTitleLabel
    }
    
    func initializeLoadingView() -> BaseStateView {
        let loadingView = LoadingView()
        view.addSubview(loadingView)
        loadingView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return loadingView
    }
    
    func initializeEmptyView() -> BaseStateView {
        let emptyView = EmptyView()
        view.addSubview(emptyView)
        emptyView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return emptyView
    }
    
    func initializeErrorView() -> BaseStateView {
        let errorView = ErrorView()
        view.addSubview(errorView)
        errorView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        return errorView
    }
    
    func bindActions(toViewModel viewModel: ViewModelProtocol) {
        bindDataActionStateDrivers(toViewModel: viewModel)
        bindRaiseErrorDriver(toViewModel: viewModel)
    }
    
    private func bindDataActionStateDrivers(toViewModel viewModel: ViewModelProtocol) {
        viewModel.dataActionStateDriver.map({ $0 == .loading }).drive(loadingView.isActiveRelay).disposed(by: disposeBag)
        viewModel.dataActionStateDriver.map({ $0 == .empty }).drive(emptyView.isActiveRelay).disposed(by: disposeBag)
        viewModel.dataActionStateDriver.map({ $0 == .error }).drive(errorView.isActiveRelay).disposed(by: disposeBag)
    }
    
    private func bindRaiseErrorDriver(toViewModel viewModel: ViewModelProtocol) {
        viewModel.raiseErrorDriver.drive(onNext: { [weak self] error in
            guard let self = self else {
                return
            }
            self.showError(message: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
}
