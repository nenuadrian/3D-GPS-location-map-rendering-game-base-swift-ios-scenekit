//
//  GUIMaster.swift
//  HW
//
//  Created by Adrian Nenu on 04/04/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import QRCode
import QRCodeReader
import AVFoundation

class TaskView: UIView {
    let task: Task
    init(task: Task) {
        self.task = task
        super.init(frame: CGRect(x: Int(UIScreen.main.bounds.width - 50), y: 50 * (GUIMaster.taskViews.count + 1), width: 30, height: 30))
        backgroundColor = UIColor.red
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GUIMaster: UIViewController, QRCodeReaderViewControllerDelegate {
    var world: UIViewController!
    static var taskViews: [TaskView] = []
    static var myInstance: GUIMaster!
    lazy var reader: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
            $0.showTorchButton = true
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()
    
    override func viewDidLoad() {
        GUIMaster.myInstance = self
        world = World3DViewController()
        addChildViewController(world)
        world.view.frame = self.view.frame
        view.addSubview(world.view)
        world.didMove(toParentViewController: self)
        
        let invButton = UIButton(frame: CGRect(x: 10, y: 600, width: 70, height:30))
        invButton.setTitle("inv", for: .normal)
        invButton.addTarget(self, action: #selector(inventory), for: .touchDown)
        view.addSubview(invButton)
        
        let craftButton = UIButton(frame: CGRect(x: 90, y: 600, width: 70, height:30))
        craftButton.setTitle("craft", for: .normal)
        craftButton.addTarget(self, action: #selector(craft), for: .touchDown)
        view.addSubview(craftButton)

        let appsButton = UIButton(frame: CGRect(x: 170, y: 600, width: 70, height:30))
        appsButton.setTitle("apps", for: .normal)
        appsButton.addTarget(self, action: #selector(apps), for: .touchDown)
        view.addSubview(appsButton)

        let qrButton = UIButton(frame: CGRect(x: 230, y: 600, width: 70, height:30))
        qrButton.setTitle("qr", for: .normal)
        qrButton.addTarget(self, action: #selector(qr), for: .touchDown)
        view.addSubview(qrButton)
        
        let myQrButton = UIButton(frame: CGRect(x: 260, y: 600, width: 70, height:30))
        myQrButton.setTitle("myqr", for: .normal)
        myQrButton.addTarget(self, action: #selector(myQr), for: .touchDown)
        view.addSubview(myQrButton)

        TasksManager.tasks.forEach({ GUIMaster.addTask(task: $0.value) })
    }
    
    static func addTask(task: Task) {
         DispatchQueue.main.async {
            taskViews.append(TaskView(task : task))
            myInstance.view.addSubview(taskViews.last!)
        }
    }
    
    static func removeTask(task: Task) {
        if let t = taskViews.first(where: { $0.task.id == task.id }) {
             DispatchQueue.main.async {
                t.removeFromSuperview()
                taskViews.remove(at: taskViews.index(where: { $0 == t })!)
            }

        }
    }
    
    @objc func qr() {
        scanAction()
    }
    
    @objc func myQr() {
        QRCodeInterface().show(data: "qrCode")
    }
    
    @objc func inventory() {
        InventoryInterface().show()
    }
    
    @objc func apps() {
        AppsInterface().show()
    }
    
    @objc func craft() {
       CraftInterface().show()
    }
    
    static func homebase() {
        HomebaseInterface().show()
    }
    
    static func homebaseInstallApp() {
        HomebaseInstallInterface().show()
    }
    
    static func npc(npc: NPC) {
        NPCInterface().show(npc: npc)
    }
    
    static func formula(formula: CraftFormula) {
        FormulaInterface().show(formula: formula)
    }
    
    static func drop(data: JSON) {
        DispatchQueue.main.async {
            DropInterface().show(items: data)
        }
    }
    
    func scanAction() {
        do {
            if try QRCodeReader.supportsMetadataObjectTypes() {
                reader.modalPresentationStyle = .formSheet
                reader.delegate               = self
                
                reader.completionBlock = { (result: QRCodeReaderResult?) in
                    if let result = result {
                        print("Completion with result: \(result.value) of type \(result.metadataType)")
                    }
                }
                
                present(reader, animated: true, completion: nil)
            }
        } catch let error as NSError {
            switch error.code {
            case -11852:
                let alert = UIAlertController(title: "Error", message: "This app is not authorized to use Back Camera.", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Setting", style: .default, handler: { (_) in
                    DispatchQueue.main.async {
                        if let settingsURL = URL(string: UIApplicationOpenSettingsURLString) {
                            UIApplication.shared.openURL(settingsURL)
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
                
                
                
            case -11814:
                let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                present(alert, animated: true, completion: nil)
            default:()
            }
        }
        
    }
    
    // MARK: - QRCodeReader Delegate Methods
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        
        dismiss(animated: true) { [weak self] in
            let alert = UIAlertController(
                title: "QRCodeReader",
                message: String (format:"%@ (of type %@)", result.value, result.metadataType),
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func reader(_ reader: QRCodeReaderViewController, didSwitchCamera newCaptureDevice: AVCaptureDeviceInput) {
        if let cameraName = newCaptureDevice.device.localizedName {
            print("Switching capturing to: \(cameraName)")
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
}

