//
//  ViewController.swift
//  HW
//
//  Created by Adrian Nenu on 27/03/2017.
//  Copyright © 2017 Adrian Nenu. All rights reserved.
//

import UIKit
import SwiftHTTP
import SwiftyJSON
import QuartzCore
import CoreMotion


class WorldViewController: UIViewController, UIScrollViewDelegate {
    static var mapTiles = [Vector2: Tile2D]()
    static var tilesDataCache = [Vector2: JSON]()
    static let TILE_RANGE = 1
    
    var mapView: UIView!
    var mapScrollView: UIScrollView!
    static var primordialTile: Vector2!
    var player: Player!
    var locationMaster: LocationMaster!
    
    var guiMaster: GUIMaster!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        mapScrollView.contentSize = CGSize(width: 1000, height: 1000)
        mapScrollView.contentOffset = CGPoint(
            x: mapScrollView.contentSize.width/2-UIScreen.main.bounds.width/2,
            y: mapScrollView.contentSize.height/2-UIScreen.main.bounds.height/2)


        mapScrollView.delegate = self
        mapScrollView.bounces = false
        mapScrollView.showsVerticalScrollIndicator = false
        mapScrollView.showsHorizontalScrollIndicator = false
        
        player = Player(frame: CGRect(x: mapScrollView.contentSize.width/2, y: mapScrollView.contentSize.height/2, width: 20, height: 20))
        
        self.view.addSubview(mapScrollView)

        mapView = UIView(frame: CGRect(
            x: -5000 + UIScreen.main.bounds.width / 2,
            y: -5000 + UIScreen.main.bounds.height / 2, width: 10000, height: 10000
        ))
        
        
        mapScrollView.addSubview(mapView)
        self.mapScrollView.addSubview(player)
        
        locationMaster = LocationMaster()
        Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(self.computeTiles), userInfo: nil, repeats: true)
        
        // UI
        guiMaster = GUIMaster(view: self.view)
        
        
        /*let gestureRec = UIRotationGestureRecognizer()
        gestureRec.addTarget(self, action: #selector(handleRotate(recognizer:)))
        mapScrollView.addGestureRecognizer(gestureRec)*/
    }

    /*func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }*/
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: true)
    }
    
    func computeTiles(timer: Timer) {
        let locMeters = Utils.latLonToMeters(coord: LocationMaster.getLast())
        let currentTile = Utils.latLonToTile(coord: LocationMaster.getLast())
        let currentTileLatLon = Utils.tileToLatLon(tile: currentTile)
        let currentTileMeters = Utils.latLonToMeters(coord: currentTileLatLon)
        var playerOffsetInsideTile = locMeters - currentTileMeters
        playerOffsetInsideTile = Vector2(abs(playerOffsetInsideTile.x), abs(playerOffsetInsideTile.y))
        if WorldViewController.primordialTile == nil {
            WorldViewController.primordialTile = currentTile
        }
        
        let primordialLatLon = Utils.tileToLatLon(tile: WorldViewController.primordialTile)
        let primordialMeters = Utils.latLonToMeters(coord: primordialLatLon)
        
        let primordialOffset = primordialMeters - currentTileMeters
        let prepare = Vector2(Float(mapScrollView.contentSize.width), Float(mapScrollView.contentSize.height)) / 2 - primordialOffset + Vector2(-5000, -5000) - playerOffsetInsideTile
        
        mapView.frame.origin = CGPoint(x: Double(prepare.x), y: Double(prepare.y))
        
        for i in -WorldViewController.TILE_RANGE...WorldViewController.TILE_RANGE {
            for j in -WorldViewController.TILE_RANGE...WorldViewController.TILE_RANGE {
                let tileKey = currentTile + Vector2(Float(i), Float(j))
                if WorldViewController.mapTiles[tileKey] == nil {
                    let tile2d = Tile2D(tileKey: tileKey)
                    self.mapView.addSubview(tile2d)
                    WorldViewController.mapTiles[tileKey] = tile2d
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

