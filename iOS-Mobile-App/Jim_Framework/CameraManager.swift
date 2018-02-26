//
//  CameraManager.swift
//  OneShare
//
//  Created by James on 2/19/18.
//  Copyright © 2018 James Layton. All rights reserved.
//

import UIKit
import AVFoundation

protocol CameraManagerDataDelegate {
    func outputWith(image: UIImage?)
}

enum CameraQuality {
    case photo
    case high
    case medium
    case low
}

class CameraManager: NSObject {
    /* Singleton */
    static let shared = CameraManager()
    private override init(){}
    //////////
    
    /* CameraManager Delegate */
    var dataDelegate: CameraManagerDataDelegate?
    
    var captureSession: AVCaptureSession?
    
    /* AVCaptureDevice References */
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var defaultCamera: AVCaptureDevice?
    
    var photoOutput: AVCapturePhotoOutput?
    
    var previewLayer: AVCaptureVideoPreviewLayer?
}

//MARK: - Configuration
extension CameraManager {
    /* Configure the session and assign delegate
     * Param: delegate or the viewcontroller who will implement the protocol
     */
    func configSession(delegate: UIViewController, quality: CameraQuality) {
        self.dataDelegate = delegate as? CameraManagerDataDelegate
        self.captureSession = AVCaptureSession()
        
        switch quality {
        case .photo:
            self.captureSession?.sessionPreset = .photo
            break
        case .high:
            self.captureSession?.sessionPreset = .high
            break
        case .medium:
            self.captureSession?.sessionPreset = .medium
            break
        case .low:
            self.captureSession?.sessionPreset = .low
            break
        }
    }
    
    /* Configure the camera device, audio device will be add in the future */
    func configDevice() {
        let deviceDiscovery = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscovery.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                self.backCamera = device
            }
            else if device.position == AVCaptureDevice.Position.front {
                self.frontCamera = device
            }
        }
        
        self.defaultCamera = backCamera
    }
    
    /* Configure session input and output devices */
    func configInputOutput() {
        if self.captureSession?.isRunning == true {
            return
        }
        
        guard let realTimeCamera = self.defaultCamera else {
            print("ERROR: There is no camera to use")
            return
        }
        
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: realTimeCamera)
            self.captureSession?.addInput(captureDeviceInput)
            self.photoOutput = AVCapturePhotoOutput()
            self.photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings.init(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
            self.captureSession?.addOutput(self.photoOutput!)
        } catch {
            print(error)
        }
    }
    
    /* Configure the camera preview layer to show the camera view
     * Param: the view to insert camera layer
     */
    func configPreviewLayer(view: UIView) {
        
        guard let session = self.captureSession else {
            print("ERROR: Capture session failed")
            return
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
        self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.previewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.previewLayer?.frame = view.frame
        
        guard let previewLayer = self.previewLayer else {
            print("ERROR: Failed to generate preview layer")
            return
        }
        
        view.layer.insertSublayer(previewLayer, at: 0)
    }
}

//MARK: - Camera Methods
extension CameraManager {
    /* Start the camera session */
    func startSession() {
        if self.captureSession?.isRunning == true {
            return
        }
        
        self.captureSession?.startRunning()
    }
    
    /* Stop the camera session */
    func stopSession() {
        self.captureSession?.stopRunning()
        self.previewLayer?.removeFromSuperlayer()
        self.previewLayer = nil
        self.captureSession = nil
    }
    
    /* Pause the layer to receive device camera data */
    func pauseCamera() {
        self.previewLayer?.connection?.isEnabled = false
    }
    
    /* Resume the layer to receive device camera data */
    func resumeCamera() {
        self.previewLayer?.connection?.isEnabled = true
    }
    
    /* Take a photo with the camera */
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
    }
    
    /* Check the camera authentication */
    func checkAuthentication(completion: @escaping (Bool)->()) {
        if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
            completion(true)
        } else {
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    completion(true)
                } else {
                    completion(false)
                }
            })
        }
    }
    
    /* Switch front and back camera */
    func changeCameraPosition() {
        var newDevice: AVCaptureDevice!
        
        guard let session = self.captureSession else {
            print("ERROR: Failed to retrieve capture session")
            return
        }
        
        session.beginConfiguration()
        
        if self.defaultCamera?.position == .back {
            newDevice = self.frontCamera!
        }
        else if self.defaultCamera?.position == .front {
            newDevice = self.backCamera!
        }
        
        for input in session.inputs {
            self.captureSession?.removeInput(input as! AVCaptureDeviceInput)
        }
        
        let cameraInput: AVCaptureDeviceInput
        do {
            cameraInput = try AVCaptureDeviceInput(device: newDevice)
        } catch let error {
            print("ERROR: Failed to get the camera input device for position ", error)
            return
        }
        
        if session.canAddInput(cameraInput) {
            session.addInput(cameraInput)
        }
        
        self.defaultCamera = newDevice
        
        session.commitConfiguration()
    }
    
    /* Focus the camera when user tap the screen */
    func focusCamera(focusPoint: CGPoint, shapeColor: UIColor) {
        guard let cameraDevice = self.defaultCamera else {
            print("ERROR: Failed to retrieve current camera device")
            return
        }
        
        let layerPoint = self.previewLayer?.captureDevicePointConverted(fromLayerPoint: focusPoint)
        self.drawFocusShape(point: focusPoint, color: shapeColor)
        
        do {
            try cameraDevice.lockForConfiguration()
            
            if self.defaultCamera?.position == .back {
                self.focus(cameraDevice: cameraDevice, focusPoint: layerPoint!)
                self.exposure(cameraDevice: cameraDevice, exposurePoint: layerPoint!)
            }
            else if self.defaultCamera?.position == .front {
                self.exposure(cameraDevice: cameraDevice, exposurePoint: layerPoint!)
            }
            
            cameraDevice.isSubjectAreaChangeMonitoringEnabled = false
            
            cameraDevice.unlockForConfiguration()
            
        } catch let error {
            print("ERROR: Failed to configure the current camera device ", error)
            return
        }
    }
    
    private func focus(cameraDevice: AVCaptureDevice, focusPoint: CGPoint) {
        if cameraDevice.isFocusPointOfInterestSupported == true && cameraDevice.isFocusModeSupported(.continuousAutoFocus) {
            cameraDevice.focusPointOfInterest = focusPoint
            cameraDevice.focusMode = .continuousAutoFocus
            if cameraDevice.isSmoothAutoFocusSupported == true {
                cameraDevice.isSmoothAutoFocusEnabled = true
            }
        }
        else {
            print("ERROR: Device not support focus of point interest")
        }
    }
    
    private func exposure(cameraDevice: AVCaptureDevice, exposurePoint: CGPoint) {
        if cameraDevice.isExposurePointOfInterestSupported == true && cameraDevice.isExposureModeSupported(.continuousAutoExposure) {
            cameraDevice.exposurePointOfInterest = exposurePoint
            cameraDevice.exposureMode = .continuousAutoExposure
        }
        else {
            print("ERROR: Device not support exposure of point interest")
        }
    }
    
    private func drawFocusShape(point: CGPoint, color: UIColor) {
        let circlePath = UIBezierPath(arcCenter: point, radius: CGFloat(30), startAngle: CGFloat(0), endAngle:CGFloat(CGFloat.pi * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = 2.0
        
        self.previewLayer?.addSublayer(shapeLayer)
        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
            shapeLayer.removeFromSuperlayer()
        })
    }
    
    /* Zoom in and out camera
     * NOTE: drag UIPinchGestureRecognizer to UIViewController
     */
    func pinchWith(velocity: CGFloat) {
        guard let device = self.defaultCamera else { return }
        
        let maxZoomFactor = device.activeFormat.videoMaxZoomFactor
        let pinchVelocityDividerFactor: CGFloat = 5.0
        
        do {
            try device.lockForConfiguration()
                
            let desiredZoomFactor = device.videoZoomFactor + atan2(velocity, pinchVelocityDividerFactor)
            device.videoZoomFactor = max(1.0, min(desiredZoomFactor, maxZoomFactor))
            
            device.unlockForConfiguration()
            
        } catch let error {
            print("ERROR: Failed to pinch zoom camera ", error)
        }
    }
}

//MARK: - AVCapturePhotoCaptureDelegate
extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            let previewImage = UIImage(data: imageData)
            
            if self.dataDelegate != nil {
                DispatchQueue.main.async {
                    self.dataDelegate?.outputWith(image: previewImage)
                }
            }
            else {
                print("ERROR: There is no delegate connection")
                return
            }
        }
    }
}
