import UIKit
import SceneKit
import AVFoundation
import CoreMotion

class AugmentedViewController: UIViewController {
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    var sceneView: SCNView!
    var mapScene: SCNScene!
    let motionManager = CMMotionManager()
    var cameraNode: SCNNode!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Cardinal.myInstance.addChildViewController(self)
        self.view.frame = Cardinal.myInstance.view.frame
        Cardinal.myInstance.view.addSubview(self.view)
        self.didMove(toParentViewController: Cardinal.myInstance)
        
        view.backgroundColor = UIColor.black
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let devices = AVCaptureDevice.devices()
        do {
            // Loop through all the capture devices on this phone
            for device in devices! {
                // Make sure this particular device supports video
                if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                    // Finally check the position and confirm we've got the back camera
                    if((device as AnyObject).position == AVCaptureDevicePosition.back) {
                        captureDevice = device as? AVCaptureDevice
                        if captureDevice != nil {
                            print("Capture device found")
                            try captureDevice?.lockForConfiguration()
                            beginSession()
                        }
                    }
                }
            }
        } catch {
        }
        
        if captureDevice == nil {
            self.close()
        }

        sceneView = SCNView(frame: view.frame)
        view.addSubview(sceneView)
        
        mapScene = SCNScene()
        mapScene.background.contents = UIColor.clear
        sceneView.scene = mapScene
        sceneView.autoenablesDefaultLighting = true
        
        let stuff = SCNSphere(radius: 3.20)
        stuff.firstMaterial!.diffuse.contents = UIColor.red
        stuff.firstMaterial!.specular.contents = UIColor.white
        let stuffNode = SCNNode(geometry: stuff)
        mapScene.rootNode.addChildNode(stuffNode)
        
        let camera = SCNCamera()
        camera.zNear = 1
        camera.zFar = 10000
        cameraNode = SCNNode()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 300)
        cameraNode.camera = camera
        mapScene.rootNode.addChildNode(cameraNode)

        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.017
           // motionManager.startDeviceMotionUpdates(to: .main, withHandler: deviceDidMove)
            motionManager.startDeviceMotionUpdates(
                to: OperationQueue.current!, withHandler: {
                    (deviceMotion, error) -> Void in
                    if let motion = deviceMotion {
                        
                        self.cameraNode.orientation = motion.gaze(atOrientation: UIApplication.shared.statusBarOrientation)
                    }
            })
            
            }
        
    }
    
    func deviceDidMove(motion: CMDeviceMotion?, error: NSError?) {
        
        if let motion = motion {
            
            cameraNode.orientation = motion.gaze(atOrientation: UIApplication.shared.statusBarOrientation)
        }
    }
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    func configureDevice() {
        if let device = captureDevice {
            //device.lockForConfiguration(nil)
            device.focusMode = .locked
            device.unlockForConfiguration()
        }
        
    }
    
    func beginSession() {
        
        configureDevice()
           do {
        try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        
        } catch {
            
        }
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.view.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
    
    func close() {
        DispatchQueue.main.async {
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        }
    }
}
