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
        
        normalImageDecode(index: 0)
    }
    
    func normalImageDecode(index: Int) {
        let names = ["jpeg_test.jpg", "png_test.png", "tiff_test.tiff", "heic_test.heic"]
        let url = Bundle.main.url(forResource: names[index], withExtension: nil)
        let data = try! Data(contentsOf: url!)
        
        let decoder = ImageDecoder()
        if decoder.decodable(data) {
            if let image = decoder.decode(data) {
                imageView.image = image
            } else {
                print("\(names[index])解码失败")
            }
        } else {
            print("\(names[index])解码不了")
        }
    }
    
    func webpImageDecode() {
        print("webp解码不了")
    }
    
    func gifImageDecode() {
        let url = Bundle.main.url(forResource: "gif2", withExtension: "gif")
        let data = try! Data(contentsOf: url!)
        
        let decoder = ImageGIFDecoder(thumbnailPixelSize: CGSize(width: 100, height: 100))
        if decoder.decodable(data) {
            if let image = decoder.decode(data) {
                imageView.image = image
            } else {
                print("gif解码失败")
            }
        } else {
            print("gif解码不了")
        }
    }
    
    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex < 4 {
            normalImageDecode(index: sender.selectedSegmentIndex)
        } else if sender.selectedSegmentIndex == 4 {
            webpImageDecode()
        } else {
            gifImageDecode()
        }
    }
    

}
