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
    
    var motionManager = CMMotionManager()
    var timer:Timer?
    let queue = OperationQueue()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        start()
    }

    func start() {
        motionManager.gyroUpdateInterval = 0.10
        motionManager.accelerometerUpdateInterval = 0.10
  
        motionManager.startDeviceMotionUpdates(to: queue) { (motion, error) in
            guard let motion = motion else { return }

            let gx = motion.gravity.x
            let gy = motion.gravity.y
            let gz = motion.gravity.z
            let ax = motion.userAcceleration.x
            let ay = motion.userAcceleration.y
            let az = motion.userAcceleration.z
            let rx = motion.rotationRate.x
            let ry = motion.rotationRate.y
            let rz = motion.rotationRate.z
            let pitch = motion.attitude.pitch
            let roll = motion.attitude.roll
            let yaw = motion.attitude.yaw
            
//            let sensorArray = [roll, pitch, yaw, gx, gy, gz, ax, ay, az, rx, ry, rz]
            DispatchQueue.main.async {
                self.label.text = "rpw: \(roll),\(pitch),\(yaw), g:\(gx),\(gy),\(gz), a:\(ax),\(ay),\(az), r:\(rx),\(ry),\(rz)"
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

