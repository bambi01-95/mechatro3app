//
//  ReceiveClass.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/06/19.
//

import SwiftUI

import Network    // UDP
import CoreMotion // yaw pich roll
import Foundation // timer

class streamFrames : ObservableObject {
    @Published var img_data: Data = Data()
    var img_stock = Data()
    var img_previ = Data()
    var count     = 0
    
    var udpListener:NWListener?
    var backgroundQueueUdpListener   = DispatchQueue(label: "udp-lis.bg.queue", attributes: [])
    var backgroundQueueUdpConnection = DispatchQueue(label: "udp-con.bg.queue", attributes: [])
            
    var connections = [NWConnection]()
    func viewDidLoad() {
        startReceive(self)
    }
    
    
    func startReceive(_ sender: Any) {
        
        guard self.udpListener == nil else {
            print(" 🧨 Already listening. Not starting again")
            return
        }
        
        do {
            self.udpListener = try NWListener(using: .udp, on: 8080)// port
            self.udpListener?.stateUpdateHandler = { (listenerState) in
                
                switch listenerState {
                case .setup:
                    print("Listener: Setup")
                case .waiting(let error):
                    print("Listener: Waiting \(error)")
                case .ready:
                    print("Listener: Ready and listens on port: \(self.udpListener?.port?.debugDescription ?? "-")")
                case .failed(let error):
                    print("Listener: Failed \(error)")
                case .cancelled:
                    print("Listener: Cancelled by myOffButton")
                    for connection in self.connections {
                        connection.cancel()
                    }
                    self.udpListener = nil
                default:
                    break;
                }
            }
            
            self.udpListener?.start(queue: backgroundQueueUdpListener)
            self.udpListener?.newConnectionHandler = { (incomingUdpConnection) in

                print ("💁 New connection \(incomingUdpConnection.debugDescription)")
                
                incomingUdpConnection.stateUpdateHandler = { (udpConnectionState) in
                    switch udpConnectionState {
                    case .setup:
                        print("Connection: setup")
                    case .waiting(let error):
                        print("Connection: waiting: \(error)")
                    case .ready:
                        print("Connection: ready")
                        self.connections.append(incomingUdpConnection)
                        self.processData(incomingUdpConnection)
                    case .failed(let error):
                        print("Connection: failed: \(error)")
                        self.connections.removeAll(where: {incomingUdpConnection === $0})
                    case .cancelled:
                        print("Connection: cancelled")
                        self.connections.removeAll(where: {incomingUdpConnection === $0})
                    default:
                        break
                    }
                }

                incomingUdpConnection.start(queue: self.backgroundQueueUdpConnection)
            }
            
        } catch {
            print("🧨")
        }
    }
    
    
    func stopReceive(_ sender: Any) {
        udpListener?.cancel()
    }
    
  // 他のクラスで作る必要があるかもしれない
    func processData(_ incomingUdpConnection :NWConnection) {
        incomingUdpConnection.receiveMessage(completion: {(data, context, isComplete, error) in
        
            if let data = data, !data.isEmpty {
                if let string = String(data: data, encoding: .ascii) {
                    if(string == "__end__"){//encode data comparing
// MARK: 送信画像サイズを変えたら確認！
                        if(self.count == 16){
                            self.img_data = self.img_stock
                        }
                        self.img_stock = Data()
                        self.count = 0
                    }
                    else{
                        self.count += 1
                        self.img_stock.append(data)
//                        self.img_data = data // 一回の時
                    }
                }
            }

            if error == nil {
                self.processData(incomingUdpConnection)
            }
        })
        
    }
    
   
}


// MARK: Stream test View
struct ReceiveClass: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ReceiveClass_Previews: PreviewProvider {
    static var previews: some View {
        ReceiveClass()
    }
}
