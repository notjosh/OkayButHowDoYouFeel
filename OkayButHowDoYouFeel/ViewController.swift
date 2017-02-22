//
//  ViewController.swift
//  OkayButHowDoYouFeel
//
//  Created by joshua may on 22/2/17.
//  Copyright © 2017 joshua may. All rights reserved.
//

import Cocoa
import SpriteKit

class ViewController: NSViewController {

    @IBOutlet var skView: SKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let word = "FUCK"

        guard let whatever = whtaever(word: word) else {
            return
        }

        let scene = FeelingScene(size: whatever.size, bitmap: whatever)
        scene.scaleMode = .aspectFit
        scene.backgroundColor = .white

        skView.presentScene(scene)

        skView.ignoresSiblingOrder = true

        skView.showsFPS = true
        skView.showsNodeCount = true
    }

    func whtaever(word: String) -> NSBitmapImageRep? {
        let nsWord = word as NSString

        let attributes = [
            NSFontAttributeName: NSFont.systemFont(ofSize: 64),
            NSForegroundColorAttributeName: NSColor.black,
        ]

        let size = nsWord.size(withAttributes: attributes)

        let image = NSImage(size: size)
        image.lockFocus()
        nsWord.draw(at: NSPoint.zero, withAttributes: attributes)
        image.unlockFocus()

        var rect = NSRect(origin: NSPoint.zero, size: size)

        let cgImage = image.cgImage(forProposedRect: &rect,
                                    context: NSGraphicsContext.current(),
                                    hints: nil)

        return NSBitmapImageRep(cgImage: cgImage!)
    }
}

