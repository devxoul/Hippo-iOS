//
//  GrayScaleImageView.swift
//  Hippo
//
//  Created by 전수열 on 10/9/14.
//  Copyright (c) 2014 Joyfl. All rights reserved.
//

import Foundation

class GrayScaleImageView: UIImageView {

    private var _grayScaleEnabled: Bool = false
    var grayScaleEnabled: Bool {
        get {
            return self._grayScaleEnabled
        }
        set {
            self._grayScaleEnabled = newValue
            if newValue && self._grayScaleImage? != nil {
                super.image = self._grayScaleImage
            } else if self._originalImage? != nil {
                super.image = self._originalImage
            }
        }
    }

    private var _originalImage: UIImage?
    private var _grayScaleImage: UIImage?
    override var image: UIImage? {
        get {
            return super.image
        }
        set {
            if !self.grayScaleEnabled {
                super.image = newValue
                return
            }
            self._originalImage = newValue!
            self._grayScaleImage = newValue!.grayScaleImage()
            super.image = self._grayScaleImage
        }
    }
}
