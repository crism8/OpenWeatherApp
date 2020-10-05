//
//  CurrentWeatherView.swift
//  OpenWeatherApp
//
//  Created by Cristian Makarski on 05/10/2020.
//

import UIKit
import RxCocoa
import RxSwift
import Kingfisher

protocol CurrentWeatherViewControllerProtocol: ViewControllerProtocol {
    var viewModel: CurrentWeatherViewModelProtocol { get }
}

final class CurrentWeatherView: UIView {
    
    private weak var controllerProtocol: CurrentWeatherViewControllerProtocol?
    private let disposeBag: DisposeBag = DisposeBag()
    private weak var locationLabel: BoldLabel!
    private weak var temperatureLabel: BoldLabel!
    private weak var pressureLabel: BoldLabel!
    private weak var imageView: UIImageView!
    
    // MARK: Initialization
    init(controllerProtocol: CurrentWeatherViewControllerProtocol) {
        self.controllerProtocol = controllerProtocol
        super.init(frame: CGRect.zero)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initialize() {
        prepareLocationLabel()
        prepareImageView()
        prepareTempLabel()
        preparePressureLabel()
        bindViewModel()
    }
    
    private func prepareLocationLabel() {
        let label = BoldLabel()
        label.textAlignment = .center
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(4).priority(999)
            make.left.equalToSuperview().priority(999)
            make.right.equalToSuperview().priority(999)
            
        }
        self.locationLabel = label
    }
    
    private func prepareImageView() {
        let iView = UIImageView()
        iView.clipsToBounds = true
        iView.contentMode = .scaleAspectFit
        addSubview(iView)
        iView.snp.makeConstraints { (make) in
            make.top.equalTo(self.locationLabel.snp.bottom).offset(4).priority(999)
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.centerX.equalToSuperview().priority(999)

        }
        self.imageView = iView
    }
    
    private func prepareTempLabel() {
        let label = BoldLabel()
        label.textAlignment = .center
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self.imageView.snp.bottom).offset(4).priority(999)
            make.left.equalToSuperview().priority(999)
            make.right.equalToSuperview().priority(999)
        }
        self.temperatureLabel = label
    }
    
    private func preparePressureLabel() {
        let label = BoldLabel()
        label.textAlignment = .center
        addSubview(label)
        label.snp.makeConstraints { (make) in
            make.top.equalTo(self.temperatureLabel.snp.bottom).offset(4).priority(999)
            make.left.equalToSuperview().priority(999)
            make.right.equalToSuperview().priority(999)
            make.bottom.lessThanOrEqualToSuperview().priority(999)
        }
        self.pressureLabel = label
    }
    
    private func bindViewModel() {
        controllerProtocol?.viewModel.currentWeatherDriver.drive { [weak self] model in
            guard let self = self else {
                return
            }
            guard model.name.count > 0 else {
                self.clear()
                return
            }
            self.locationLabel.text = model.name
            self.temperatureLabel.text = String(format: "%d°C", Int(model.main.temperature))
            self.pressureLabel.text = String(format: "%dhPa", Int(model.main.pressure))
            self.refreshImage(withIcon: model.weather.first?.icon)

        }
        .disposed(by: disposeBag)
    }
    
    private func clear() {
        self.locationLabel.text = ""
        self.temperatureLabel.text = ""
        self.pressureLabel.text = ""
        refreshImage(withIcon: nil)
    }
    
    private func refreshImage(withIcon icon: String?) {
        guard let icon = icon, let iconURL = URL(string: String(format: "http://openweathermap.org/img/wn/%@@2x.png", icon)) else {
            self.imageView.image = nil
            self.imageView.kf.cancelDownloadTask()
            return
        }
        self.imageView.kf.setImage(with: iconURL, options: [
            .transition(ImageTransition.fade(0.5))
        ])
    }
    
}
