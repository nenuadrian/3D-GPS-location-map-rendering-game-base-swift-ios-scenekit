import UIKit
import SceneKit
import AVFoundation
import CoreMotion
import QRCodeReader
import AVFoundation

class QRReadViewController: UIViewController, QRCodeReaderViewControllerDelegate {
    lazy var reader: QRCodeReaderViewController = {
        let builder = QRCodeReaderViewControllerBuilder {
            $0.reader = QRCodeReader(metadataObjectTypes: [AVMetadataObjectTypeQRCode], captureDevicePosition: .back)
            $0.showTorchButton = true
        }
        
        return QRCodeReaderViewController(builder: builder)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black

        scanAction()
    }
       
    func scanAction() {
        do {
            if try QRCodeReader.supportsMetadataObjectTypes() {
                reader.modalPresentationStyle = .formSheet
                reader.delegate               = self
                present(reader, animated: true, completion: nil)
            }
        } catch _ as NSError {
            close()
        }
        
    }
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        reader.stopScanning()
        Logging.info(data: String (format:"%@ (of type %@)", result.value, result.metadataType))
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        reader.stopScanning()
        
        dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        close()
    }
    
    func close() {
        DispatchQueue.main.async {
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            self.dismiss(animated: true, completion: {})
        }
    }
}
