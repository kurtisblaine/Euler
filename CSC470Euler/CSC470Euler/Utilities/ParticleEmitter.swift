//
//  ParticleEmitter.swift
//  CSC470Euler
//
//  Created by Jozeee on 12/5/18.
//  Copyright © 2018 CSC470Fa18. All rights reserved.
//

import UIKit

func createParticles(on view: UIView) {
    let particleEmitter = CAEmitterLayer()
    
    particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: view.bounds.minY)
    particleEmitter.emitterShape = .line
    particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)
    
    let red = makeEmitterCell(color: UIColor.appRed)
    let blue = makeEmitterCell(color: UIColor.blue)
    let yellow = makeEmitterCell(color: UIColor.yellow)
    
    particleEmitter.emitterCells = [red, blue, yellow]
    
    view.layer.addSublayer(particleEmitter)
}

func makeEmitterCell(color: UIColor) -> CAEmitterCell {
    let cell = CAEmitterCell()
    cell.birthRate = 8
    cell.lifetime = 6.0
    cell.lifetimeRange = 0
    cell.color = color.cgColor
    cell.velocity = 200
    cell.velocityRange = 55
    cell.emissionLongitude = CGFloat.pi
    cell.emissionRange = CGFloat.pi / 4
    cell.spin = 4
    cell.spinRange = 4
    cell.scaleRange = 0.3
    cell.scaleSpeed = -0.05
    
    cell.contents = UIImage(named: "Particle")?.cgImage
    return cell
}
