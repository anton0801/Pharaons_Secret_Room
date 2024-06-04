import Foundation


let levels = ["level_1", "level_2", "level_3", "level_4", "level_5", "level_6", "level_7", "level_8", "level_9", "level_10", "level_11", "level_12"]

let levelMaps: [String: [String: [String]]] = [
    "level_1": ["bg_game_1": ["object_1", "object_2", "object_3", "object_4"]],
    "level_2": ["bg_game_1": ["object_1", "object_5", "object_4", "object_3"]],
    "level_3": ["bg_game_2": ["object_5", "object_4", "object_6", "object_7"]],
    "level_4": ["bg_game_2": ["object_7", "object_6", "object_5", "object_8"]],
    "level_5": ["bg_game_3": ["object_4", "object_6", "object_7", "object_8"]],
    "level_6": ["bg_game_3": ["object_5", "object_9", "object_8", "object_7"]],
    "level_7": ["bg_game_4": ["object_3", "object_2", "object_1", "object_9"]],
    "level_8": ["bg_game_4": ["object_10", "object_11", "object_12", "object_13"]],
    "level_9": ["bg_game_5": ["object_12", "object_12", "object_15", "object_20"]],
    "level_10": ["bg_game_5": ["object_18", "object_14", "object_12", "object_17"]],
    "level_11": ["bg_game_6": ["object_13", "object_11", "object_14", "object_16"]],
    "level_12": ["bg_game_6": ["object_18", "object_15", "object_14", "object_17"]]
]

