//
//  BaseLabel.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import UIKit

class BaseLabel: UILabel {
    // MARK: Init
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    //to override
    func initialize() {
        textColor = UIColor.black
        font = UIFont.systemFont(ofSize: 15, weight: .regular)
    }
}

class BoldLabel: UILabel {
    // MARK: Init
    convenience init() {
        self.init(frame: CGRect.zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    //to override
    func initialize() {
        textColor = UIColor.black
        font = UIFont.systemFont(ofSize: 18, weight: .bold)
    }
}
