//
//  ViewController.swift
//  FallDetector
//
//  Created by Aijaz Ansari on 4/19/23.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    
    var motionManager = CMMotionManager()
    var timer:Timer?
    let queue = OperationQueue()
    var started = false

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        refresh()
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
        }
        else {
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

//            let sensorArray = [roll, pitch, yaw, gx, gy, gz, ax, ay, az, rx, ry, rz]
            DispatchQueue.main.async {
                self.label.text = "rpw: \(roll),\(pitch),\(yaw)\n g:\(gx),\(gy),\(gz)\na:\(ax),\(ay),\(az)\n r:\(rx),\(ry),\(rz)"
            }
        }


//        motionManager.startGyroUpdates(to: .current!) { (data, error) in
//            if let data = data {
//                print(data)
//                if let accelerometerData = self.motionManager.accelerometerData {
//                }
//            }
//        }
//
//        motionManager.startAccelerometerUpdates(to: .current!) { (data, error) in
//            if let data = data {
//                print(data)
//                if let accelerometerData = self.motionManager.accelerometerData {
//                }
//            }
//        }
    }
    
//    func handleData(data: CMDeviceMotion) {
//        // Get the attitude relative to the magnetic north reference frame.
//        let x = data.attitude.pitch
//        let y = data.attitude.roll
//        let z = data.attitude.yaw
//
//        // Use the motion data in your app.
//
//    }
    
//    func startDeviceMotion() {
//        if motionManager.isDeviceMotionAvailable {
//            let interval = 1.0/60.0
//            self.motionManager.deviceMotionUpdateInterval = interval
//            self.motionManager.showsDeviceMovementDisplay = true
//            self.motionManager.startDeviceMotionUpdates(using: .xMagneticNorthZVertical)
//
//            // Configure a timer to fetch the motion data.
//            self.timer = Timer(fire: Date(), interval: interval, repeats: true,
//                               block: { timer in
//                                if let data = self.motion.deviceMotion {
//                                    handleData(data: data)
//                                }
//            })
//
//            // Add the timer to the current run loop.
//            RunLoop.current.add(self.timer!, forMode: RunLoop.Mode.default)
//        }
//    }


}

