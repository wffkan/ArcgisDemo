//
//  ViewController.swift
//  LiveEarthArcGis
//
//  Created by 409322456@qq.com on 12/20/2020.
//  Copyright (c) 2020 409322456@qq.com. All rights reserved.
//

import UIKit
import LiveEarthArcGis
import ArcGIS

class BaseEarthViewController: UIViewController {

    lazy var sceneViewController: ELSceneViewController = ELSceneViewController.shared

    lazy var sceneContainerView: UIView = UIView()
    
    lazy var adjustBtn: UIButton = UIButton()

    lazy var toolsView: ELExploreToolsView = {
        let view = ELExploreToolsView()
        view.zoomInBtn.addTarget(self, action: #selector(zoomInBtnClick), for: .touchUpInside)
        view.zoomOutBtn.addTarget(self, action: #selector(zoomOutBtnClick), for: .touchUpInside)
        view.flytoBtn.addTarget(self, action: #selector(flytoBtnClick), for: .touchUpInside)
        view.locationBtn.addTarget(self, action: #selector(locationBtnClick), for: .touchUpInside)
        view.resetBtn.addTarget(self, action: #selector(resetBtnClick), for: .touchUpInside)
        return view
    }()
    
    /// 数据源
    var dataSource: [ELExploreModel] = [] {
        didSet {
            self.didSetDataSource()
        }
    }
    
    // 由dataSource映射
    var graphicsSource: [ELGraphicModel] = [] {
        didSet {
            sceneViewController.graphicsManager.dataSource = graphicsSource
        }
    }
    
    // 地图选中marker model
    var activeExploreModel: ELExploreModel? = nil {

        didSet {
            self.didSetActiveExploreModel()
        }
    }
    
    // 地图选中marker index
    var activeIndex: Int? {
        return dataSource.firstIndex(where: { (exploreModel) -> Bool in
            if activeExploreModel != nil {
                return exploreModel.graphID == activeExploreModel!.graphID
            }
            return false
        })
    }
    
    private var sceneView: AGSSceneView {
        return sceneViewController.sceneView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black
        setupSubViews()
        
        sceneViewController.resetScene(true)
        sceneViewController.graphicsManager.renderType = .closure
        dataSource = []
        sceneViewController.graphicsManager.render()
        self.sceneViewController.cameraManager.setInitCamera(duration: 0, completion: {[weak self] in
            //构建点位数据，这些数据一般是来自服务器数据
            self?.requestData()
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneViewController.willSceneMove(to: sceneContainerView, parent: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        sceneViewController.didSceneMove(to: sceneContainerView, parent: self)
        sceneViewController.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneViewController.willSceneLeave(from: self)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    private func setupSubViews() {
        view.addSubview(sceneContainerView)
        view.addSubview(adjustBtn)
        view.addSubview(toolsView)
        sceneContainerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        toolsView.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.width.equalTo(40)
            make.height.equalTo(200)
            make.bottom.equalTo(-100)
        }
    }
 
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - ELSceneViewDelegate
extension BaseEarthViewController: ELSceneViewDelegate {
    func el_viewpointChangedHandler() {
//        guard let currentCamera = sceneViewController.cameraManager.currentCamera else { return }
//        DispatchQueue.main.async {[weak self] in
//            let heading : CGFloat = CGFloat(currentCamera.heading)
//            self?.adjustButton.transform = CGAffineTransform(rotationAngle: -(heading * .pi / 180))
//        }
    }
    
    func el_cameraChangedEnd() {
        
    }
    
    ///点击了某个点位，会flyto到默认海拔高度
    func el_didTapAtScreenPoint(tap graphics: [AGSGraphic]) {
        guard let markerID = graphics.first?.attributes["id"] as? String else {
            return }
        print("点击了id=\(markerID)的marker")
        let index = dataSource.firstIndex { (exploreModel) -> Bool in
            return exploreModel.graphID == markerID
        }
        self.activeExploreModel = self.dataSource[index!]
    }
    
    func el_panGesture(gesture: UIPanGestureRecognizer) {
        
    }
    
    func el_singleTapGesture(gesture: UITapGestureRecognizer) {
        
    }
    
    func el_doubleTapGesture(gesture: UITapGestureRecognizer) {
        
    }
    
    func el_pinchGesture(gesture: UIPinchGestureRecognizer) {
        
    }
}

extension BaseEarthViewController {
    
    private func requestData() {
        //模拟一些点位数据
        let loc1 = ELExploreModel()
        loc1.id = 2315
        loc1.title = "迪尔菲尔德海滩看海"
        loc1.lon = -80.075093
        loc1.lat = 26.315993
        loc1.cover_url = "https://cdn.image.earthonline.com/file/admin/2a97924809b8ed8e48728af123020fed.png"
        
        let loc2 = ELExploreModel()
        loc2.id = 2316
        loc2.title = "二仁溪崇德桥两岸风光"
        loc2.lon = 120.269043
        loc2.lat = 22.9006109
        loc2.cover_url = "https://cdn.image.earthonline.com/live_source/e4da3b7fbbce2345d7772b0674a318d5.png"
        self.dataSource = [loc1,loc2]
        self.sceneViewController.graphicsManager.render()
    }
    
    private func didSetDataSource() {
        self.graphicsSource = dataSource.map({ (model) -> ELGraphicModel in
            return ELGraphicModel(
                identity: model.graphID,
                size: ELExploreImageGraphicView.itemSize,
                offsetY: (ELExploreImageGraphicView.itemSize.height / 2) - 2.5,
                longitude: model.lon ?? 0,
                latitude: model.lat ?? 0,
                view: ELExploreImageGraphicView.self,
                data: model)
        })
    }
    
    func didSetActiveExploreModel() {
        // 隐藏除了选中之外的marker
//        sceneViewController.graphicsManager.isActiveOtherHidden = (activeExploreModel != nil)
        // 选中的marker
        sceneViewController.graphicsManager.activeIdentity = activeExploreModel?.graphID
        sceneViewController.graphicsManager.render(force: true)
        sceneViewController.graphicsManager.removeRegion()
        // flyto
        if let camera = activeExploreModel?.getCamera(alt: 1500) {
            
            sceneViewController.cameraManager.setCamera(
                with:AGSCamera(
                    latitude: camera.location.y,
                    longitude: camera.location.x,
                    altitude: ELSceneConfiguration.initialCamera.location.z,
                    heading: 0,
                    pitch: 0,
                    roll:
                    0),
                duration: 0.5)
            self.sceneViewController.cameraManager.flyTo(at: camera)
        }
    }
        
    ///fly to
    @objc func flytoBtnClick() {
        if self.activeExploreModel != nil ,let camera = self.activeExploreModel?.getCamera() {
            self.sceneViewController.cameraManager.flyTo(at: camera)
        }
    }
    
    ///地球缩小
    @objc func zoomInBtnClick() {
        self.sceneViewController.cameraManager.zoomIn {[weak self] in
            self?.sceneViewController.graphicsManager.render()
        }
    }
    
    ///地球放大
    @objc func zoomOutBtnClick() {
        self.sceneViewController.cameraManager.zoomOut {[weak self] in
            self?.sceneViewController.graphicsManager.render()
        }
    }
    
    ///地球重置
    @objc func resetBtnClick() {
        self.sceneViewController.cameraManager.resetCameraAlti(duration: 0.5) {[weak self] in
            self?.sceneViewController.graphicsManager.render()
        }
    }
    
    ///当前定位
    @objc func locationBtnClick() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus == .denied {
            print("请开启定位权限")
            return
        }
        let createView = ELExploreLocationGraphicView()
        createView.frame = CGRect(x: 0, y: 0, width: 26, height: 32)
        createView.layoutIfNeeded()
        createView.avatar.image = UIImage(named: "user_avatar")
        let symbol = AGSPictureMarkerSymbol(image: createView.asImage())
        symbol.width = 26
        symbol.height = 32
        symbol.offsetY = 16
        self.sceneViewController.graphicsManager.locationGraphic.symbol = symbol
        self.sceneViewController.locationManager.updateLocation(isLocation: !self.sceneViewController.graphicsManager.isLocationDisplay)
    }
}
