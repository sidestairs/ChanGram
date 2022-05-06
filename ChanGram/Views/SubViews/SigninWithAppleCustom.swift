//
//  SigninWithAppleCustom.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import Foundation
import SwiftUI
import AuthenticationServices


struct SigninWithAppleCustom: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        return ASAuthorizationAppleIDButton(authorizationButtonType: .default, authorizationButtonStyle: .black)
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}
