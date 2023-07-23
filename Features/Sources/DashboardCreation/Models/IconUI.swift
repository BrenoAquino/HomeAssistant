//
//  IconUI.swift
//  
//
//  Created by Breno Aquino on 18/07/23.
//

import Foundation

public struct IconUI {

    let name: String
    let keywords: [String]
}

extension IconUI {

    static let list: [IconUI] = [
        .init(name: "bed.double", keywords: []),
        .init(name: "sofa", keywords: []),
        .init(name: "refrigerator", keywords: []),
        .init(name: "tree", keywords: []),
        .init(name: "tree.circle", keywords: []),
        .init(name: "pc", keywords: []),
        .init(name: "desktopcomputer", keywords: []),
        .init(name: "popcorn", keywords: []),
        .init(name: "laptopcomputer", keywords: []),
        .init(name: "play.laptopcomputer", keywords: []),
        .init(name: "shower.sidejet", keywords: []),
        .init(name: "shower", keywords: []),
        .init(name: "shower.handheld", keywords: []),
        .init(name: "eye", keywords: []),
        .init(name: "camera", keywords: []),
        .init(name: "web.camera", keywords: []),
        .init(name: "trash", keywords: []),
        .init(name: "folder", keywords: []),
        .init(name: "tray", keywords: []),
        .init(name: "tray.2", keywords: []),
        .init(name: "externaldrive", keywords: []),
        .init(name: "externaldrive.badge.wifi", keywords: []),
        .init(name: "archivebox", keywords: []),
        .init(name: "calendar", keywords: []),
        .init(name: "book", keywords: []),
        .init(name: "books.vertical", keywords: []),
        .init(name: "text.book.closed", keywords: []),
        .init(name: "graduationcap", keywords: []),
        .init(name: "person.2", keywords: []),
        .init(name: "shared.with.you", keywords: []),
        .init(name: "person.badge.key", keywords: []),
        .init(name: "figure.indoor.cycle", keywords: []),
        .init(name: "sportscourt", keywords: []),
        .init(name: "soccerball.inverse", keywords: []),
        .init(name: "globe", keywords: []),
        .init(name: "globe.americas", keywords: []),
        .init(name: "snowflake", keywords: []),
        .init(name: "play.rectangle", keywords: []),
        .init(name: "speaker", keywords: []),
        .init(name: "megaphone", keywords: []),
        .init(name: "icloud", keywords: []),
        .init(name: "video", keywords: []),
        .init(name: "cart", keywords: []),
        .init(name: "basket", keywords: []),
        .init(name: "hammer", keywords: []),
        .init(name: "wrench.adjustable", keywords: []),
        .init(name: "wrench.and.screwdriver", keywords: []),
        .init(name: "printer", keywords: []),
        .init(name: "suitcase.rolling", keywords: []),
        .init(name: "homekit", keywords: []),
        .init(name: "house", keywords: []),
        .init(name: "music.note.house", keywords: []),
        .init(name: "building.columns", keywords: []),
        .init(name: "lightbulb", keywords: []),
        .init(name: "lightbulb.2", keywords: []),
        .init(name: "fan.oscillation", keywords: []),
        .init(name: "fan.ceiling", keywords: []),
        .init(name: "fan.floor", keywords: []),
        .init(name: "lamp.desk", keywords: []),
        .init(name: "lamp.table", keywords: []),
        .init(name: "lamp.floor", keywords: []),
        .init(name: "lamp.ceiling", keywords: []),
        .init(name: "chandelier", keywords: []),
        .init(name: "lightswitch.on", keywords: []),
        .init(name: "poweroutlet.type.a", keywords: []),
        .init(name: "poweroutlet.type.b", keywords: []),
        .init(name: "poweroutlet.type.j", keywords: []),
        .init(name: "poweroutlet.strip", keywords: []),
        .init(name: "powerplug", keywords: []),
        .init(name: "light.beacon.min", keywords: []),
        .init(name: "light.beacon.max", keywords: []),
        .init(name: "entry.lever.keypad", keywords: []),
        .init(name: "door.left.hand.open", keywords: []),
        .init(name: "door.left.hand.closed", keywords: []),
        .init(name: "door.garage.open", keywords: []),
        .init(name: "door.garage.closed", keywords: []),
        .init(name: "window.horizontal.closed", keywords: []),
        .init(name: "window.horizontal", keywords: []),
        .init(name: "window.vertical.open", keywords: []),
        .init(name: "window.vertical.closed", keywords: []),
        .init(name: "window.casement", keywords: []),
        .init(name: "blinds.vertical.open", keywords: []),
        .init(name: "blinds.vertical.closed", keywords: []),
        .init(name: "roller.shade.closed", keywords: []),
        .init(name: "blinds.horizontal.open", keywords: []),
        .init(name: "air.purifier", keywords: []),
        .init(name: "humidifier", keywords: []),
        .init(name: "heater.vertical", keywords: []),
        .init(name: "air.conditioner.vertical", keywords: []),
        .init(name: "sprinkler", keywords: []),
        .init(name: "bathtub", keywords: []),
        .init(name: "hifireceiver", keywords: []),
        .init(name: "videoprojector", keywords: []),
        .init(name: "wifi.router", keywords: []),
        .init(name: "chair.lounge", keywords: []),
        .init(name: "chair", keywords: []),
        .init(name: "fireplace", keywords: []),
        .init(name: "dryer", keywords: []),
        .init(name: "washer", keywords: []),
        .init(name: "oven", keywords: []),
        .init(name: "cooktop", keywords: []),
        .init(name: "sink", keywords: []),
        .init(name: "toilet", keywords: []),
        .init(name: "house.lodge", keywords: []),
        .init(name: "house.and.flag", keywords: []),
        .init(name: "signpost.right", keywords: []),
        .init(name: "signpost.left", keywords: []),
        .init(name: "lock", keywords: []),
        .init(name: "display", keywords: []),
        .init(name: "play.display", keywords: []),
        .init(name: "display.2", keywords: []),
        .init(name: "macpro.gen2", keywords: []),
        .init(name: "server.rack", keywords: []),
        .init(name: "xserve", keywords: []),
        .init(name: "iphone.gen2", keywords: []),
        .init(name: "iphone.rear.camera", keywords: []),
        .init(name: "tv", keywords: []),
        .init(name: "4k.tv", keywords: []),
        .init(name: "photo.tv", keywords: []),
        .init(name: "guitars", keywords: []),
        .init(name: "car", keywords: []),
        .init(name: "car.2", keywords: []),
        .init(name: "bolt.car", keywords: []),
        .init(name: "car.side", keywords: []),
        .init(name: "suv.side", keywords: []),
        .init(name: "minus.plus.batteryblock", keywords: []),
        .init(name: "minus.plus.and.fluid.batteryblock", keywords: []),
        .init(name: "bolt.batteryblock", keywords: []),
        .init(name: "cross", keywords: []),
        .init(name: "film", keywords: []),
        .init(name: "rectangle.and.hand.point.up.left.filled", keywords: []),
        .init(name: "sidebar.left", keywords: []),
        .init(name: "align.vertical.bottom", keywords: []),
        .init(name: "clock", keywords: []),
        .init(name: "gamecontroller", keywords: []),
        .init(name: "chart.bar", keywords: []),
        .init(name: "cylinder.split.1x2", keywords: []),
        .init(name: "esim", keywords: []),
        .init(name: "atom", keywords: []),
    ]
}

/*

Icons not found:
 storefront
 gym.bag
 play.house
 lightbulb.min
 fan
 powercord
 xserve.raid
 macbook
 tv.badge.wifi
 dog
 movieclapper
 battery.75percent
*/
