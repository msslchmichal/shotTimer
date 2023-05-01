//
//  AppConfig.swift
//  shotTimerSwiftUI
//
//  Created by Michał Massloch on 01/05/2023.
//

import Foundation
import RealmSwift

struct AppConfig {
    var appId: String
    var baseUrl: String
}

func loadAppConfig() -> AppConfig {
    guard let path = Bundle.main.path(forResource: "atlasConfig", ofType: "plist") else {
        fatalError("Unable to read atlasCOnfig.plist file!")
    }
    let data = NSData(contentsOfFile: path)! as Data
    let atlasConfigPropertyList = try! PropertyListSerialization.propertyList(from: data, format: nil) as! [String: Any]
    let appId = atlasConfigPropertyList["appId"]! as! String
    let baseUrl = atlasConfigPropertyList["baseUrl"]! as! String
    return AppConfig(appId: appId, baseUrl: baseUrl)
    
}
