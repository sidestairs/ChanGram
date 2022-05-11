//
//  LazyView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 11/5/22.
//

import Foundation
import SwiftUI

struct LazyView<Content:View>:View {
    var content: () -> Content
    
    var body: some View {
        self.content()
    }
}
