//
//  VideoViewProperties.swift
//  DepictionKit
//
//  Created by Amy While on 26/11/2022.
//

import Foundation

/// https://github.com/repostandards/depiction-schema/blob/a389a08caf97035fce4e669f10d1ba4bdbc2be5b/definitions/Views.d.ts#L80
public struct VideoViewProperties: ViewProperties {
    
    let url: URL
    
    let alt_text: String
    
    public enum Player: String, Codable {
        case native = "native"
        case web = "web"
    }
    
    let player: Player
 
    let player_size: MediaSize
    
    public enum VideoAutoplay: String, Codable {
        case disabled = "disabled"
        case once = "once"
        case loop = "loop"
    }
    
    let autoplay: VideoAutoplay
    
    let corner_radius: Double
    
    let show_controls: Bool
    
    let alignment: Alignment
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.url = try container.decode(URL.self, forKey: .url)
        self.alt_text = try container.decode(String.self, forKey: .alt_text)
        self.player = try container.decodeIfPresent(Player.self, forKey: .player) ?? .native
        self.player_size = try container.decode(MediaSize.self, forKey: .player_size)
        self.autoplay = try container.decodeIfPresent(VideoAutoplay.self, forKey: .autoplay) ?? .disabled
        self.corner_radius = try container.decodeIfPresent(Double.self, forKey: .corner_radius) ?? 4
        self.show_controls = try container.decodeIfPresent(Bool.self, forKey: .show_controls) ?? false
        self.alignment = try container.decodeIfPresent(Alignment.self, forKey: .alignment) ?? .left
    }
    
    public init(url: URL, alt_text: String, player: VideoViewProperties.Player = .native, player_size: MediaSize, autoplay: VideoViewProperties.VideoAutoplay = .disabled, corner_radius: Double = 4, show_controls: Bool = false, alignment: Alignment = .left) {
        self.url = url
        self.alt_text = alt_text
        self.player = player
        self.player_size = player_size
        self.autoplay = autoplay
        self.corner_radius = corner_radius
        self.show_controls = show_controls
        self.alignment = alignment
    }
    
}
