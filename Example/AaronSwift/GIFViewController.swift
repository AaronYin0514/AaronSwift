//
//  GIFViewController.swift
//  AaronSwift_Example
//
//  Created by Aaron on 2020/5/25.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import AaronSwift

class GIFViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "图片解码"
        
        normalImageDecode()
//        gifImageDecode()
    }
    
    func normalImageDecode() {
        let url = Bundle.main.url(forResource: "webp_test", withExtension: "webp")
        let data = try! Data(contentsOf: url!)
        let decoder = ImageDecoder(scale: 0.5)
        if decoder.decodable(data) {
            if let image = decoder.decode(data) {
                imageView.image = image
            } else {
                print("解码失败")
            }
        } else {
            print("解码不了")
        }
    }
    
    func gifImageDecode() {
        let url = Bundle.main.url(forResource: "gif2", withExtension: "gif")
        let data = try! Data(contentsOf: url!)
        
        let decoder = ImageGIFDecoder(scale: 0.5, thumbnailPixelSize: CGSize(width: 100, height: 100))
        
        if decoder.decodable(data) {
            if let image = decoder.decode(data) {
                imageView.image = image
            } else {
                print("解码失败")
            }
        } else {
            print("解码不了")
        }
    }

}
