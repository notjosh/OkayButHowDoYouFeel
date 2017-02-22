//
//  FeelingScene.swift
//  OkayButHowDoYouFeel
//
//  Created by joshua may on 22/2/17.
//  Copyright © 2017 joshua may. All rights reserved.
//

import SpriteKit

class FeelingSprite: SKSpriteNode {
    let originalPosition: CGPoint

    var isDecayed = false

    init(color: NSColor, size: CGSize, originalPosition: CGPoint) {
        self.originalPosition = originalPosition
        super.init(texture: nil, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class FeelingScene: SKScene {
    private let duration: TimeInterval = 0.4

    private var sprites: [FeelingSprite] = []

    private var resetting = false

    init(size: CGSize, bitmap: NSBitmapImageRep) {
        let height = Int(bitmap.size.height)
        for x in 0..<Int(bitmap.size.width) {
            for y in 0..<height {
                guard let color = bitmap.colorAt(x: x, y: height - y) else {
                    continue
                }

                if color.redComponent > 0.99 &&
                    color.greenComponent > 0.99 &&
                    color.blueComponent > 0.99 {
                    continue
                }

                if color.alphaComponent < 0.01 {
                    continue
                }

                let sprite = FeelingSprite(color: color,
                                           size: CGSize(width: 1, height: 1),
                                           originalPosition: CGPoint(x: x + Int(size.width), y: y))

                sprites.append(sprite)
            }
        }

        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        sprites.forEach { sprite in
            addChild(sprite)
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
        sprites.forEach { sprite in
            guard !sprite.isDecayed else {
                return
            }

            if sprite.position.x < 50 {
                sprite.isDecayed = true

                sprite.removeAllActions()

                sprite.run(SKAction.fadeOut(withDuration: duration))

                let dest = CGPoint(x: Int(arc4random_uniform(UInt32(size.width))), y: Int(arc4random_uniform(UInt32(size.height))))
                let action = SKAction.move(to: dest, duration: duration)
                action.timingMode = .easeOut

                sprite.run(action)
            }
        }

        // if everything is decayed, start over
        let undecayed = sprites.filter {
            !$0.isDecayed
        }

        if undecayed.count == 0 && !resetting {
            resetting = true
            DispatchQueue.main.asyncAfter(deadline: .now() + (duration * 1.2)) { [weak self] in
                self?.reset()
                self?.start()
            }
        }
    }

    func reset() {
        sprites.forEach { sprite in
            sprite.removeAllActions()

            sprite.alpha = 1

            sprite.position = sprite.originalPosition
            sprite.isDecayed = false
        }

        resetting = false
    }

    func start() {
        sprites.forEach { sprite in
            let dest = CGPoint(x: sprite.originalPosition.x - size.width*2,
                               y: sprite.originalPosition.y)

            sprite.run(SKAction.move(to: dest, duration: 1.5))
        }
    }
}
