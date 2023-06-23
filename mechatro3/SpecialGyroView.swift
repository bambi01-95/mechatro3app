//
//  SpecialGyroView.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/06/19.
//

import SwiftUI
import CoreMotion

struct SpecialGyroView: View {
    @Binding var page:Pagetype
    @Binding var home:Bool
    
    // for main
    @ObservedObject var Stream = streamFrames()
    @ObservedObject var Contoroller = sendMessage()
    @State var timer :Timer?
    @State var count: Int = 0
    @State var Lvec = 0.0
    @State var Rvec = 0.0
    private var frameWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    private let motionManager = CMMotionManager()

    @State private var yaw: Double = 0.0
    @State private var pitch: Double = 0.0
    @State private var roll: Double = 0.0

    @State var velocity:Double = 0.0
    
    // MARK: main view
    var body: some View {
        let bounds = UIScreen.main.bounds
        let Sheight = bounds.height
        let Swidth = bounds.width
        let d = -6 * Sheight / Double.pi
        
        ZStack{


            
            // 背景（ストリーミング画像の挿入場所）
            // MARK: background
            VStack{
                
                if let uiImage = UIImage(data: Stream.img_data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .frame(width: 700, height: 700)
                        .rotationEffect(.degrees(180 / Double.pi * -pitch))
                        .offset(y: (roll + Double.pi / 2) * d)
                        .padding(.top,20)
                }
                else{
                    Image("back_gray")
                        .resizable()
                        .frame(width: 700, height: 700)
                        .offset(y: (roll + Double.pi / 2) * d)
                        .rotationEffect(.degrees(180 / Double.pi * -pitch))
                        .padding(.top,20)
                }
            }
            // 傾きの値を表示
            VStack{
                Text("YPR")
                Text("yaw:\(yaw)")
                Text("pitch:\(pitch)")
                Text("roll:\(roll)")
                Text("velocity: \(velocity)")
                    .padding(.top)
                Text("Lvec:\(Lvec) Rvec:\(Rvec)")
                Text("d: \(pitch * d)")
            }
            
            // MARK: home button
            VStack {
                Button {
                    page = .home
                } label: {
                    Image("home")
                        .resizable()
                        .frame(width: 70,height: 50)
                }
            }.offset(x:-Swidth / 2 + 50 ,y:-Sheight / 2 + 50)
            
            // MARK: controller buttons
            //ボタンなど
            HStack{
                HStack{
                    //
                    Button{
                        velocity = 0
                    }label: {
                        Image("clutch_button")
                            .resizable()
                            .frame(width:60, height: 80)
                            
                    }
                    .padding(.bottom,60)
                    // blue bottom button
                    Button{
                        if(velocity < 5){
                            velocity = 0
                        }
                        else{
                            velocity -= 5
                        }
                    }label: {
                        Image("brake_button")
                            .resizable()
                            .frame(width:100, height: 80)
                            
                    }
                    .padding(.bottom,60)
                    
                    Button{
                        if(velocity>45){
                            velocity = 50
                        }
                        else{
                            velocity += 5
                        }
                    }label: {
                        Image("acce_button")
                            .resizable()
                            .frame(width:70, height: 150)
                    }
                    
                }
                .padding(.top, 100)
                Spacer()
            //右ボタン４種
                VStack{
              //上ボタン
                    Button {
                        print("top")
                    } label: {
                        Image("red_button_g")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(Color.black)
                    }
                    .shadow(color: .black, radius: 5)
              //中ボタン
                    HStack{
                        //左ボたん
                        Button {
                            print("left")
                        } label: {
                            Image("yellow_button_g")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color.black)
                        }
                        .shadow(color: .black, radius: 5)
                        .padding(.trailing, 34)
                        // 右ボタン
                        Button {
                            print("right")
                        } label: {
                            Image("blue_button_g")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(Color.black)
                        }
                        .shadow(color: .black, radius: 5)
                        .padding(.leading, 34)
                    }
            //下ボタン
                    Button {
                        print("bottom")
                    } label: {
                        Image("green_button_g")
                            .resizable()
                            .frame(width: 70, height: 70)
                            .foregroundColor(Color.black)
                    }
                    .shadow(color: .black, radius: 5)
                    
                    
                }
            }
            
        }
        .onAppear{
            start()
            Stream.self.startReceive(0)
            Contoroller.self.connect()
        }
        .onDisappear{
            stop()
            Stream.self.stopReceive(0)
            Contoroller.self.disconnect()
            home = true
        }
    }
    
    // MARK: functions
    // get the data　YPR
    func start() {
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = 0.1
            motionManager.startDeviceMotionUpdates(to: .main){
                data, error in
                guard let data else { return }
                yaw = data.attitude.yaw
                pitch = data.attitude.pitch
                roll = data.attitude.roll
                let limit = Double.pi / 4
                var alpha = 1 - (abs(pitch) / limit)
                if(alpha<0){
                    alpha = 0
                }
                if(0 < pitch){
                    Lvec = velocity
                    Rvec = velocity * alpha
                }
                else if(pitch < 0){
                    Lvec = velocity * alpha
                    Rvec = velocity
                }
                let message = String(Int(Lvec)) + "," + String(Int(Rvec))
                Contoroller.self.send(message.data(using:.utf8)!)
            }
        }
    }
    // end of the getting data　YPR
    func stop() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
        if motionManager.isDeviceMotionActive{
            motionManager.stopDeviceMotionUpdates()
        }
    }
}







    










