//
//  HomeView.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/06/19.
//

import SwiftUI
import Network

enum ButtonType{
    case Stick
    case Gyro
    case none
}

enum MonitorType{
    case none
    case WIFI
    case WEB
}

// MARK: HOME PAGE
struct HomeView: View{
    @Binding var page:Pagetype
    @Binding var home:Bool
    
    @ObservedObject var SendInputValue: sendMessage
    
    @State var settingIP:String = ""
    @State var settingPort:String = ""
    
    let myIP:String = "Check it from Settings → Wi-Fi → Details."
    let myPORT:String = "8080"
    

    
    @State var monitor_t: MonitorType = .none
    @State var button_t: ButtonType   = .Stick
    
    @State var monitor_name: String = "Basic"
    @State var button_name: String = "Stick"
    
    @FocusState  var isInputActive:Bool
    var buttonHeight: CGFloat = 50
    var body: some View{
        let bounds = UIScreen.main.bounds
        let Swidth  = bounds.width
        let Sheight = bounds.height
        
        ZStack{
            VStack{
//                 background
                Image("home_back")
                    .resizable()
                    .frame(width: Swidth + Swidth / 30 ,height: Sheight + Sheight / 20)
                    .clipped()
                    .offset(x:0,y:0)
            }
            HStack{
                // MARK: left
                
                VStack{
                    TextField("   IP: \(SendInputValue.hoststr)",text:$settingIP)
                        .frame(width: 400)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numbersAndPunctuation)
                        .padding(.all,5)
        
                    TextField("Port: \(SendInputValue.portstr)",text:$settingPort)
                        .frame(width: 400)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numbersAndPunctuation)
                        .padding(.all,5)

                    
                    Text("     IP: \(myIP)")
                        .frame(width: 400,height: 35,alignment: .leading)
                        .background()
                        .cornerRadius(5)
                        .padding(.all,5)

                    Text("  Port: \(myPORT)")
                        .frame(width: 400,height: 35,alignment: .leading)
                        .background()
                        .cornerRadius(5)
                        .padding(.all,5)
                    
                    Button {
                        if settingIP != ""{
                            SendInputValue.host = NWEndpoint.Host(settingIP)
                            SendInputValue.hoststr = settingIP
                            settingIP = ""
                        }
                        if settingPort != ""{
                            SendInputValue.port = NWEndpoint.Port(settingPort) ?? 8008
                            SendInputValue.portstr = settingPort
                            settingPort = ""
                        }
                        
                    } label: {
                        Text("Set")
                            .bold()
                            .padding()
                            .frame(width: 200, height: buttonHeight)
                            .foregroundColor(Color.white)
                            .background(Color.purple)
                            .cornerRadius(100)
                    }
                    .shadow(radius: 5)
                    
                }
                .frame(height: Sheight * 4 / 5)
                .padding(15)
                .background(Color(red: 0.8, green: 0.2, blue: 0.4, opacity: 0.2))
                .cornerRadius(15)
                
                
                
                // MARK: right
                VStack{
                    HStack{
                        Button {
                            monitor_t = .none
                            monitor_name = "basic"
                        } label: {
                            Text("basic")
                                .bold()
                                .padding()
                                .frame(width: 95, height: buttonHeight)
                                .foregroundColor(Color.white)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        .shadow(radius:(monitor_t == .none) ? 10 : 0)
                        .opacity((monitor_t == .none) ? 1 : 0.4)
                        
                        Button {
                            button_t = .Stick
                            button_name = "Stick"
                        } label: {
                            Text("Stick")
                                .bold()
                                .padding()
                                .frame(width: 95, height: buttonHeight)
                                .foregroundColor(Color.white)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        .shadow(radius:(button_t == .Stick) ? 10 : 0)
                        .opacity((button_t == .Stick) ? 1 : 0.4)
                    }
                    
                    HStack{
                        Button {
                            monitor_t = .WIFI
                            monitor_name = "Wi-Fi"
                        } label: {
                            Text("Socket")
                                .bold()
                                .padding()
                                .frame(width: 95, height: buttonHeight)
                                .foregroundColor(Color.white)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        .shadow(radius:(monitor_t == .WIFI) ? 10 : 0)
                        .opacity((monitor_t == .WIFI) ? 1 : 0.4)
                        
                        Button {
                            button_t = .Gyro
                            button_name = "Gyro"
                        } label: {
                            Text("Gyro")
                                .bold()
                                .padding()
                                .frame(width: 95, height: buttonHeight)
                                .foregroundColor(Color.white)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        .shadow(radius:(button_t == .Gyro) ? 10 : 0)
                        .opacity((button_t == .Gyro) ? 1 : 0.4)
                    }

                    
                    HStack{
                        Button {
                            monitor_t = .WEB
                            monitor_name = "Web"
                        } label: {
                            Text("Web")
                                .bold()
                                .padding()
                                .frame(width: 95, height: buttonHeight)
                                .foregroundColor(Color.white)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        .shadow(radius:(monitor_t == .WEB) ? 10 : 0)
                        .opacity((monitor_t == .WEB) ? 1 : 0.4)
                        
                        Button {
                            button_t = .none
                            button_name = "VR"
                        } label: {
                            Text("VR")
                                .bold()
                                .padding()
                                .frame(width: 95, height: buttonHeight)
                                .foregroundColor(Color.white)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        .shadow(radius:(button_t == .none) ? 10 : 0)
                        .opacity((button_t == .none) ? 1 : 0.4)
                    }
                    
                    Text("\(monitor_name) \(button_name) controller")
                        .bold()
                        .foregroundColor(((monitor_t == .none)&&(button_t == .none)) ? Color.red:Color.white)
                    
                    Button {
                        if(monitor_t == .none){
                            if(button_t == .Stick){
                                page = .NormalStick
                            }
                            if(button_t == .Gyro){
                                page = .NormalGyro

                            }
                            home = false
                            if(button_t == .none){
                                page = .home
                                home = true
                            }

                        }
                        else if(monitor_t == .WEB){
                            if(button_t == .Stick){
                                page = .PremiumStick
                            }
                            if(button_t == .Gyro){
                                page = .PremiumGyro
                            }
                            if(button_t == .none){
                                page = .PremiumVR
                            }
                            home = false
                        }
                        else{
                            if(button_t == .Stick){
                                page = .SpecialStick
                            }
                            if(button_t == .Gyro){
                                page = .SpecialGyro
                            }
                            if(button_t == .none){
                                page = .SpecialVR
                            }
                            home = false
                        }
                        
                    } label: {
                        Text("Start")
                            .bold()
                            .padding()
                            .frame(width: 200, height: buttonHeight)
                            .foregroundColor(Color.white)
                            .background(Color.purple)
                            .cornerRadius(25)
                            .shadow(radius: 10)
                    }
                }
                .frame(height: Sheight * 4 / 5)
                .padding(15)
                .background(Color(red: 0.8, green: 0.2, blue: 0.4, opacity: 0.2))
                .cornerRadius(15)
            }
            .onAppear{print("s-home")}
            .onDisappear{
                print("e-home")
//                home = false
            }
        }
    }
}
