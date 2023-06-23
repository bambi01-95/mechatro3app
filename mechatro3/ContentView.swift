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
    
    var body: some View {
        ZStack{
            if home == true{
                if (page == .home){
                    HomeView(page:$page,home:$home)
                }
            }
            else{
                if(page == .NormalStick){
                    NormalStickView(page: $page, home: $home)
                }
                if(page == .NormalGyro){
                    NormalGyroView(page: $page, home: $home)
                }
                if(page == .SpecialStick){
                    SpecialStickView(page: $page, home: $home)
                }
                if(page == .SpecialGyro){
                    SpecialGyroView(page: $page, home: $home)
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
