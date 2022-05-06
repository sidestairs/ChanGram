//
//  CarouselView.swift
//  ChanGram
//
//  Created by Chan Wai Hsuen on 6/5/22.
//

import SwiftUI

struct CarouselView: View {
    
    @State var selection:Int = 0
    let maxCount: Int = 7
    @State var timerAdded:Bool = false
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(0..<maxCount, id:\.self) { count in
                Image("dog\(count+1)")
                    .resizable()
                    .scaledToFill()
                    .tag(count)
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 300)
        .animation(.default, value: selection)
        .onAppear {
            if (!timerAdded) {
                addTimer()
            }
        }
    }
    
    // MARK: FUNCTION
    
    func addTimer() {
        timerAdded = true
        
        let timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
            if (selection == maxCount-1 ) {
                selection = 0
            } else {
                selection = selection + 1
            }
        }
        timer.fire()
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CarouselView()
            .previewLayout(.sizeThatFits)
    }
}
