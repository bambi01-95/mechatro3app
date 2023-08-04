//
//  PremiumVR.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/07/07.
//

import SwiftUI

struct PremiumVR: View {
    @Binding var page:Pagetype
    @Binding var home:Bool
    @ObservedObject var SendInputValue: sendMessage //edit
    
    var body: some View {
        let bounds = UIScreen.main.bounds
        let Sheight = bounds.height
        let Swidth = bounds.width
        
        ZStack{
// test code (web view image size)
            Rectangle()
                .fill(Color.blue)
                .frame(width: 801, height:401)
            
            /* https://swifty-ui.com/wkwebview/ */
            WebView(loardUrl: URL(string: "http://" + SendInputValue.hoststr + ":8000/vr/")!)
                .frame(width: 800, height: 400)
            VStack {
                Button {
                    page = .home
                    home = true
                } label: {
                    Image("home")
                        .resizable()
                        .frame(width: 70,height: 50)
                        .opacity(0.1)
                }
            }
            .offset(x:-Swidth / 2 + 50 ,y:-Sheight / 2 + 50)
        }
    }
}
