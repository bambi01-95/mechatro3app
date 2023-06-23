//
//  SendClass.swift
//  mechatro3
//
//  Created by Hiroto SHIKADA on 2023/06/19.
//

import SwiftUI
import Network    // UDP
import CoreMotion // yaw pich roll
import Foundation // timer



// MARK: SEND CLASS
class sendMessage: ObservableObject{
    @Published var message = "0,0,0,0"
    var connection: NWConnection? = nil
// MARK: ポート番号　ここに書く
    var host: NWEndpoint.Host = "192.168.0.31"
    var port: NWEndpoint.Port = 8008
    
    var timer :Timer?
    var count: Int = 0

    
    func startSend(){
        self.connect()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.println()
            self.send(self.message.data(using: .utf8)!)
        }
    }
    func println(){
        count += 1
        print(count)
    }
    func stopSend(){
        timer?.invalidate()
        self.disconnect()
    }
    
    // 参考URLと変更あり　connection！.send→　if conncition != nil && connection?.send(...
    func send(_ payload: Data) {
        if connection != nil {
            connection?.send(content: payload, completion: .contentProcessed({ sendError in
                if let error = sendError {
                    NSLog("Unable to process and send the data: \(error)")
                } else {
                    NSLog("Data has been sent")
                    self.connection!.receiveMessage { (data, context, isComplete, error) in
                        guard let myData = data else { return }
                        NSLog("Received message: " + String(decoding: myData, as: UTF8.self))
                        print(type(of: data))
                        
                    }
                }
            }))
        } else {
            NSLog("Connection is nil")
        }
    }
    
    func connect() {
        connection = NWConnection(host: host, port: port, using: .udp)
        
        connection!.stateUpdateHandler = { (newState) in
            switch (newState) {
            case .preparing:
                NSLog("Entered state: preparing")
            case .ready:
                NSLog("Entered state: ready")
            case .setup:
                NSLog("Entered state: setup")
            case .cancelled:
                NSLog("Entered state: cancelled")
            case .waiting:
                NSLog("Entered state: waiting")
            case .failed:
                NSLog("Entered state: failed")
            default:
                NSLog("Entered an unknown state")
            }
        }
        
        connection!.viabilityUpdateHandler = { (isViable) in
            if (isViable) {
                NSLog("Connection is viable")
            } else {
                NSLog("Connection is not viable")
            }
        }
        
        connection!.betterPathUpdateHandler = { (betterPathAvailable) in
            if (betterPathAvailable) {
                NSLog("A better path is availble")
            } else {
                NSLog("No better path is available")
            }
        }
        connection!.start(queue: .global())
    }
    
    func disconnect()
    {
        /* コネクション切断 */
        connection?.cancel()
    }
}


// MARK: sendtestView
struct SendClass: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct SendClass_Previews: PreviewProvider {
    static var previews: some View {
        SendClass()
    }
}
