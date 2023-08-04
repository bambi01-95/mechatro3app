//
//  SpecialVR.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/07/07.
//

import SwiftUI

struct SpecialVR: View {
    @Binding var page:Pagetype
    @Binding var home:Bool
    
    // for main
    @ObservedObject var Stream = streamFrames()
    var body: some View {
        let bounds = UIScreen.main.bounds
        let Sheight = bounds.height
        let Swidth  = bounds.width
        ZStack{
            if let uiImage = UIImage(data: Stream.img_data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: Sheight * 2, height: Sheight)
                    .padding(.top,20)
            }
            else{
                Image("back_gray")
                    .resizable()
                    .frame(width: Sheight * 2, height: Sheight)
                    .padding(.top,20)
            }
            // MARK: home button
            VStack {
                Button {
                    page = .home
                    home = true
                } label: {
                    Image("home")
                        .resizable()
                        .frame(width: 70,height: 50)
                }
            }.offset(x:-Swidth / 2 + 50 ,y:-Sheight / 2 + 50)
        }
        

    }
}

