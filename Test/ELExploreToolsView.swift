//
//  ELExploreToolsView.swift
//  LiveEarthArcGis_Example
//
//  Created by benny wang on 2020/12/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class ELExploreToolsView: UIView {
    
    lazy var zoomInBtn: UIButton = setupZoomInBtn()
    
    lazy var zoomOutBtn: UIButton = setupZoomOutBtn()
    
    lazy var resetBtn: UIButton = setupResetBtn()

    lazy var flytoBtn: UIButton = setupFlytoBtn()

    lazy var stackView: UIStackView = setupStackView()
    
    lazy var locationBtn: UIButton = setupLocationBtn()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 初始化
extension ELExploreToolsView {
    
    func setupStackView() -> UIStackView {
        
        let stackView = UIStackView(arrangedSubviews: [flytoBtn, locationBtn, resetBtn, zoomInBtn, zoomOutBtn])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        return stackView
    }
    
    func setupZoomInBtn() -> UIButton {
        let zoomInBtn = UIButton(type: .custom)
        zoomInBtn.setImage(UIImage(named: "explore_zoomin"), for: .normal)
        return zoomInBtn
    }
    
    func setupZoomOutBtn() -> UIButton {
        let zoomOutBtn = UIButton(type: .custom)
        zoomOutBtn.setImage(UIImage(named: "explore_zoomout"), for: .normal)
        return zoomOutBtn
    }
    
    func setupResetBtn() -> UIButton {
        let resetBtn = UIButton(type: .custom)
        resetBtn.setImage(UIImage(named: "earth_reset_icon"), for: .normal)
        return resetBtn
    }
    
    func setupLocationBtn() -> UIButton {
        let locationBtn = UIButton(type: .custom)
        locationBtn.setImage(UIImage(named: "explore_locate_icon"), for: .normal)
        return locationBtn
    }
    
    func setupFlytoBtn() -> UIButton {
        let flytoBtn = UIButton(type: .custom)
        flytoBtn.setImage(UIImage(named: "explore_side_flyto"), for: .normal)
        return flytoBtn
    }
}

