//
//  ViewController.swift
//  FallDetector
//
//  Created by Aijaz Ansari on 4/19/23.
//

import UIKit
import CoreMotion
import Starscream


class ViewController: UIViewController, WebSocketDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    
    var motionManager = CMMotionManager()
    var timer:Timer?
    let queue = OperationQueue()
    var started = false
    var socket: WebSocket?
    var isConnected = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refresh()
    }
    
    func startSocket() {
        var request = URLRequest(url: URL(string: "http://\(self.textField.text ?? ""):8080")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket!.delegate = self
        socket!.connect()
    }
    
    func refresh() {
        if started {
            self.button.setTitle("Stop", for: .normal)
        }
        else {
            self.button.setTitle("Start", for: .normal)
        }
    }

    @IBAction func handleStopStart(_ sender: Any) {
        if started {
            motionManager.stopDeviceMotionUpdates()
            if isConnected {
                socket?.disconnect()
                socket = nil
            }
        }
        else {
            socket?.connect()
            start()
        }
        started = !started
        refresh()
    }
    
    func start() {
        motionManager.gyroUpdateInterval = 0.10
        motionManager.accelerometerUpdateInterval = 0.10
        
        motionManager.startDeviceMotionUpdates(to: queue) { (motion, error) in
            guard let motion = motion else { return }
            
            let gx = String(format: "%0.2f", motion.gravity.x)
            let gy = String(format: "%0.2f", motion.gravity.y)
            let gz = String(format: "%0.2f", motion.gravity.z)
            let ax = String(format: "%0.2f", motion.userAcceleration.x)
            let ay = String(format: "%0.2f", motion.userAcceleration.y)
            let az = String(format: "%0.2f", motion.userAcceleration.z)
            let rx = String(format: "%0.2f", motion.rotationRate.x)
            let ry = String(format: "%0.2f", motion.rotationRate.y)
            let rz = String(format: "%0.2f", motion.rotationRate.z)
            let pitch = String(format: "%0.2f", motion.attitude.pitch)
            let roll = String(format: "%0.2f", motion.attitude.roll)
            let yaw = String(format: "%0.2f", motion.attitude.yaw)
            
            DispatchQueue.main.async {
                self.label.text = "rpw: \(roll),\(pitch),\(yaw)\n g:\(gx),\(gy),\(gz)\na:\(ax),\(ay),\(az)\n r:\(rx),\(ry),\(rz)"
            }
            if self.isConnected {
                self.socket!.write(string: "\(pitch),\(roll),\(yaw),\(gx),\(gy),\(gz),\(ax),\(ay),\(az),\(rx),\(ry),\(rz)")
            }
        }
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .connected(let headers):
            isConnected = true
            print("websocket is connected: \(headers)")
        case .disconnected(let reason, let code):
            isConnected = false
            print("websocket is disconnected: \(reason) with code: \(code)")
        case .text(let string):
            print("Received text: \(string)")
        case .binary(let data):
            print("Received data: \(data.count)")
        case .ping(_):
            break
        case .pong(_):
            break
        case .viabilityChanged(_):
            break
        case .reconnectSuggested(_):
            break
        case .cancelled:
            isConnected = false
        case .error(let error):
            isConnected = false
            print("Error: \(String(describing: error))")
        }
    }

}

