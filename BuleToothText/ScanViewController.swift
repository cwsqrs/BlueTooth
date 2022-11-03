//
//  ScanViewController.swift
//  BuleToothText
//
//  Created by cw on 2022/10/26.
//  Copyright © 2022 TRY. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class ScanViewController: UIViewController {
    
    @objc var scanResultAction: ((ScanViewController, String) -> Void)?
    var code:String?
    //扫描相关变量
    var device:AVCaptureDevice?
    var input:AVCaptureDeviceInput?
    var outPut:AVCaptureMetadataOutput?
    var session:AVCaptureSession?
    var preview:AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "二维码扫描"
        initView()
        setupCamera()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async { [weak self] in
            if self?.session?.isRunning == false {
                self?.session?.startRunning()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DispatchQueue.main.async { [weak self] in
            if self?.session?.isRunning == true {
                self?.session?.stopRunning()
            }
        }
    }
    
    func initView() {
        let vScanFrame = ScanView()
        view.addSubview(vScanFrame)
        vScanFrame.snp.makeConstraints { (m) in
            m.center.equalTo(view)
            m.width.equalTo(SCREENWIDTH / 1.3)
            m.height.equalTo(170)
        }
    }

    func setupCamera() {
        device = AVCaptureDevice.default(for: AVMediaType.video)
        
        input = try? AVCaptureDeviceInput(device: device!)
        outPut = AVCaptureMetadataOutput()
        outPut?.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        session = AVCaptureSession()
        session?.sessionPreset = .high
        if input != nil && session!.canAddInput(input!) {
            session?.addInput(input!)
        }
        if session!.canAddOutput(outPut!) {
            session?.addOutput(outPut!)
        }
        outPut?.metadataObjectTypes = getMetadataObjectTypes()
        preview = AVCaptureVideoPreviewLayer(session: session!)
        preview?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        preview?.frame = CGRect(x: 0, y: 0, width: SCREENWIDTH, height: SCREENHEIGHT)
        view.layer.insertSublayer(preview!, at: 0)
        DispatchQueue.main.async { [weak self] in
            if self?.session?.isRunning == false {
                self?.session?.startRunning()
            }
        }
    }
    
   
    func getMetadataObjectTypes() -> [AVMetadataObject.ObjectType] {
        var arr = [AVMetadataObject.ObjectType]()
                                                                                                                                                          
        if outPut!.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.ean13) {
            arr.append(AVMetadataObject.ObjectType.ean13)
        }
        if outPut!.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.code39) {
            arr.append(AVMetadataObject.ObjectType.code39)
        }
        if outPut!.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.ean8) {
            arr.append(AVMetadataObject.ObjectType.ean8)
        }
        if outPut!.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.code128) {
            arr.append(AVMetadataObject.ObjectType.code128)
        }
        if outPut!.availableMetadataObjectTypes.contains(AVMetadataObject.ObjectType.qr) {
            arr.append(AVMetadataObject.ObjectType.qr)
        }
        if arr.count == 0 {
            
        }
        return arr
    }
}

extension ScanViewController:AVCaptureMetadataOutputObjectsDelegate {
    
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        session?.stopRunning()
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
        if let last = metadataObjects.last {
            let readableObject = last as! AVMetadataMachineReadableCodeObject
            if let str = readableObject.stringValue {
                print(str)
                navigationController?.popViewController(animated: true)
                scanResultAction?(self,str)
            } else {
                session?.startRunning()
            }
        } else {
            session?.startRunning()
        }
    }
}
class ScanView: UIView {
    let vMobile = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()
        let border = UIColor(red: 0.0, green: 159.0/255.0, blue: 223.0/255.0, alpha: 1)
        ctx?.setStrokeColor(border.cgColor)
        ctx?.setLineWidth(10)
        ctx?.move(to: CGPoint(x: 20, y: 0))
        ctx?.addLine(to: CGPoint(x: 0, y: 0))
        ctx?.addLine(to: CGPoint(x: 0, y: 20))

        ctx?.move(to: CGPoint(x: rect.size.width - 20, y: 0))
        ctx?.addLine(to: CGPoint(x: rect.size.width, y: 0))
        ctx?.addLine(to: CGPoint(x: rect.size.width, y: 20))
        
        ctx?.move(to: CGPoint(x: rect.size.width, y: rect.size.height - 20))
        ctx?.addLine(to: CGPoint(x: rect.size.width, y: rect.size.height))
        ctx?.addLine(to: CGPoint(x: rect.size.width - 20, y: rect.size.height))
        
        ctx?.move(to: CGPoint(x: 20, y: rect.size.height))
        ctx?.addLine(to: CGPoint(x: 0, y: rect.size.height ))
        ctx?.addLine(to: CGPoint(x: 0, y: rect.size.height - 20))
        ctx?.strokePath()
        ctx?.setStrokeColor(UIColor.red.cgColor)
        ctx?.setLineWidth(3)
        ctx?.move(to: CGPoint(x: 20, y: rect.size.height / 2))
        ctx?.addLine(to: CGPoint(x: rect.size.width - 20, y: rect.size.height / 2 ))

        
        ctx?.strokePath()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
