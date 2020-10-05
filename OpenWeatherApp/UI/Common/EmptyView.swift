//
//  EmptyView.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import Foundation
import SnapKit
final class EmptyView: BaseStateView {

    override func createView() {
        let emptyLabel = BaseLabel()
        emptyLabel.textAlignment = .center
        emptyLabel.text = "empty_title".localized
        addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(12)
        }
    }

}
