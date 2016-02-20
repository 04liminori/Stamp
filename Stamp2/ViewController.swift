
//
//  ViewController.swift
//  Stamp2
//
//  Created by fukumoriminori on 2016/02/06.
//  Copyright © 2016年 fukumoriminori. All rights reserved.
//

import UIKit
import AVFoundation
import Accounts

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //スタンプの名前が入った配列
    var imagenNameArray: [String] = ["iris2.gif", "b", "c", "d"]
    
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
    
    //タッチ開始
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        //タッチされた位置を取得
        let touch: UITouch = (touches.first)!
        let location: CGPoint = touch.locationInView(self.view)
        
        print(location.y)
        print(haikeiImageView.frame.height)
        
        if location.y < 375.0 {
        
        //もしimageIndexが0でない(押すすスタンプが選ばれていない)とき
        if imageIndex != 0 {
            //スタンプサイズを90pxの正方形に指定
            self.imageView = UIImageView(frame: CGRectMake(0, 0, 90, 90))
            
            //押されたスタンプを設定
            let image: UIImage = UIImage(named: self.imagenNameArray[self.imageIndex - 1])!
            imageView.image = image
            haikeiImageView.frame.height            //タッチされた位置にスタンプを置く
            imageView.center = CGPointMake(location.x, location.y)
            
            //画面に表示する
            self.view.addSubview(imageView)
        }
        }
    }
    
    //タッチ中
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        //タッチされた位置を取得
        let touch: UITouch = (touches.first)!
        let location: CGPoint = touch.locationInView(self.view)
        if location.y < 375.0 {
        //タッチされた位置にスタンプを置く
        imageView.center = CGPointMake(location.x, location.y)
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
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject], didFinishPickingImage image: UIImage) {
        //imageに選んだ画像を設定する
        //let image: UIImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        //そのimageを背景に設定する
        haikeiImageView.image = image
        
        //フォトライブラリを閉じる
        picker.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func save() {
        //画面のスクリーンショットを取得
        let rect: CGRect = CGRectMake(0, 20, haikeiImageView.frame.width, haikeiImageView.frame.height)
        UIGraphicsBeginImageContext(rect.size)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let captuer = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //フォトライブラリに保存
        UIImageWriteToSavedPhotosAlbum(captuer, nil, nil, nil)
        
        let alertController = UIAlertController(title: "保存完了！", message: "", preferredStyle: .Alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)

    }
    
    @IBAction func openCamera(){
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        picker.delegate = self
        presentViewController(picker, animated: true, completion: nil)
    }
    
    //写真撮影完了時よばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage,
        editingInfo: [String : AnyObject]?) {
            
        haikeiImageView.image = image                            // 撮影した画像をセットする
        dismissViewControllerAnimated(true, completion: nil)    // アプリ画面へ戻る
    }
    
    @IBAction func snsPost(){
        let rect: CGRect = CGRectMake(0, 20, haikeiImageView.frame.width, haikeiImageView.frame.height)
        UIGraphicsBeginImageContext(rect.size)
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let captuer = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //共有する項目
        let shareText = "写真を加工したよ！！"
        let shareImage = captuer
        
        let activityItems = [shareText, shareImage]
        
        //初期化処理
        let activityVC = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        
        //使用しないアクティビティタイプ
        let excludedActivityTypes = [
            UIActivityTypePostToWeibo,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypePrint
        ]
        
        activityVC.excludedActivityTypes = excludedActivityTypes
        
        //UIActivityViewControllerを表示
        self.presentViewController(activityVC, animated: true, completion: nil)
        
    }



}

