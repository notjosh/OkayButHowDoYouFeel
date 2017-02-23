//
//  AnotherFeelingScene.swift
//  OkayButHowDoYouFeel
//
//  Created by joshua may on 23/2/17.
//  Copyright © 2017 joshua may. All rights reserved.
//

import SpriteKit

private let DecayDuration: TimeInterval = 0.7

class AnotherFeelingSliceSprite: SKSpriteNode {
    let column: CGFloat
    let pixels: [AnotherFeelingPixel]

    init(texture: SKTexture?, pixels: [AnotherFeelingPixel], size: CGSize, column: CGFloat) {
        self.column = column
        self.pixels = pixels

        super.init(texture: texture, color: .red, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AnotherFeelingPixel: SKSpriteNode {
    let originalPosition: CGPoint
    let originalSize: CGSize

    init(color: NSColor, size: CGSize, originalPosition: CGPoint) {
        self.originalPosition = originalPosition
        self.originalSize = size

        super.init(texture: nil, color: color, size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AnotherFeelingScene: SKScene {
    private var slices: [AnotherFeelingSliceSprite] = []
    private var textSize: CGSize

    init(size: CGSize, sliceImages: [NSImage]) {
        guard !sliceImages.isEmpty else {
            fatalError("yooo, no slices?")
        }

        textSize = CGSize(width: sliceImages.count, height: Int(sliceImages.first!.size.height))

        for (index, image) in sliceImages.enumerated() {
            let bitmap = image.yeahBut

            var pixels: [AnotherFeelingPixel] = []

            for y in 0..<Int(bitmap.size.height) {
                guard let color = bitmap.colorAt(x: 0, y: Int(bitmap.size.height) - y) else {
                    continue
                }

                guard !color.isEmpty else {
                    continue
                }

                guard y % 2 != 0,
                    index % 2 != 0 else {
                        continue
                }

                let pixel = AnotherFeelingPixel(color: color,
                                                size: CGSize(width: 3.8, height: 3.8),
                                                originalPosition: CGPoint(x: index, y: y))

                pixels.append(pixel)
            }

            let texture = SKTexture(image: image)
            let slice = AnotherFeelingSliceSprite(texture: texture, pixels: pixels, size: image.size, column: CGFloat(index))
            slices.append(slice)
        }

        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        slices.forEach { slice in
            addChild(slice)
        }

        reset()
        start()
    }

    override func mouseDown(with event: NSEvent) {
        reset()
    }

    override func mouseUp(with event: NSEvent) {
        start()
    }

    override func update(_ currentTime: TimeInterval) {
        slices.forEach { slice in
            guard slice.parent != nil else {
                return
            }

            if slice.position.x / size.width < 0.00 {
                slice.removeAllActions()
                slice.removeFromParent()

                slice.pixels.forEach { pixel in
                    guard pixel.parent == nil else {
                        return
                    }

                    addChild(pixel)
                    slice.zPosition = 100
                    pixel.alpha = 1
                    pixel.scale(to: pixel.originalSize)
                    pixel.position = CGPoint(x: slice.position.x,
                                             y: pixel.originalPosition.y)

                    let vector = CGVector(dx: CGFloat(arc4random_uniform(UInt32(size.width))),
                                          dy: CGFloat(arc4random_uniform(UInt32(size.height))) - size.height / 2)
                    
                    let group = SKAction.group([
                        SKAction.move(by: vector, duration: DecayDuration),
                        SKAction.fadeOut(withDuration: DecayDuration),
                        SKAction.scale(to: 0, duration: DecayDuration)
                        ])

                    group.timingMode = .easeOut

                    pixel.run(group) {
                        pixel.removeFromParent()
                    }
                }
            }
        }

        if children.count < 2 {
            reset()
            start()
        }
    }

    func reset() {
        removeAllChildren()

        slices.forEach { slice in
            slice.removeAllActions()

            addChild(slice)
            slice.zPosition = 1

            slice.alpha = 1

            let position = CGPoint(x: slice.column + size.width, y: size.height / 2)
            slice.position = position
        }
    }

    func start() {
        slices.forEach { slice in
            let dest = CGPoint(x: slice.column - textSize.width,
                               y: slice.position.y)
            slice.run(SKAction.move(to: dest, duration: Double(slices.count) * 1.0/500.0))
        }
    }
}
