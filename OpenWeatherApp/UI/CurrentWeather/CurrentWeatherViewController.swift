//
//  CurrentWeatherViewController.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import UIKit
import RxSwift
import RxCocoa

final class CurrentWeatherViewController: BaseViewController<CurrentWeatherViewModelProtocol>, CurrentWeatherViewControllerProtocol {    
    
    private weak var currentWeatherView: CurrentWeatherView!
    private weak var searchController: UISearchController!
    
    override func loadView() {
        let currentWeatherView: CurrentWeatherView = CurrentWeatherView(controllerProtocol: self)
        view = currentWeatherView
        self.currentWeatherView = currentWeatherView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        initializeView()
        initializeActions()
        initializeSearchBar()
    }
    
    private func initializeView() {
        prepareNavigationBar(withTitle: "bar_title".localized)
    }
    
    private func initializeActions() {
        bindActions(toViewModel: viewModel)
        bindActionToRefreshButtonClicked()
    }
    
    private func bindActionToRefreshButtonClicked() {
        (errorView as? ErrorView)?.refreshButtonClicked.asDriver().drive(onNext: { [weak self] in
            self?.viewModel.weather(forPlace: "")
        }).disposed(by: disposeBag)
    }
    
    private func initializeSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.placeholder = "search_bar_placeholder".localized
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        self.searchController = searchController

        bindSearchController()
    }
    
    private func bindSearchController() {
        Driver<Void>.merge([
//            searchController.searchBar.rx.searchButtonClicked.asDriver(),
            searchController.searchBar.rx.text.asDriver(onErrorJustReturn: nil).map({ _ in () })
        ])
        .debounce(.milliseconds(500))
        .drive(onNext: { [weak self] _ in
            guard let self = self, let text = self.searchController.searchBar.text else {
                return
            }
            self.viewModel.weather(forPlace: text)
        }).disposed(by: disposeBag)
        
        searchController.searchBar.rx.cancelButtonClicked.asDriver().drive(onNext: { [weak self] in
            guard let self = self else {
                return
            }
            self.viewModel.weather(forPlace: "")
        }).disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !viewModel.isApiKeyValid {
            showError(message: "error_api_key".localized)
        }
    }

}
