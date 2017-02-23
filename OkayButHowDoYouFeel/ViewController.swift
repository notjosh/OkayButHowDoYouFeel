//
//  ViewController.swift
//  OkayButHowDoYouFeel
//
//  Created by joshua may on 22/2/17.
//  Copyright © 2017 joshua may. All rights reserved.
//

import Cocoa
import SpriteKit

let FontSize: CGFloat = 96

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let word = "🌽🐴🌽🚀🌽💦🌽📛🌽🔥🌽🇦🇺🌽FUCK"

        let whatever = whtaever(word: word)
        let slices = whatever.slices

        let size16x9 = CGSize(width: whatever.size.height * 16/9 * 2,
                              height: whatever.size.height)

        let scene = AnotherFeelingScene(size: size16x9, sliceImages: slices)
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .white

        skView.presentScene(scene)

        skView.ignoresSiblingOrder = true

        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    func whtaever(word: String) -> NSImage {
        let nsWord = word as NSString

        let attributes = [
            NSFontAttributeName: NSFont.boldSystemFont(ofSize: FontSize),
            NSForegroundColorAttributeName: NSColor.black,
        ]

        let size = nsWord.size(withAttributes: attributes)

        let image = NSImage(size: size)
        image.lockFocus()
        nsWord.draw(at: NSPoint.zero, withAttributes: attributes)
        image.unlockFocus()

        return image
    }
}

extension NSColor {
    var isEmpty: Bool {
        if redComponent > 0.99 &&
            greenComponent > 0.99 &&
            blueComponent > 0.99 {
            return true
        }

        if alphaComponent < 0.01 {
            return true
        }

        return false
    }
}

extension NSImage {
    var yeahBut: NSBitmapImageRep {
        let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil,
                                      pixelsWide: Int(size.width),
                                      pixelsHigh: Int(size.height),
                                      bitsPerSample: 8,
                                      samplesPerPixel: 4,
                                      hasAlpha: true,
                                      isPlanar: false,
                                      colorSpaceName: NSDeviceRGBColorSpace,
                                      bytesPerRow: 0,
                                      bitsPerPixel: 0)!

        bitmap.size = size

        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.setCurrent(NSGraphicsContext.init(bitmapImageRep: bitmap))

        draw(at: NSPoint(x: 0, y: 0),
             from: NSRect.zero,
             operation: .sourceOver,
             fraction: 1)

        NSGraphicsContext.restoreGraphicsState()

        return bitmap
    }

    var slices: [NSImage] {
        var _slices: [NSImage] = []

        for x in 0..<Int(self.size.width) {
            let slice = self.slice(from: NSRect(x: CGFloat(x),
                                                y: 0,
                                                width: 1,
                                                height: self.size.height))

            _slices.append(slice)
        }

        return _slices
    }

    func slice(from fromRect: NSRect) -> NSImage {
        let targetRect = NSRect(x: 0, y: 0, width: fromRect.width, height: fromRect.height)

        let result = NSImage(size: targetRect.size)

        result.lockFocus()
        self.draw(in: targetRect,
                  from: fromRect,
                  operation: .copy,
                  fraction: 1)
        result.unlockFocus()

        return result
    }
}
