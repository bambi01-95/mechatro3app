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
    @ObservedObject var SendInputValue: sendMessage
    @ObservedObject var Stream = streamFrames()
    
    @State var timer :Timer?
    @State var count: Int = 0
    
    @State var spd = 0
    @State var Lvec = 0
    @State var Rvec = 0
    @State var Mode = "CLOSE MODE"
    
    @State var Locy:CGFloat = 0
    @State var Data:Gyrotype = .none //fr
    
    @State var arm1Locy:CGFloat = 0
    @State var arm1Data:String = "00"//fr
    
    @State var arm2Locy:CGFloat = 0
    @State var arm2Data:String = "00"//ij
    
    @State var spdLocy:CGFloat = 0
    @State var modeLocy:CGFloat = 0

    private let motionManager = CMMotionManager()
    
    @State private var yaw: Double = 0.0
    @State private var pitch: Double = 0.0
    @State private var roll: Double = 0.0
    
    var drag: some Gesture {
        DragGesture()
            .onChanged{ value in
                let transy = value.translation.height
                if(transy > 70){
                    Locy = 70
                }
                else if(transy < -70){
                    Locy = -70
                }
                else{// 範囲内
                    Locy = transy
                }
                if(transy > 50){
                    Data = .brake
                }
                else if(transy < -50){
                    Data = .acce
                }
            }//話した時のの動作 初期位置に戻す
            .onEnded{ value in
                Locy = 0
                Data = .none
            }
    }


    
    // MARK: arm1/2 drag
    var dragarm1: some Gesture {
        DragGesture()
            .onChanged{ value in
                let transy = value.translation.height
                // limitaion button range
                if(transy > 70){
                    arm1Locy = 70
                }
                else if(transy < -70){
                    arm1Locy = -70
                }
                else{// 範囲内
                    arm1Locy = transy
                }
                //sending data
                if(transy > 20){
                    arm1Data = "10"
                }
                else if (transy < -20){
                    arm1Data = "01"
                }
                else{
                    arm1Data = "00"
                }
            }
            .onEnded{ value in
                arm1Locy = 0
                arm1Data = "00"
            }
    }
    var dragarm2: some Gesture {
        DragGesture()
            .onChanged{ value in
                let transy = value.translation.height
                if(transy > 70){
                    arm2Locy = 70
                }
                else if(transy < -70){
                    arm2Locy = -70
                }
                else{// 範囲内
                    arm2Locy = transy
                }
                if(transy > 20){
                    arm2Data = "10"
                }
                else if(transy < -20){
                    arm2Data = "01"
                }
                else{
                    arm2Data = "00"
                }
            }//話した時のの動作 初期位置に戻す
            .onEnded{ value in
                arm2Locy = 0
                arm2Data = "00"
            }
    }
    // MARK: speed drag
    var dragspd: some Gesture {
        DragGesture()
            .onChanged{ value in
                let transy = value.translation.height
                if(transy > 70){
                    spdLocy = 70
                }
                else if(transy < -70){
                    spdLocy = -70
                }
                else{// 範囲内
                    spdLocy = transy
                }
                if(transy < 0){
                    spd += 1
                    if(spd>99){
                        spd = 100
                    }
                }
                else{
                    spd -= 1
                    if(spd<1){
                        spd = 0
                    }
                }
            }//話した時のの動作 初期位置に戻す
            .onEnded{ value in
                spdLocy = 0
            }
    }

    var dragmode: some Gesture {
        DragGesture()
            .onChanged{ value in
                let transy = value.translation.height
                if(transy > 70){
                    modeLocy = 70
                }
                else if(transy < -70){
                    modeLocy = -70
                }
                else{// 範囲内
                    modeLocy = transy
                }
                if(transy > 50){
                    Mode = "CLOSE MODE"
                }
                else if(transy < -50){
                    Mode = "OPEN MODE"
                }
            }//話した時のの動作 初期位置に戻す
            .onEnded{ value in
                modeLocy = 0
            }
    }
    
    // MARK: main view
    var body: some View {
        let bounds = UIScreen.main.bounds
        let Sheight = bounds.height
        let Swidth = bounds.width
        let d = -6 * Sheight / Double.pi
        ZStack{
            // MARK: background
            ZStack{
                Image("back_gray")
                    .resizable()
                    .frame(width: Swidth + Swidth / 30 ,height: Sheight + Sheight / 20)
                    .clipped()
                    .offset(x:0,y:0)
                Image("home_back")
                    .resizable()
                    .frame(width:300,height: 100)
                    .mask(
                        Text("TATA")
                            .font(.system(size: 100, weight: .black)))
            }
            
            // MARK: display strieaming img here
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
            // MARK: home button
            VStack{
                Button {
                    page = .home
                    home = true
                } label: {
                    Image("home")
                        .resizable()
                        .frame(width: 70,height: 50)
                        .shadow(radius: 5)
                }
            }.offset(x:-Swidth / 2 + 50 ,y:-Sheight / 2 + 50)
            // MARK: text diplay
            VStack{
                    Text("[\(Mode)]\(spd) spd (\(Lvec):\(Rvec))")
                        .font(.system(size: 20, weight: .black, design: .default))
            }.offset(y:Sheight / 2 - 40)
            
            // MARK: LEFT
            HStack{
                // acce/brake control
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.gray)
                        .frame(width:70, height: 150)
                        .offset()
                        .opacity(0.2)
                    // 左のコントロールボタン
                    Image("stick_button_g")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .opacity(0.5)
                        .offset(y:Locy)
                        .gesture(drag)
                        .shadow(color: .black, radius: 5)
                }
                // arm1  control
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.gray)
                        .frame(width:60, height: 150)
                        .offset()
                        .opacity(0.2)
                    
                    // 左のコントロールボタン
                    Image("stick_button")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .opacity(arm1Data == "00" ? 0.5 : 1)
                        .offset(y: arm1Locy)
                        .gesture(dragarm1)
                        .shadow(color: .black, radius: 5)
                }
            }.offset(x: -Swidth / 4 - 50,y:50)
            
            
            
            
            
            // MARK: RIGHT
            HStack{
                // arm2 control
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.gray)
                        .frame(width:60, height: 150)
                        .offset()
                        .opacity(0.2)
                    // 左のコントロールボタン
                    Image("stick_button")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .opacity(arm2Data == "00" ? 0.5 : 1)
                        .offset(y: arm2Locy)
                        .gesture(dragarm2)
                        .shadow(color: .black, radius: 5)
                }
                // speed control
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.gray)
                        .frame(width:60, height: 150)
                        .offset()
                        .opacity(0.2)
                    // 左のコントロールボタン
                    Image("stick_button_y")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .opacity(0.5)
                        .offset(y: spdLocy)
                        .gesture(dragspd)
                        .shadow(color: .black, radius: 5)
                }
                // mode control
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.gray)
                        .frame(width:60, height: 150)
                        .offset()
                        .opacity(0.2)
                    // 左のコントロールボタン
                    Image("stick_button_p")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .opacity(0.5)
                        .offset(y:modeLocy)
                        .gesture(dragmode)
                        .shadow(color: .black, radius: 5)
                }
            }.offset(x:Swidth / 4 + 50, y: 50)
            
            
        }
        .frame(width: Swidth,height: Sheight + 50)
        .onAppear{
            print("sng")
            Stream.self.startReceive(0)
            SendInputValue.self.connect()
            GyroStart()
        }
        .onDisappear{
            print("eng")
            GyroStop()
            SendInputValue.self.disconnect()
            Stream.self.stopReceive(0)
        }
    }
    
    
    
    func GyroStart() {
        if motionManager.isDeviceMotionAvailable{
            motionManager.deviceMotionUpdateInterval = 0.1/* sending interval */
            motionManager.startDeviceMotionUpdates(to: .main){
                data, error in
                guard let data else { return }
                yaw = data.attitude.yaw
                pitch = data.attitude.pitch
                roll = data.attitude.roll
                // not drag or abs(position) < 50
                if(Data == .none){
                    let limit = Double.pi / 6
                    if(pitch > limit){
                        Lvec = spd
                        Rvec = -spd
                    }
                    else if(pitch < -limit){
                        Lvec = -spd
                        Rvec = spd
                    }
                    else{
                        Lvec = 0
                        Rvec = 0
                    }
                }
                else{
                    let limit = Double.pi / 4
                    var alpha = 1 - (abs(pitch) / limit)
                    if(alpha<0){
                        alpha = 0
                    }
                    if(0 < pitch){
                        Lvec = spd
                        Rvec = Int(Double(spd) * alpha)
                    }
                    else if(pitch < 0){
                        Lvec = Int(Double(spd) * alpha)
                        Rvec = spd
                    }
                    if(Data == .brake){
                        Lvec *= -1
                        Rvec *= -1
                    }
                    if(Mode == "OPEN MODE"){
                        let stock = Lvec
                        Lvec = -1 * Rvec
                        Rvec = -1 * stock
                    }
                }
                // send function here
                let message = String(Lvec)+","+String(Rvec)+","+arm1Data+","+arm2Data
                SendInputValue.self.send(message.data(using:.utf8)!)
            }
        }
    }
    
    // end of the getting data　YPR
    func GyroStop() {
        if motionManager.isAccelerometerActive {
            motionManager.stopAccelerometerUpdates()
        }
        if motionManager.isDeviceMotionActive{
            motionManager.stopDeviceMotionUpdates()
        }
    }
}







    










