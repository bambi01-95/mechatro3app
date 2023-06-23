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
}

struct ContentView: View {
    @State var page:Pagetype = .Launch
    @State var home: Bool = false
    @State var launch: Bool = true
    @ObservedObject var Contoroller = sendMessage()

    
    var body: some View {
        ZStack{
            if launch == false{
                Image("home_back")
                .resizable()
                .frame(width:300,height: 100)
                    .mask(
                        Text("TATA")
                            .font(.system(size: 100, weight: .black)))
            }
            if (home == true){
                if(page == .home){
                    HomeView(page:$page,home:$home, Contoroller: Contoroller)
                }
            }
            else{
                if(page == .NormalStick){
                    NormalStickView(page: $page, home: $home,Contoroller: Contoroller)
                }
                if(page == .NormalGyro){                    NormalGyroView(page: $page, home: $home,Contoroller: Contoroller)
                }
                if(page == .SpecialStick){
                    SpecialStickView(page: $page, home: $home,Contoroller: Contoroller)
                }
                if(page == .SpecialGyro){
                    SpecialGyroView(page: $page, home: $home, Contoroller: Contoroller)
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

