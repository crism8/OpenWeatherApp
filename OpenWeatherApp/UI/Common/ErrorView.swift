//
//  ErrorView.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import Foundation
import RxSwift
import RxCocoa

final class ErrorView: BaseStateView {
    private weak var viewContainer: UIView!
    private weak var refreshButton: UIButton!
    private weak var titleLabel: BaseLabel!

    var refreshButtonClicked: ControlEvent<()> {
        return refreshButton.rx.controlEvent(.touchUpInside)
    }

    override func createView() {
        createViewContainer()
        createTitleLabel()
        createRefreshButton()
    }

    private func createViewContainer() {
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

    private func createTitleLabel() {
        let titleLabel = BaseLabel()
        titleLabel.textAlignment = .center
        titleLabel.text = "error_title".localized
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        self.titleLabel = titleLabel
    }

    private func createRefreshButton() {
        let refreshButton = ConfirmButton()
        refreshButton.setTitle("error_refresh_button_title".localized, for: .normal)
        addSubview(refreshButton)
        refreshButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(2)
            make.left.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        self.refreshButton = refreshButton
    }

}
