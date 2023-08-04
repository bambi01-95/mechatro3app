//
//  gyrocont_f.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/07/16.
//


// this is first design of the controller ?????

import SwiftUI
import CoreMotion

struct gyrocont_f: View {
//    @Binding var page:Pagetype
//    @Binding var home:Bool
    
//    // for main
//    @ObservedObject var SendInputValue: sendMessage
//    @State var timer :Timer?
//    @State var count: Int = 0
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
    @State var acceButtonOn: Bool = false
    @State var brakeButtonOn: Bool = false
    @State var acce_t: Double = 0.0
    @State var fric_t: Double = 0.0
    
    // MARK: main view
    var body: some View {
        let bounds = UIScreen.main.bounds
        let Sheight = bounds.height
        let Swidth = bounds.width
        
        ZStack{
            
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
            // 傾きの値を表示
            VStack{
                Text("Velocity: \(Int(velocity))")
                Text("Lvec:\(Int(Lvec)) Rvec:\(Int(Rvec))")
            }.offset(y:-Sheight/2 + 30)
            
            
            // MARK: home button
            VStack {
                Button {
//                    page = .home
//                    home = true
                } label: {
                    Image("home")
                        .resizable()
                        .frame(width: 70,height: 50)
                }
            }.offset(x:-Swidth / 2 + 50 ,y:-Sheight / 2 + 50)
            
            
            // MARK: controller buttons
            //ボタンなど
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
                

                Button{
                    
                }label: {
                    Image("brake_button")
                        .resizable()
                        .frame(width:100, height: 80)
                        .onLongPressGesture(
                            minimumDuration: 120.0,
                            pressing:{ pressing in
                                if pressing {
                                    print("acce")
                                    brakeButtonOn = true
                                }
                                else {
                                    print("stop")
                                    brakeButtonOn = false
                                }}
                        )
                    {print(123)}
                        .opacity((brakeButtonOn ? 0.3 : 1.0))
                }
                .padding(.bottom,60)
                
                Button(){
                    
                }label: {
                    Image("acce_button")
                        .resizable()
                        .frame(width:70, height: 150)
                        .onLongPressGesture(
                            minimumDuration: 120.0,
                            pressing:{ pressing in
                                if pressing {
                                    print("acce")
                                    acceButtonOn = true
                                }
                                else {
                                    print("stop")
                                    acceButtonOn = false
                                }}
                        )
                    {print(123)}
                        .opacity((acceButtonOn ? 0.3 : 1.0))
                    
                }
            }
            .offset(x: -Swidth / 3 + 50,y:75)
            
            // MARK: R buttons
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
            .offset(x: Swidth / 3)
            
        }
        .frame(width: Swidth,height: Sheight + 50)
        .onAppear{
            print("sng")
//            SendInputValue.self.connect()
//            start()
//            StartMove()
        }
        .onDisappear{
            print("eng")
            stop()
//            SendInputValue.self.disconnect()
//            StopMove()
        }
    }
    
    
    
    // MARK: functions
    // todo: もう少し面白い速度決定
//    func StartMove(){
//        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
//            speedControl()
//        }
//    }
    func speedControl(){
        if(acceButtonOn == true){
            velocity = velocity + 2 * acce_t
            if velocity > 50.0{
                velocity = 50.0
            }
            acce_t += 1.0
            fric_t = 0.0
        }
        else{
            velocity = velocity - 1 * fric_t
            fric_t += 1
            acce_t = 0.0
        }
        
        if(brakeButtonOn){
            velocity = velocity - 10
        }
        
        if velocity < 0.0{
            velocity = 0.0
        }
    }
//    func StopMove(){
//        timer?.invalidate()
//    }
    
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
//                let message = String(Int(Lvec)) + "," + String(Int(Rvec))
//                SendInputValue.self.send(message.data(using:.utf8)!)
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

struct gyrocont_f_Previews: PreviewProvider {
    static var previews: some View {
        gyrocont_f()
    }
}





//MARK: Special gyro 2023/07/17
//
//  SpecialGyroView.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/06/19.
//
//
//import SwiftUI
//import CoreMotion
//
//struct SpecialGyroView: View {
//    @Binding var page:Pagetype
//    @Binding var home:Bool
//
//    // for main
//    @ObservedObject var Stream = streamFrames()
//    @ObservedObject var SendInputValue: sendMessage
//
//    @State var timer :Timer?
//    @State var count: Int = 0
//    @State var Lvec = 0.0
//    @State var Rvec = 0.0
//    private var frameWidth: CGFloat {
//        UIScreen.main.bounds.width
//    }
//    private let motionManager = CMMotionManager()
//
//    @State private var yaw: Double = 0.0
//    @State private var pitch: Double = 0.0
//    @State private var roll: Double = 0.0
//
//    @State var velocity:Double = 0.0
//    @State var acceButtonOn: Bool = false
//    @State var brakeButtonOn: Bool = false
//    @State var acce_t: Double = 0.0
//    @State var fric_t: Double = 0.0
//
//    // MARK: main view
//    var body: some View {
//        let bounds = UIScreen.main.bounds
//        let Sheight = bounds.height
//        let Swidth = bounds.width
//        let d = -6 * Sheight / Double.pi
//
//        ZStack{
//
//            ZStack{
//                Image("back_gray")
//                    .resizable()
//                    .frame(width: Swidth + Swidth / 30 ,height: Sheight + Sheight / 20)
//                    .clipped()
//                    .offset(x:0,y:0)
//                Image("home_back")
//                    .resizable()
//                    .frame(width:300,height: 100)
//                    .mask(
//                        Text("TATA")
//                            .font(.system(size: 100, weight: .black)))
//            }
//
//            // 背景（ストリーミング画像の挿入場所）
//            // MARK: background
//            VStack{
//
//                if let uiImage = UIImage(data: Stream.img_data) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .frame(width: 700, height: 700)
//                        .rotationEffect(.degrees(180 / Double.pi * -pitch))
//                        .offset(y: (roll + Double.pi / 2) * d)
//                        .padding(.top,20)
//                }
//                else{
//                    Image("back_gray")
//                        .resizable()
//                        .frame(width: 700, height: 700)
//                        .offset(y: (roll + Double.pi / 2) * d)
//                        .rotationEffect(.degrees(180 / Double.pi * -pitch))
//                        .padding(.top,20)
//                }
//            }
//            // 傾きの値を表示
//            VStack{
//
//                Text("Velocity: \(Int(velocity))")
//
//                Text("Lvec:\(Int(Lvec)) Rvec:\(Int(Rvec))")
//            }.offset(y:-Sheight/2 + 30)
//
//            // MARK: home button
//            VStack {
//                Button {
//                    page = .home
//                    home = true
//                } label: {
//                    Image("home")
//                        .resizable()
//                        .frame(width: 70,height: 50)
//                }
//            }.offset(x:-Swidth / 2 + 50 ,y:-Sheight / 2 + 50)
//
//
//            // MARK: controller buttons
//            //ボタンなど
//            HStack{
//                //
//                Button{
//                    velocity = 0
//                }label: {
//                    Image("clutch_button")
//                        .resizable()
//                        .frame(width:60, height: 80)
//
//                }
//                .padding(.bottom,60)
//
//
//                Button{
//
//                }label: {
//                    Image("brake_button")
//                        .resizable()
//                        .frame(width:100, height: 80)
//                        .onLongPressGesture(
//                            minimumDuration: 120.0,
//                            pressing:{ pressing in
//                                if pressing {
//                                    print("acce")
//                                    brakeButtonOn = true
//                                }
//                                else {
//                                    print("stop")
//                                    brakeButtonOn = false
//                                }}
//                        )
//                    {print(123)}
//                        .opacity((brakeButtonOn ? 0.3 : 1.0))
//                }
//                .padding(.bottom,60)
//
//                Button(){
//
//                }label: {
//                    Image("acce_button")
//                        .resizable()
//                        .frame(width:70, height: 150)
//                        .onLongPressGesture(
//                            minimumDuration: 120.0,
//                            pressing:{ pressing in
//                                if pressing {
//                                    print("acce")
//                                    acceButtonOn = true
//                                }
//                                else {
//                                    print("stop")
//                                    acceButtonOn = false
//                                }}
//                        )
//                    {print(123)}
//                        .opacity((acceButtonOn ? 0.3 : 1.0))
//
//                }
//            }
//            .offset(x: -Swidth / 3 + 50,y:75)
//
//            // MARK: R buttons
//            VStack{
//                //上ボタン
//                Button {
//                    print("top")
//                } label: {
//                    Image("red_button_g")
//                        .resizable()
//                        .frame(width: 70, height: 70)
//                        .foregroundColor(Color.black)
//                }
//                .shadow(color: .black, radius: 5)
//                //中ボタン
//                HStack{
//                    //左ボたん
//                    Button {
//                        print("left")
//                    } label: {
//                        Image("yellow_button_g")
//                            .resizable()
//                            .frame(width: 70, height: 70)
//                            .foregroundColor(Color.black)
//                    }
//                    .shadow(color: .black, radius: 5)
//                    .padding(.trailing, 34)
//                    // 右ボタン
//                    Button {
//                        print("right")
//                    } label: {
//                        Image("blue_button_g")
//                            .resizable()
//                            .frame(width: 70, height: 70)
//                            .foregroundColor(Color.black)
//                    }
//                    .shadow(color: .black, radius: 5)
//                    .padding(.leading, 34)
//                }
//                //下ボタン
//                Button {
//                    print("bottom")
//                } label: {
//                    Image("green_button_g")
//                        .resizable()
//                        .frame(width: 70, height: 70)
//                        .foregroundColor(Color.black)
//                }
//                .shadow(color: .black, radius: 5)
//            }
//            .offset(x: Swidth / 3)
//
//        }
//        .onAppear{
//            print("ssg")
//            SendInputValue.self.connect()
//            start()
//            Stream.self.startReceive(0)
//            StartMove()
//
//        }
//        .onDisappear{
//            print("esg")
//            stop()
//            Stream.self.stopReceive(0)
//            SendInputValue.self.disconnect()
//            StopMove()
//        }
//    }
//    func StartMove(){
//        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
//            speedControl()
//        }
//    }
//    func speedControl(){
//        if(acceButtonOn == true){
//            velocity = velocity + 2 * acce_t
//            if velocity > 50.0{
//                velocity = 50.0
//            }
//            acce_t += 1.0
//            fric_t = 0.0
//        }
//        else{
//            velocity = velocity - 1 * fric_t
//            fric_t += 1
//            acce_t = 0.0
//        }
//
//        if(brakeButtonOn){
//            velocity = velocity - 10
//        }
//
//        if velocity < 0.0{
//            velocity = 0.0
//        }
//    }
//    func StopMove(){
//        timer?.invalidate()
//    }
//    // MARK: functions
//    // get the data　YPR
//    func start() {
//        if motionManager.isDeviceMotionAvailable{
//            motionManager.deviceMotionUpdateInterval = 0.1
//            motionManager.startDeviceMotionUpdates(to: .main){
//                data, error in
//                guard let data else { return }
//                yaw = data.attitude.yaw
//                pitch = data.attitude.pitch
//                roll = data.attitude.roll
//                let limit = Double.pi / 4
//                var alpha = 1 - (abs(pitch) / limit)
//                if(alpha<0){
//                    alpha = 0
//                }
//                if(0 < pitch){
//                    Lvec = velocity
//                    Rvec = velocity * alpha
//                }
//                else if(pitch < 0){
//                    Lvec = velocity * alpha
//                    Rvec = velocity
//                }
//                let message = String(Int(Lvec)) + "," + String(Int(Rvec))
//                SendInputValue.self.send(message.data(using:.utf8)!)
//            }
//        }
//    }
//    // end of the getting data　YPR
//    func stop() {
//        if motionManager.isAccelerometerActive {
//            motionManager.stopAccelerometerUpdates()
//        }
//        if motionManager.isDeviceMotionActive{
//            motionManager.stopDeviceMotionUpdates()
//        }
//    }
//}




//MARK: Premium gyro 2023/07/17
//
//  PremiumGyro.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/07/07.
//

//import SwiftUI
//import CoreMotion
//
//struct PremiumGyro: View {
//    @Binding var page:Pagetype
//    @Binding var home:Bool
//    @ObservedObject var SendInputValue: sendMessage //edit
//
//    // variable only this code
//    @State var timer :Timer?
//    @State var count: Int = 0
//    @State var Lvec = 0.0
//    @State var Rvec = 0.0
//    private var frameWidth: CGFloat {
//        UIScreen.main.bounds.width
//    }
//    private let motionManager = CMMotionManager()
//
//    @State private var yaw: Double = 0.0
//    @State private var pitch: Double = 0.0
//    @State private var roll: Double = 0.0
//
//    @State var velocity:Double = 0.0
//    @State var acceButtonOn: Bool = false
//    @State var brakeButtonOn: Bool = false
//    @State var acce_t: Double = 0.0
//    @State var fric_t: Double = 0.0
//
//    // MARK: main
//    var body: some View {
//        let bounds = UIScreen.main.bounds
//        let Sheight = bounds.height
//        let Swidth = bounds.width
//        let d = -6 * Sheight / Double.pi
//
//        ZStack{
//            ZStack{
//                Image("back_gray")
//                    .resizable()
//                    .frame(width: Swidth + Swidth / 30 ,height: Sheight + Sheight / 20)
//                    .clipped()
//                    .offset(x:0,y:0)
////                Image("home_back")
////                    .resizable()
////                    .frame(width:300,height: 100)
////                    .mask(
////                        Text("TATA")
////                            .font(.system(size: 100, weight: .black)))
//            }
//            WebView(loardUrl: URL(string: "http://" + SendInputValue.hoststr + ":8000/stream/")!)// edit
//                .frame(width: 800, height: 400)
//                .rotationEffect(.degrees(180 / Double.pi * -pitch))
//                .offset(x:-10,y: (roll + Double.pi / 2) * d)
//            // MARK: home button
//            VStack {
//                Button {
//                    page = .home
//                    home = true
//                } label: {
//                    Image("home")
//                        .resizable()
//                        .frame(width: 70,height: 50)
//                }
//            }.offset(x:-Swidth / 2 + 50 ,y:-Sheight / 2 + 50)
//
//            // MARK: home button
//            VStack {
//                Button {
//                    page = .home
//                    home = true
//                } label: {
//                    Image("home")
//                        .resizable()
//                        .frame(width: 70,height: 50)
//                }
//            }.offset(x:-Swidth / 2 + 50 ,y:-Sheight / 2 + 50)
//
//            // display LR motor spd
//            VStack{
//                Text("Velocity: \(Int(velocity))")
//                Text("Lvec:\(Int(Lvec)) Rvec:\(Int(Rvec))")
//            }.offset(y:-Sheight/2 + 30)
//
//            // MARK: controller buttons
//            //ボタンなど
//            HStack{
//                //
//                Button{
//                    velocity = 0
//                }label: {
//                    Image("clutch_button")
//                        .resizable()
//                        .frame(width:60, height: 80)
//
//                }
//                .padding(.bottom,60)
//
//
//                Button{
//
//                }label: {
//                    Image("brake_button")
//                        .resizable()
//                        .frame(width:100, height: 80)
//                        .onLongPressGesture(
//                            minimumDuration: 120.0,
//                            pressing:{ pressing in
//                                if pressing {
//                                    print("acce")
//                                    brakeButtonOn = true
//                                }
//                                else {
//                                    print("stop")
//                                    brakeButtonOn = false
//                                }}
//                        )
//                    {print(123)}
//                        .opacity((brakeButtonOn ? 0.3 : 1.0))
//                }
//                .padding(.bottom,60)
//
//                Button(){
//
//                }label: {
//                    Image("acce_button")
//                        .resizable()
//                        .frame(width:70, height: 150)
//                        .onLongPressGesture(
//                            minimumDuration: 120.0,
//                            pressing:{ pressing in
//                                if pressing {
//                                    print("acce")
//                                    acceButtonOn = true
//                                }
//                                else {
//                                    print("stop")
//                                    acceButtonOn = false
//                                }}
//                        )
//                    {print(123)}
//                        .opacity((acceButtonOn ? 0.3 : 1.0))
//
//                }
//            }
//            .offset(x: -Swidth / 3 + 50,y:75)
//
//            // MARK: R buttons
//            VStack{
//                //上ボタン
//                Button {
//                    print("top")
//                } label: {
//                    Image("red_button_g")
//                        .resizable()
//                        .frame(width: 70, height: 70)
//                        .foregroundColor(Color.black)
//                }
//                .shadow(color: .black, radius: 5)
//                //中ボタン
//                HStack{
//                    //左ボたん
//                    Button {
//                        print("left")
//                    } label: {
//                        Image("yellow_button_g")
//                            .resizable()
//                            .frame(width: 70, height: 70)
//                            .foregroundColor(Color.black)
//                    }
//                    .shadow(color: .black, radius: 5)
//                    .padding(.trailing, 34)
//                    // 右ボタン
//                    Button {
//                        print("right")
//                    } label: {
//                        Image("blue_button_g")
//                            .resizable()
//                            .frame(width: 70, height: 70)
//                            .foregroundColor(Color.black)
//                    }
//                    .shadow(color: .black, radius: 5)
//                    .padding(.leading, 34)
//                }
//                //下ボタン
//                Button {
//                    print("bottom")
//                } label: {
//                    Image("green_button_g")
//                        .resizable()
//                        .frame(width: 70, height: 70)
//                        .foregroundColor(Color.black)
//                }
//                .shadow(color: .black, radius: 5)
//            }
//            .offset(x: Swidth / 3)
//        }
//        .onAppear{
//            print("ssg")
//            SendInputValue.self.connect()
//            start()
//            StartMove()
//        }
//        .onDisappear{
//            print("esg")
//            stop()
//            SendInputValue.self.disconnect()
//            StopMove()
//        }
//    }
//    func StartMove(){
//        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { _ in
//            speedControl()
//        }
//    }
//    func speedControl(){
//        if(acceButtonOn == true){
//            velocity = velocity + 2 * acce_t
//            if velocity > 50.0{
//                velocity = 50.0
//            }
//            acce_t += 1.0
//            fric_t = 0.0
//        }
//        else{
//            velocity = velocity - 1 * fric_t
//            fric_t += 1
//            acce_t = 0.0
//        }
//
//        if(brakeButtonOn){
//            velocity = velocity - 10
//        }
//
//        if velocity < 0.0{
//            velocity = 0.0
//        }
//    }
//    func StopMove(){
//        timer?.invalidate()
//    }
//    // MARK: functions
//    // get the data　YPR
//    func start() {
//        if motionManager.isDeviceMotionAvailable{
//            motionManager.deviceMotionUpdateInterval = 0.1
//            motionManager.startDeviceMotionUpdates(to: .main){
//                data, error in
//                guard let data else { return }
//                yaw = data.attitude.yaw
//                pitch = data.attitude.pitch
//                roll = data.attitude.roll
//                let limit = Double.pi / 4
//                var alpha = 1 - (abs(pitch) / limit)
//                if(alpha<0){
//                    alpha = 0
//                }
//                if(0 < pitch){
//                    Lvec = velocity
//                    Rvec = velocity * alpha
//                }
//                else if(pitch < 0){
//                    Lvec = velocity * alpha
//                    Rvec = velocity
//                }
//                let message = String(Int(Lvec)) + "," + String(Int(Rvec))
//                SendInputValue.self.send(message.data(using:.utf8)!)
//            }
//        }
//    }
//    // end of the getting data　YPR
//    func stop() {
//        if motionManager.isAccelerometerActive {
//            motionManager.stopAccelerometerUpdates()
//        }
//        if motionManager.isDeviceMotionActive{
//            motionManager.stopDeviceMotionUpdates()
//        }
//    }
//}
//
//
