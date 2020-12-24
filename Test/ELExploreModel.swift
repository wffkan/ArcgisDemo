//
//  ELExploreModel.swift
//  LiveEarthArcGis_Example
//
//  Created by benny wang on 2020/12/22.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import ArcGIS

class ELExploreModel: NSObject {
    
    /// id
    var id: Int?
    
    /// 图形ID
    var graphID: String = UUID().uuidString
    
    /// 纬度
    var lon: Double?
    
    /// 经度
    var lat: Double?
    
    /// 海拔
    var alti: Double = 10000
    
    /// 标题
    var title: String?

    /// 缩略图
    var cover_url: String?
    
    /// 获取AGSCamera
    func getCamera(alt: Double = 1500) -> AGSCamera? {
        return AGSCamera(
        latitude: lat ?? 0,
        longitude: lon ?? 0,
        altitude: alt,
        heading: 0,
        pitch: 0,
        roll: 0)
    }
}
