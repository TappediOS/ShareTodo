//
//  ExUIImageView.swift
//  ShareTodo
//
//  Created by jun on 2020/07/26.
//  Copyright © 2020 jun. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeUIImage(width: CGFloat, height: CGFloat) -> UIImage {
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        var context = UIGraphicsGetCurrentContext()
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image ?? UIImage()
    }
    
    static func getRandomEarthImage() -> UIImage? {
        switch Int.random(in: 1 ... 8) {
        case 1: return R.image.earth1()
        case 2: return R.image.earth2()
        case 3: return R.image.earth3()
        case 4: return R.image.earth4()
        case 5: return R.image.earth5()
        case 6: return R.image.earth6()
        case 7: return R.image.earth7()
        case 8: return R.image.earth8()
        default: return R.image.earth1()
        }
    }
}
