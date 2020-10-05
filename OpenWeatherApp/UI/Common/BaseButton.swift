//
//  BaseButton.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import UIKit

class BaseButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            runHighlightedAnimation()
        }
    }

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

    }

    private func runHighlightedAnimation() {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let self = self else {
                return
            }
            self.alpha = self.isHighlighted ? 0.5 : 1.0
        })
    }
}
