//
//  stickcont_f.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/07/16.
//

// this is a stock of the...

import SwiftUI

struct stickcont_f: View {

    @State var Lvec = 0.0
    @State var Rvec = 0.0
    
    @State var position: CGSize = CGSize(width: 100, height: 200)
    @State var arm: Int = 0
    @State var camera: Int = 0
    //buttonを掴んでいるかいないか
    @State var grab:Bool = false
    
    @State var locx:CGFloat = 0
    @State var locy:CGFloat = 0
    let c_range: Double = 50 //range of control button
    
    // dragの動きの定義
    var drag: some Gesture {
        DragGesture()
            .onChanged{ value in
                // ボタンの触れた初期位置
                let startx = value.startLocation.x
                let starty = value.startLocation.y
                // ボタンの初期位置から の 移動距離
                let transx = value.translation.width
                let transy = value.translation.height
                
                // ボタンが範囲を超えた時
                if(hypotenuse(transx,transy) > sqrt(c_range * c_range)){
                    //接触している位置の角度
                    let radian = atan2(transx,transy)
                    locx = CGFloat(Int(c_range)) * sin(radian)
                    locy = CGFloat(Int(c_range)) * cos(radian)
                    self.position = CGSize(width: startx + locx, height: starty + locy)
                }
                else{// 範囲内
                    self.position = CGSize(
                        width:  startx + transx,
                        height: starty + transy
                    )
                    locx = transx
                    locy = transy
                }
            }//話した時のの動作 初期位置に戻す
        
            .onEnded{ value in
                locx = 0
                locy = 0
            }
    }
    
    // MARK: VIEW
    var body: some View {
        let bounds = UIScreen.main.bounds
        let Swidth  = bounds.width
        let Sheight = bounds.height
        
        ZStack{
            // 背景（ストリーミング画像の挿入場所）
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
            
            VStack{
                Text("L\(Lvec) R:\(Rvec)")
                    .offset(y:-Sheight/2 + 30)
            }
            
            // MARK: home button
            VStack{
                Button {
//                    page = .home
//                    home = true
                } label: {
                    Image("home")
                        .resizable()
                        .frame(width: 70,height: 50)
                        .shadow(radius: 5)
                }
            }.offset(x:-Swidth / 2 + 50 ,y:-Sheight / 2 + 50)
            
            // MARK: controller button L
            ZStack{
                // コントローラーの範囲視覚化
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 180, height: 180)
                    .foregroundColor(Color.blue)
                    .offset(x: -Swidth / 3)
                    .opacity(0.06)
                // 左のコントロールボタン
                Image("stick_button")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .opacity(grab == true ? 1 : 0.8)
                    .offset(x: -Swidth / 3 + locx,y: locy)
                    .gesture(drag)
                    .shadow(color: .black, radius: 5)
            }

            
            
        
            // MARK: controller button R
            VStack{
                //上ボタン
                
                //.position(x:10,y:40)
                Button {
                    print("top")
                } label: {
                    Image("red_button2")
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
                        Image("yellow_button2")
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
                        Image("blue_button2")
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
                    Image("green_button2")
                        .resizable()
                        .frame(width: 70, height: 70)
                        .foregroundColor(Color.black)
                }
                .shadow(color: .black, radius: 5)
            }.offset(x:Swidth / 3)
            
        }
        .onAppear{
//            print("sns")
//            startSend()
        }
        .onDisappear{
            print("ens")
//            stopSend()
            //            home = true
        }
    }
    
    
    
    // MARK: functions
    //sqrt(a,b)
    func hypotenuse(_ a: Double, _ b: Double) -> Double {
        return (a * a + b * b).squareRoot()
    }
    func ConvertMessage() -> String {
        let r = hypotenuse(locx,locy)
        let alpha = atan2(locy,abs(locx)) / (Double.pi / 2)
        if(locx > 0){
            Lvec = r
            Rvec = abs(r * alpha)
        }
        else if(locx < 0){
            Lvec = abs(r * alpha)
            Rvec = r
        }
        else if(locy > 45){
            Lvec = 50
            Rvec = 50
        }
        else{
            Lvec = 0.0
            Rvec = 0.0
        }
        let message:String = String(Int(Lvec)) + "," + String(Int(Rvec)) + "now"
        return message
    }
//    func startSend(){
//        SendInputValue.self.connect()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
//            //            println()
//            let message:String = ConvertMessage()
//            SendInputValue.self.send(message.data(using:.utf8)!)
//        }
//    }
//    func println(){
//        count += 1
//        print(count)
//    }
//    func stopSend(){
//        timer?.invalidate()
//        SendInputValue.self.disconnect()
//    }
}

struct stickcont_f_Previews: PreviewProvider {
    static var previews: some View {
        stickcont_f()
    }
}














// MARK: Special_stick 2023/07/17
//
//  SpecialStickView.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/06/19.
//
//
//import SwiftUI
//
//struct SpecialStickView: View {
//    @Binding var page:Pagetype
//    @Binding var home:Bool
//
//    // MARK: for main
//    @ObservedObject var Stream = streamFrames()
//    @ObservedObject var SendInputValue:sendMessage
//
//    @State var timer :Timer?
//    @State var count: Int = 0
//
//    @State var Lvec = 0.0
//    @State var Rvec = 0.0
//
//    @State var position: CGSize = CGSize(width: 100, height: 300)
//    @State var arm: Int = 0
//    @State var camera: Int = 0
//
//    //buttonを掴んでいるかいないか
//    @State var grab:Bool = false
//
//    @State var locx:CGFloat = 0
//    @State var locy:CGFloat = 0
//    let c_range: Double = 50 //range of control button
//
//    // dragの動きの定義
//    var drag: some Gesture {
//        DragGesture()
//            .onChanged{ value in
//                // ボタンの触れた初期位置
//                let startx = value.startLocation.x
//                let starty = value.startLocation.y
//                // ボタンの初期位置から の 移動距離
//                let transx = value.translation.width
//                let transy = value.translation.height
//
//                // ボタンが範囲を超えた時
//                if(hypotenuse(transx,transy) > sqrt(c_range * c_range)){
//                    //接触している位置の角度
//                    let radian = atan2(transx,transy)
//                    locx = CGFloat(Int(c_range)) * sin(radian)
//                    locy = CGFloat(Int(c_range)) * cos(radian)
//                    self.position = CGSize(width: startx + locx, height: starty + locy)
//                }
//                else{// 範囲内
//                    self.position = CGSize(
//                        width:  startx + transx,
//                        height: starty + transy
//                    )
//                    locx = transx
//                    locy = transy
//                }
//            }//話した時のの動作 初期位置に戻す
//
//            .onEnded{ value in
//                locx = 0
//                locy = 0
//            }
//    }
//
//    // MARK: VIEW
//    var body: some View {
//        let bounds = UIScreen.main.bounds
//        let Swidth  = bounds.width
//        let Sheight = bounds.height
//
//        ZStack{
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
//            // 背景（ストリーミング画像の挿入場所）
//            // MARK: background
//            Group{
//                if let uiImage = UIImage(data: Stream.img_data) {
//                    Image(uiImage: uiImage)
//                        .resizable()
//                        .frame(width: 600, height: 600)
//                        .padding(.top,20)
//                }
//                else{
//                    Image("back_gray")
//                        .resizable()
//                        .frame(width: 600, height: 600)
//                        .padding(.top,20)
//                        .opacity(0.1)
//                }
//
//            }
//            VStack{
//                Text("L\(Lvec) R:\(Rvec)")
//                    .offset(y:-Sheight/2 + 30)
//            }
//
//
//            // MARK: home button
//            VStack{
//                Button {
//                    page = .home
//                    home = true
//                } label: {
//                    Image("home")
//                        .resizable()
//                        .frame(width: 70,height: 50)
//                }// MARK: 修正が必要
//            }.offset(x:-Swidth / 2 + 50 ,y:-Sheight / 2 + 50)
//
//            // MARK: controller button L
//            ZStack{
//                // コントローラーの範囲視覚化
//                Image(systemName: "circle.fill")
//                    .resizable()
//                    .frame(width: 180, height: 180)
//                    .foregroundColor(Color.blue)
//                    .offset(x: -Swidth / 3)
//                    .opacity(0.06)
//
//                // 左のコントロールボタン
//                Image("stick_button")
//                    .resizable()
//                    .frame(width: 70, height: 70)
//                    .opacity(grab == true ? 1 : 0.8)
//                    .offset(x: -Swidth / 3 + locx,y: locy)
//                    .gesture(drag)
//                    .shadow(color: .black, radius: 5)
//            }
//
//
//
//
//            // MARK: controller button R
//            VStack{
//                //上ボタン
//
//                //.position(x:10,y:40)
//                Button {
//                    print("top")
//                } label: {
//                    Image("red_button2")
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
//                        Image("yellow_button2")
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
//                        Image("blue_button2")
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
//                    Image("green_button2")
//                        .resizable()
//                        .frame(width: 70, height: 70)
//                        .foregroundColor(Color.black)
//                }
//                .shadow(color: .black, radius: 5)
//            }.offset(x:Swidth / 3)
//
//
//
//        }
//        .onAppear{
//            print("sss")
//            Stream.self.startReceive(0)
//            startSend()
//        }
//        .onDisappear{
//            print("ess")
//            Stream.self.stopReceive(0)
//            stopSend()
//        }
//    }
//
//
//
//    // MARK: functions
//    //sqrt(a,b)
//    func hypotenuse(_ a: Double, _ b: Double) -> Double {
//        return (a * a + b * b).squareRoot()
//    }
//    func ConvertMessage() -> String {
//        let r = hypotenuse(locx,locy)
//        let alpha = atan2(locy,abs(locx)) / (Double.pi / 2)
//        if(locx > 0){
//            Lvec = r
//            Rvec = abs(r * alpha)
//        }
//        else if(locx < 0){
//            Lvec = abs(r * alpha)
//            Rvec = r
//        }
//        else if(locy > 45){
//            Lvec = 50
//            Rvec = 50
//        }
//        else{
//            Lvec = 0.0
//            Rvec = 0.0
//        }
//        let message:String = String(Int(Lvec)) + "," + String(Int(Rvec)) + "now"
//        return message
//    }
//    func startSend(){
//        SendInputValue.self.connect()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
////            println()
//            let message:String = ConvertMessage()
//            SendInputValue.self.send(message.data(using:.utf8)!)
//        }
//    }
//    func println(){
//        count += 1
//        print(count)
//    }
//    func stopSend(){
//        timer?.invalidate()
//        SendInputValue.self.disconnect()
//    }
//}









// MARK: premium_Stick 2023/07/17
//
//  PremiumStick.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/07/07.
//

//import SwiftUI
//
//struct PremiumStick: View {
//    @Binding var page:Pagetype
//    @Binding var home:Bool
//    @ObservedObject var SendInputValue: sendMessage //edit
//
//    // TODO: 変数をまとめろ！
//    @State var timer :Timer?
//    @State var count: Int = 0
//
//    @State var Lvec = 0.0
//    @State var Rvec = 0.0
//
//    @State var position: CGSize = CGSize(width: 100, height: 300)
//    @State var arm: Int = 0
//    @State var camera: Int = 0
//
//    //buttonを掴んでいるかいないか
//    @State var grab:Bool = false
//
//    @State var locx:CGFloat = 0
//    @State var locy:CGFloat = 0
//    let c_range: Double = 50 //range of control button
//
//    // dragの動きの定義
//    var drag: some Gesture {
//        DragGesture()
//            .onChanged{ value in
//                // ボタンの触れた初期位置
//                let startx = value.startLocation.x
//                let starty = value.startLocation.y
//                // ボタンの初期位置から の 移動距離
//                let transx = value.translation.width
//                let transy = value.translation.height
//
//                // ボタンが範囲を超えた時
//                if(hypotenuse(transx,transy) > sqrt(c_range * c_range)){
//                    //接触している位置の角度
//                    let radian = atan2(transx,transy)
//                    locx = CGFloat(Int(c_range)) * sin(radian)
//                    locy = CGFloat(Int(c_range)) * cos(radian)
//                    self.position = CGSize(width: startx + locx, height: starty + locy)
//                }
//                else{// 範囲内
//                    self.position = CGSize(
//                        width:  startx + transx,
//                        height: starty + transy
//                    )
//                    locx = transx
//                    locy = transy
//                }
//            }//話した時のの動作 初期位置に戻す
//
//            .onEnded{ value in
//                locx = 0
//                locy = 0
//            }
//    }
//
//    var body: some View {
//        let bounds = UIScreen.main.bounds
//        let Sheight = bounds.height
//        let Swidth = bounds.width
//
//        ZStack{
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
//            // MARK: Stream
//            WebView(loardUrl: URL(string: "http://" + SendInputValue.hoststr + ":8000/stream/")!)// edit
//                .frame(width: 800, height: 400)
//                .offset(x:-10)
////            Text("\(Sheight)hw\(Swidth)")
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
//            // MARK: controller button L
//            ZStack{
//                // コントローラーの範囲視覚化
//                Image(systemName: "circle.fill")
//                    .resizable()
//                    .frame(width: 180, height: 180)
//                    .foregroundColor(Color.blue)
//                    .offset(x: -Swidth / 3)
//                    .opacity(0.06)
//
//                // 左のコントロールボタン
//                Image("stick_button")
//                    .resizable()
//                    .frame(width: 70, height: 70)
//                    .opacity(grab == true ? 1 : 0.8)
//                    .offset(x: -Swidth / 3 + locx,y: locy)
//                    .gesture(drag)
//                    .shadow(color: .black, radius: 5)
//            }
//
//
//
//
//            // MARK: controller button R
//            VStack{
//                //上ボタン
//
//                //.position(x:10,y:40)
//                Button {
//                    print("top")
//                } label: {
//                    Image("red_button2")
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
//                        Image("yellow_button2")
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
//                        Image("blue_button2")
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
//                    Image("green_button2")
//                        .resizable()
//                        .frame(width: 70, height: 70)
//                        .foregroundColor(Color.black)
//                }
//                .shadow(color: .black, radius: 5)
//            }.offset(x:Swidth / 3)
//        }
//        .onAppear{
//            print("sss")
//            startSend()
//        }
//        .onDisappear{
//            print("ess")
//            stopSend()
//        }
//
//    }
//
//    // MARK: functions
//    //sqrt(a,b)
//    func hypotenuse(_ a: Double, _ b: Double) -> Double {
//        return (a * a + b * b).squareRoot()
//    }
//    func ConvertMessage() -> String {
//        let r = hypotenuse(locx,locy)
//        let alpha = atan2(locy,abs(locx)) / (Double.pi / 2)
//        if(locx > 0){
//            Lvec = r
//            Rvec = abs(r * alpha)
//        }
//        else if(locx < 0){
//            Lvec = abs(r * alpha)
//            Rvec = r
//        }
//        else if(locy > 45){
//            Lvec = 50
//            Rvec = 50
//        }
//        else{
//            Lvec = 0.0
//            Rvec = 0.0
//        }
//        let message:String = String(Int(Lvec)) + "," + String(Int(Rvec)) + "now"
//        return message
//    }
//    func startSend(){
//        SendInputValue.self.connect()
//        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
////            println()
//            let message:String = ConvertMessage()
//            SendInputValue.self.send(message.data(using:.utf8)!)
//        }
//    }
//    func println(){
//        count += 1
//        print(count)
//    }
//    func stopSend(){
//        timer?.invalidate()
//        SendInputValue.self.disconnect()
//    }
//
//}
//
//
//Rectangle()
//    .fill(Color.blue)
//    .frame(width: Sheight * 2, height: Sheight)
///* https://swifty-ui.com/wkwebview/ */
//WebView(loardUrl: URL(string: "http://127.0.0.1:8000/vr/")!)
//    .frame(width: Sheight * 2, height: Sheight)
