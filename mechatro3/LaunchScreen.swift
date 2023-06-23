//
//  LaunchScreen.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/06/19.
//

import SwiftUI


struct LaunchScreen: View {
    @Binding var page: Pagetype
    @Binding var home: Bool
    @Binding var launch: Bool

    var body: some View {
        ZStack {
                Image("home_back")
                .resizable()
                .frame(width:300,height: 100)
                    .mask(
                        Text("TATA")
                            .font(.system(size: 100, weight: .black))
                    )
                ProgressAnimation()
                .offset(y:80)
        }
        .onAppear {//↓ページ変わるまでの時間
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    launch = false
                }
            }
        }
        .onDisappear{
            page = .home
            home = true
        }
    }
}

// https://cindori.com/developer/swiftui-animation-loading
// Progress animation
struct ProgressAnimation: View {
    @State private var drawingWidth = false
 
    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(red: 1, green: 0.2, blue: 0.2, opacity: 0.3))
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(red: 0.8, green: 0.2, blue: 0.4, opacity: 0.4))
                    .frame(width: drawingWidth ? 250 : 0, alignment: .leading)
                    .animation(.easeInOut(duration: 2.3).repeatForever(autoreverses: false), value: drawingWidth)//duration: animationの時間
            }
            .frame(width: 250, height: 12)
            .onAppear {
                drawingWidth.toggle()
            }
        }
    }
}

//struct LaunchScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        LaunchScreen()
//    }
//}
