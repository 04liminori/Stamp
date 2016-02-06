
//
//  ViewController.swift
//  Stamp2
//
//  Created by fukumoriminori on 2016/02/06.
//  Copyright © 2016年 fukumoriminori. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //スタンプの名前が入った配列
    var imagenNameArray: [String] = ["a", "b", "c", "d"]
    
    //選択しているスタンプの番号
    var imageIndex: Int = 0
    
    //背景画像を表示させるImageView
    @IBOutlet var haikeiImageView: UIImageView!
    
    //スタンプの画像が入るImageView
    var imageView: UIImageView!
    
    //セッション
    var mySession: AVCaptureSession!
    
    //デバイス
    var myDevice: AVCaptureDevice!
    
    //画像のアウトプット
    var myImageOutput: AVCaptureStillImageOutput!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    @IBAction func selectedFirst() {
        imageIndex = 1
        
    }
    
    @IBAction func selectedSecond() {
        imageIndex = 2
        
    }
    
    @IBAction func selectedThird() {
        imageIndex = 3
        
    }
    
    @IBAction func selectedFourth() {
        imageIndex = 4
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //タッチされた位置を取得
        let touch: UITouch = (touches.first)!
        let location: CGPoint = touch.locationInView(self.view)
        
        //もしimageIndexが0でない(押すすスタンプが選ばれていない)とき
        if imageIndex != 0 {
            //スタンプサイズを40pxの正方形に指定
            self.imageView = UIImageView(frame: CGRectMake(0, 0, 40, 40))
            
            //押されたスタンプを設定
            let image: UIImage = UIImage(named: self.imagenNameArray[self.imageIndex - 1])!
            imageView.image = image
            
            //タッチされた位置にスタンプを置く
            imageView.center = CGPointMake(location.x, location.y)
            
            //画面に表示する
            self.view.addSubview(imageView)
        }
    }
    
    @IBAction func selectBackground() {
        //UIImagePickerControllerのインスタンスを作る
        let imagePickerController : UIImagePickerController = UIImagePickerController()
        
        //フォトライブラリを使う設定をする
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        //フォトライブラリを呼び出す
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func back() {
        self.imageView.removeFromSuperview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //フォトライブラリから画像の選択が呼ばれるメソッド
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        //imageに選んだ画像を設定する
        let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        //そのimageを背景に設定する
        haikeiImageView.image = image
        
        //フォトライブラリを閉じる
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func save() {
        //画面のスクリーンショットを取得
        let rect: CGRect = CGRectMake(0, 30, 375, 375)
        UIGraphicsBeginImageContext(rect.size)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let captuer = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //フォトライブラリに保存
        UIImageWriteToSavedPhotosAlbum(captuer, nil, nil, nil)

    }
    
    @IBAction func openCamera(){
        //セッションの作成.
            mySession = AVCaptureSession()
        
        // デバイス一覧の取得.
        let devices = AVCaptureDevice.devices()
        
        // バックカメラをmyDeviceに格納.
        for device in devices{
            if(device.position == AVCaptureDevicePosition.Back){
                myDevice = device as! AVCaptureDevice
            }
        }
        
        // バックカメラからVideoInputを取得.
        let videoInput = (try! AVCaptureDeviceInput(device: myDevice))
        mySession.addInput(videoInput)
        myImageOutput = AVCaptureStillImageOutput()
        mySession.addOutput(myImageOutput)
        
        // セッションに追加.
        mySession.addInput(videoInput)
        
        // 出力先を生成.
        myImageOutput = AVCaptureStillImageOutput()
        
        // セッションに追加.
        mySession.addOutput(myImageOutput)
        
        // 画像を表示するレイヤーを生成.
        let myVideoLayer : AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer.init(session: (mySession)) as AVCaptureVideoPreviewLayer
            myVideoLayer.frame = self.view.bounds
        myVideoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        // Viewに追加.
        self.view.layer.addSublayer(myVideoLayer)
        
        // セッション開始.
        mySession.startRunning()
        
        // UIボタンを作成.
        let myButton = UIButton(frame: CGRectMake(0,0,120,50))
        myButton.backgroundColor = UIColor.redColor();
        myButton.layer.masksToBounds = true
        myButton.setTitle("撮影", forState: .Normal)
        myButton.layer.cornerRadius = 20.0
        myButton.layer.position = CGPoint(x: self.view.bounds.width/2, y:self.view.bounds.height-50)
        myButton.addTarget(self, action: "onClickMyButton:", forControlEvents: .TouchUpInside)
        
        // UIボタンをViewに追加.
        self.view.addSubview(myButton)
    }


}

