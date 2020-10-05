//
//  ConfirmButton.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import UIKit

final class ConfirmButton: BaseButton {
    override func initialize() {
        super.initialize()
        backgroundColor = UIColor.black
        contentEdgeInsets = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        layer.cornerRadius = 4
    }
}
