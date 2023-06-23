//
//  HomeView.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/06/19.
//

import SwiftUI
import Network

// MARK: HOME PAGE
struct HomeView: View{
    @Binding var page:Pagetype
    @Binding var home:Bool
    
    @State var StickON: Bool = true
    @State var monitorOn:Bool = true
    @ObservedObject var Contoroller: sendMessage
    
    @State var settingIP:String = ""
    @State var settingPort:String = ""
    
    var myIP:String = "Check it from Settings → Wi-Fi → Details."
    var myPORT:String = "8080"
    
    @State var selectedNS: String = "Special"
    @State var selectedSG: String = "Stick"
    
    @FocusState  var isInputActive:Bool
    var buttonHeight: CGFloat = 50
    var body: some View{
        let bounds = UIScreen.main.bounds
        let Swidth  = bounds.width
        let Sheight = bounds.height
        
        ZStack{
            VStack{
                // background
                Image("home_back")
                    .resizable()
                    .frame(width: Swidth + Swidth / 30 ,height: Sheight + Sheight / 20)
                    .clipped()
                    .offset(x:0,y:0)
            }
            HStack{
                // MARK: left
                
                VStack{
                    TextField("   IP: \(Contoroller.hoststr)",text:$settingIP)
                        .frame(width: 400)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numbersAndPunctuation)
                        .padding(.all,5)
        
                    TextField("Port: \(Contoroller.portstr)",text:$settingPort)
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
                            Contoroller.host = NWEndpoint.Host(settingIP)
                            Contoroller.hoststr = settingIP
                            settingIP = ""
                        }
                        if settingPort != ""{
                            Contoroller.port = NWEndpoint.Port(settingPort) ?? 8080
                            Contoroller.portstr = settingPort
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
                .frame(height: Sheight * 7 / 10)
                .padding(15)
                .background(Color(red: 0.8, green: 0.2, blue: 0.4, opacity: 0.2))
                .cornerRadius(15)
                
                
                
                // MARK: right
                VStack{
                    
                    Button {
                        monitorOn = false
                        selectedNS = "Normal"
                    } label: {
                        Text("Normal")
                            .bold()
                            .padding()
                            .frame(width: 200, height: buttonHeight)
                            .foregroundColor(Color.white)
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                    .shadow(radius:(monitorOn == false) ? 10 : 0)
                    .opacity((monitorOn == false) ? 1 : 0.4)
                    
                    Button {
                        monitorOn = true
                        selectedNS = "Special"
                    } label: {
                        Text("Special")
                            .bold()
                            .padding()
                            .frame(width: 200, height: buttonHeight)
                            .foregroundColor(Color.white)
                            .background(Color.purple)
                            .cornerRadius(10)
                    }
                    .shadow(radius:(monitorOn == true) ? 10 : 0)
                    .opacity((monitorOn == true) ? 1 : 0.4)
                    
                    HStack{
                        Button {
                            StickON = true
                            selectedSG = "Stick"
                        } label: {
//                            Text("Stick")
                            Image(systemName: "gamecontroller.fill")
                                .bold()
                                .padding()
                                .frame(width: 95, height: buttonHeight)
                                .foregroundColor(Color.white)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        .shadow(radius:(StickON == true) ? 10 : 0)
                        .opacity((StickON == true) ? 1 : 0.4)
                        
                        Button {
                            StickON = false
                            selectedSG = "Gyro"
                        } label: {
                            Image(systemName:"steeringwheel")
                                .bold()
                                .padding()
                                .frame(width: 95, height: buttonHeight)
                                .foregroundColor(Color.white)
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        .shadow(radius:(StickON == false) ? 10 : 0)
                        .opacity((StickON == false) ? 1 : 0.4)
                    }
                    
                    Text("\(selectedNS) \(selectedSG) controller")
                        .bold()
                        .foregroundColor(Color.white)
                    
                    Button {
                        if(monitorOn == true){
                            if(StickON == true){
                                page = .SpecialStick
                                
                            }
                            else{
                                page = .SpecialGyro
                            }
                        }
                        else if(monitorOn == false){
                            if(StickON == true){
                                page = .NormalStick
                            }
                            else{
                                page = .NormalGyro
                            }
                        }
                        home = false
                    
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
                .frame(height: Sheight * 7 / 10)
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
