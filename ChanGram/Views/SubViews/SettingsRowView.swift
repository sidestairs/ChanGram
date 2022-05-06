//
//  SettingsRowView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct SettingsRowView: View {
    var leftIcon:String
    var text:String
    var color: Color
    
    
    
    var body: some View {
        HStack{
            
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(color)
                Image(systemName: leftIcon)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .frame(width: 36, height: 36, alignment: .center)
           
            Text(text)
            
            Spacer()
            Image(systemName: "chevron.right")
                .font(.headline)
        }
        .padding(.vertical, 4)
    }
}

struct SettingsRowVie3w_Previews: PreviewProvider {
    static var previews: some View {
        SettingsRowView(leftIcon: "heart.fill", text: "TEST", color: Color.red)
            .previewLayout(.sizeThatFits)
    }
}
