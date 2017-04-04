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

    var tilesDataCache = [Vector2: JSON]()
    
    var mapView: UIView!
    var mapScrollView: UIScrollView!
    var primordialTile: Vector2!
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
        
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        scrollView.setContentOffset(scrollView.contentOffset, animated: true)
    }
    
    func renderTile(tileKey: Vector2) {
        let tile = tilesDataCache[tileKey]!
        let delta = (Vector2(Scalar(tile["x"].int!), Scalar(tile["y"].int!)) - self.primordialTile) * 611.5 + Vector2(5000, 5000)
        DispatchQueue.main.async {
            let tile2d = Tile2D(frame: CGRect(x: Double(delta.x), y: Double(delta.y), width: 611.5, height: 611.5), data: tile, tileKey: tileKey)
            self.mapView.addSubview(tile2d)
            self.mapView.bringSubview(toFront: self.player)
            WorldViewController.mapTiles[tileKey] = tile2d
        }
    }
    
    
    func computeTiles(timer: Timer) {
        let locMeters = Utils.latLonToMeters(coord: LocationMaster.getLast())
        let currentTile = Utils.latLonToTile(coord: LocationMaster.getLast())
        let currentTileLatLon = Utils.tileToLatLon(tile: currentTile)
        let currentTileMeters = Utils.latLonToMeters(coord: currentTileLatLon)
        var playerOffsetInsideTile = locMeters - currentTileMeters
        playerOffsetInsideTile = Vector2(abs(playerOffsetInsideTile.x), abs(playerOffsetInsideTile.y))
        if primordialTile == nil {
            primordialTile = currentTile
        }
        
        let primordialLatLon = Utils.tileToLatLon(tile: primordialTile)
        let primordialMeters = Utils.latLonToMeters(coord: primordialLatLon)
        
        let primordialOffset = primordialMeters - currentTileMeters
        
        
        let prepare = Vector2(Scalar(mapScrollView.contentSize.width), Scalar(mapScrollView.contentSize.height)) / 2 - primordialOffset + Vector2(-5000, -5000) - playerOffsetInsideTile
        
        mapView.frame.origin = CGPoint(x: Double(prepare.x), y: Double(prepare.y))
        
        for i in -1...1 {
            for j in -1...1 {
                let tileKey = currentTile + Vector2(Scalar(i), Scalar(j))
                if WorldViewController.mapTiles[tileKey] == nil {
                    if tilesDataCache[tileKey] != nil {
                        renderTile(tileKey: tileKey)
                    } else {
                        self.tilesDataCache[tileKey] = JSON.null
                        API.get(endpoint: "tile/\(Int(tileKey.x))/\(Int(tileKey.y))", callback: { (data) in
                            self.tilesDataCache[tileKey] = data["data"]
                            self.renderTile(tileKey: tileKey)
                        })
                    }
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

