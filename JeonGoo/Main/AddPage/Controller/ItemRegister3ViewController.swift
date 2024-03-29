//
//  ItemRegister3ViewController.swift
//  JeonGoo
//
//  Created by 이명직 on 2021/03/04.
//

import UIKit
import MobileCoreServices
import Kingfisher
import Alamofire

class ItemRegister3ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: --
    @IBOutlet weak var TableMain: UICollectionView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var videoData: UIImageView!
    @IBOutlet weak var serialImage: UIImageView!
    @IBOutlet weak var videoCountLabel: UILabel!
    
    // MARK: --
    var getVideoData: Data?
    
    var imageData = [UIImage]()
    var serialData = [UIImage]()
    var presentImages = [UIImage]()
    
    var imageIsClick = false
    var serialIsClick = false
    
    var flagImageSave = false
    var flagVideoSave = false
    
    let imagePicker = UIImagePickerController()
    
    var getDescription : String?
    var getName : String?
    var getPrice : Int?
    var getSerialNumber = ""
    var getUseStatus : String?
    
    // MARK: --
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = TableMain.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! imageCell
        cell.image.image = presentImages[indexPath.row]
        
        // 콜백 클로저로 셀 삭제
        cell.delete = { [unowned self] in
            
            self.presentImages.remove(at: indexPath.row)
            self.imageData.remove(at: indexPath.row)
            self.TableMain.reloadData()
            self.countLabel.text = "\(presentImages.count) / 8"
        }
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout = TableMain.collectionViewLayout as! UICollectionViewFlowLayout
        imagePicker.sourceType = .camera
        
        layout.scrollDirection = .horizontal
        
        imagePicker.delegate = self
        
        TableMain.delegate = self
        TableMain.dataSource = self
    }
    
    @IBAction func Complete(_ sender: Any) {
        
        let header: HTTPHeaders = ["Content-Type": "multipart/form-data"]
        
        let url = URL(string: NetworkController.baseURL + "/products/users/\(MyPageViewController.userId!)")
        
    
        let parameters = ["description": getDescription!, "name": getName!, "price": getPrice!, "serialNumber": getSerialNumber, "useStatus": getUseStatus!] as [String : Any]
        
        var data = [Data]()
        for image in self.imageData {
            let imageData = image.jpegData(compressionQuality: 0.5)
            data.append(imageData!)
        }
        
        for image in self.serialData {
            let imageData = image.jpegData(compressionQuality: 0.5)
            data.append(imageData!)
        }
        AF.upload(multipartFormData: { multipart in
            
            for (key, value) in parameters {
                multipart.append("\(value)".data(using: .utf8)!, withName: key, mimeType: "text/plain")
            }
            for item in data {
                let randomNo: UInt32 = arc4random_uniform(100000000) + 1

                multipart.append(item, withName: "imageFiles", fileName: "File_name\(randomNo)", mimeType: "image/jpg")
            }
            
            let randomNo: UInt32 = arc4random_uniform(100000000) + 1
            multipart.append(self.getVideoData! as Data, withName: "videoFile", fileName: "\(randomNo).mp4", mimeType: "video/mp4")
            
        }, to: url!
        , headers: header).uploadProgress(queue: .main, closure: { progress in
            
        }).responseJSON(completionHandler: { data in
            switch data.result {
            case .success(_):
                do {
                    print("success")
                    let msg = UIAlertController(title: "등록완료", message: "상품등록을 완료하였습니다", preferredStyle: .alert)
                    let YES = UIAlertAction(title: "확인", style: .default, handler: { (action) -> Void in
                        
                        self.YesClick()
                    })
                    msg.addAction(YES)
                    self.present(msg, animated: true, completion: nil)
                }
                
            case .failure(_):
                print("ERROR")
            }
        })
    }
    
    func YesClick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func camera(_ sender: Any) {
        imageIsClick = true
        if checkCount(mediaCount: imageData.count, maxCount: 8) {
            openCamera()
        }
        
    }
    
    @IBAction func clickVideo(_ sender: Any) {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            flagVideoSave = true
            
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            // 미디어 타입을 kUTTypeMovie로 설정
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func clickSerial(_ sender: Any) {
        checkCount(mediaCount: serialData.count, maxCount: 1)
        serialIsClick = true
        openCamera()
    }
    
    func checkCount(mediaCount: Int, maxCount: Int) -> Bool {
        if mediaCount == maxCount {
            let msg = UIAlertController(title: "에러", message: "최대 \(maxCount)장까지 첨부가능합니다", preferredStyle: .alert)
            
            
            let YES = UIAlertAction(title: "확인", style: .default, handler: nil)
            msg.addAction(YES)
            self.present(msg, animated: true, completion: nil)
            return false
            
        }
        return true
    }
    
    func openCamera(){
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            flagImageSave = true // 사진 저장 플래그를 true로 설정
            
            imagePicker.delegate = self // 이미지 피커의 델리케이트를 self로 설정
            imagePicker.sourceType = .camera // 이미지 피커의 소스 타입을 Camera로 설정
            imagePicker.mediaTypes = [kUTTypeImage as String] // 미디어 타입을 kUTTypeImage로 설정
            imagePicker.allowsEditing = false // 편집을 허용하지 않음
            
            // 뷰 컨트롤러를 imagePicker로 대체
            present(imagePicker, animated: true, completion: nil)
        } else {
            // 카메라를 사용할 수 없을 때 경고 창 출력
            myAlert("Camera inaccessable", message: "Application cannot access the camera.")
        }
    }
    
    // 사진 촬영이나 선택이 끝났을 때 호출되는 델리게이트 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 미디어 종류 확인
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString
        // 미디어가 사진이면
        if mediaType.isEqual(to: kUTTypeImage as NSString as String){
            // 사진을 가져옴
            let captureImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            if imageIsClick {
                imageData.append(captureImage)
                presentImages.append(resize(getImage: captureImage, size: 70))
                DispatchQueue.main.async {
                    self.countLabel.text = "\(self.imageData.count) / 8"
                    self.TableMain.reloadData()
                }
            }
            else if serialIsClick {
                DispatchQueue.main.async {
                    self.countLabel.text = "1 / 1"
                    self.serialImage.image = self.resize(getImage: captureImage, size: 70)
                    self.serialData.append(captureImage)
                    print("시리얼 추가")
                }
            }
            imageIsClick = false
            serialIsClick = false
        }
        else if mediaType.isEqual(to: kUTTypeMovie as NSString as String){
            if (info[.mediaURL] as? URL) != nil {
                guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else {
                    print("VIDEO URL NIL")
                    return
                }
                do {
                    self.getVideoData = try Data(contentsOf: videoURL, options: .mappedRead)
                }
                catch{
                    
                }
                
                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
                DispatchQueue.main.async {
                    self.videoCountLabel.text = "1 / 1"
                    self.videoData.kf.setImage(with: videoURL)
                }
            }
        }
        // 현재의 뷰(이미지 피커) 제거
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // 사진 촬영이나 선택을 취소했을 때 호출되는 델리게이트 메서드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 현재의 뷰(이미지 피커) 제거
        imageIsClick = false
        serialIsClick = false
        self.dismiss(animated: true, completion: nil)
    }
    
    func myAlert(_ title: String,message: String) {
        // Alert show
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func resize(getImage:UIImage, size:Double) -> UIImage {
        
        var new_image : UIImage!
        let size = CGSize(width:  size  , height: size )
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)
        
        getImage.draw(in: rect)
        
        new_image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        return new_image
    }
    
}
