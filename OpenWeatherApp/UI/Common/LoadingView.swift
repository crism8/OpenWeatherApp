//
//  LoadingView.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import UIKit

final class LoadingView: BaseStateView {
    private weak var viewContainer: UIView!
    private weak var activityIndicatorView: UIActivityIndicatorView!
    private weak var titleLabel: BaseLabel!
    
    override func createView() {
        createContainerView()
        createActivityIndicatorView()
        createTitleLabel()
    }

    private func createContainerView() {
        let viewContainer = UIView()
        addSubview(viewContainer)
        viewContainer.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
            make.centerX.equalToSuperview().priority(999)
            make.centerY.equalToSuperview().priority(999)
        }
    
        self.viewContainer = viewContainer
    }

    private func createActivityIndicatorView() {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicatorView.color = UIColor.gray
        addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        self.activityIndicatorView = activityIndicatorView
    }

    private func createTitleLabel() {
        let titleLabel = BaseLabel()
        titleLabel.textAlignment = .center
        titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        titleLabel.text = "loading_title".localized
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        self.titleLabel = titleLabel
    }
    
    override func startActive() {
        super.startActive()
        activityIndicatorView.startAnimating()
    }
    
    override func stopActive() {
        super.stopActive()
        activityIndicatorView.stopAnimating()
    }
}
