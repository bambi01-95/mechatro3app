//
//  ContentView.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/06/19.
//

// next Special Gyro controller
import SwiftUI

enum Pagetype{
    case Launch
    case home
    case NormalStick
    case NormalGyro
    
    case SpecialStick
    case SpecialGyro
    case SpecialVR
    
    case PremiumStick
    case PremiumGyro
    case PremiumVR
}



import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    let loardUrl: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: loardUrl)
        uiView.load(request)
    }
}



struct ContentView: View {
    @State var page:Pagetype = .Launch
    @State var home: Bool = false
    @State var launch: Bool = true
    @ObservedObject var SendInputValue = sendMessage()

    
    var body: some View {
        ZStack{
            if (home == true){
                if(page == .home){
                    HomeView(page:$page,home:$home, SendInputValue: SendInputValue)
                }
            }
            else{
                if(page == .NormalStick){
                    NormalStickView(page: $page, home: $home,SendInputValue: SendInputValue)
                }
                if(page == .NormalGyro){                    NormalGyroView(page: $page, home: $home,SendInputValue: SendInputValue)
                }
                if(page == .SpecialStick){
                    SpecialStickView(page: $page, home: $home,SendInputValue: SendInputValue)
                }
                if(page == .SpecialGyro){
                    SpecialGyroView(page: $page, home: $home, SendInputValue: SendInputValue)
                }
                if(page == .SpecialVR){
                    SpecialVR(page: $page, home: $home)
                }
                if(page == .PremiumStick){
                    PremiumStick(page: $page, home:$home, SendInputValue: SendInputValue)
                }
                if(page == .PremiumGyro){
                    PremiumGyro(page: $page, home:$home, SendInputValue: SendInputValue)
                }
                if(page == .PremiumVR){
                    PremiumVR(page: $page, home:$home,SendInputValue: SendInputValue)
                }
            }
            if launch == true {
                if (page == .Launch){
                    LaunchScreen(page: $page, home: $home, launch: $launch)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

