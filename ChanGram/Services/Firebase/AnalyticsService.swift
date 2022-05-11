//
//  AnalyticsService.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 11/5/22.
//

import Foundation
import FirebaseAnalytics

class AnalyticService {
    static let instance = AnalyticService()
    
    func pageView(title:String?) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
          AnalyticsParameterItemID: "id-\(title!)",
          AnalyticsParameterItemName: title!,
          AnalyticsParameterContentType: "cont",
        ])
    }
}
