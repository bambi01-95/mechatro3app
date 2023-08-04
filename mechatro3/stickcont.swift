//
//  stickcont.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/07/15.
//

import SwiftUI

struct stickcont: View {

    
    @State var spd = 0
    @State var Lvec = 0
    @State var Rvec = 0
    @State var Mode = "CLOSE MODE"
    
    @State var position: CGSize = CGSize(width: 100, height: 200)
    @State var grab:Bool = false
    
    @State var locx:CGFloat = 0
    @State var locy:CGFloat = 0
    let c_range: Double = 50 //range of control button
    

    @State var arm1Locy:CGFloat = 0
    @State var arm1Data:String = "00"//fr
    
    @State var arm2Locy:CGFloat = 0
    @State var arm2Data:String = "00"//ij
    
    @State var spdLocy:CGFloat = 0
    @State var modeLocy:CGFloat = 0
    
    
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
                grab = true
                calcStick()
            }//話した時のの動作 初期位置に戻す
            .onEnded{ value in
                grab = false
                locx = 0
                locy = 0
                Lvec = 0
                Rvec = 0
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
            
            // MARK: display strieaming img here
            
            // MARK: text display
            VStack{
                    Text("[\(Mode)]\(spd) spd (\(Lvec):\(Rvec))")
                        .font(.system(size: 20, weight: .black, design: .default))
            }.offset(y:Sheight / 2 - 40)
            
            // MARK: home button
            VStack{
                Button {

                } label: {
                    Image("home")
                        .resizable()
                        .frame(width: 70,height: 50)
                        .shadow(radius: 5)
                }
            }.offset(x:-Swidth / 2 + 50 ,y:-Sheight / 2 + 50)
            
            // MARK: controller button L
            HStack{
                // MARK: controll
                ZStack{
                    // コントローラーの範囲視覚化
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 180, height: 180)
                        .foregroundColor(Color.blue)
                        .offset()
                        .opacity(0.2)
                    // 左のコントロールボタン
                    Image("stick_button_g")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .opacity(grab == true ? 1 : 0.5)
                        .offset(x:locx,y: locy)
                        .gesture(drag)
                        .shadow(color: .black, radius: 5)
                }
                //MARK: arm1
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
            }.offset(x: -Swidth / 4 - 50)

            

            
        
            // MARK: arm2
            HStack{
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
            }.offset(x:Swidth / 4 + 50)


            
        }
        .onAppear{

        }
        .onDisappear{

        }
    }
    func hypotenuse(_ a: Double, _ b: Double) -> Double {
        return (a * a + b * b).squareRoot()
    }
    
    func calcStick(){
        if(abs(locy) < 25) && (abs(locx) > 10){
            Lvec = (locx < 0) ? spd : -spd
            Rvec = (locx < 0) ? -spd : spd
        }
        else if(locy > 0){
            if(locx > 0){
                Lvec = -spd
                Rvec = -spd * (47 - Int(abs(locx))) / 47
            }
            else{
                Lvec = -spd * (47 - Int(abs(locx))) / 47
                Rvec = -spd
            }
        }
        else if(locy < 0){
            if(locx > 0){
                Lvec = spd
                Rvec = spd * (47 - Int(abs(locx))) / 47
            }
            else{
                Lvec = spd * (47 - Int(abs(locx))) / 47
                Rvec = spd
            }
        }
        else{
            Lvec = 0
            Rvec = 0
        }
        if(Mode == "OPEN MODE"){
            let stock = Lvec
            Lvec = -1 * Rvec
            Rvec = -1 * stock
        }
    }
    // send function here
//    let message = String(Lvec)+","+String(Rvec)+","+arm1Data+","+arm2Data
    //SendInputValue.self.send(message.data(using:.utf8)!)
}

struct stickcont_Previews: PreviewProvider {
    static var previews: some View {
        stickcont()
    }
}
