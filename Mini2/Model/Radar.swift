//
//  Radar.swift
//  Mini2
//
//  Created by Jasmini Rebecca Gomes dos Santos on 31/08/23.
//

class Radar {
    private let map: Map
    
    init(map: Map) {
        self.map = map
    }
    
    private func contaminationLevelAt(x: Int, y: Int) -> Int? {
        if x >= 0 && x < map.columns && y >= 0 && y < map.rows {
            return map.rooms[y][x].getContaminationLevel()
        }
        return nil
    }
    
    func topLeftQuadrantContamination() -> [Int?] {
        let left = contaminationLevelAt(x: map.currentX + 1, y: map.currentY)
        let diagonal = contaminationLevelAt(x: map.currentX + 1, y: map.currentY + 1)
        let top = contaminationLevelAt(x: map.currentX, y: map.currentY + 1)
        return [left, diagonal, top]
    }

    func topRightQuadrantContamination() -> [Int?] {
        let right = contaminationLevelAt(x: map.currentX - 1, y: map.currentY)
        let diagonal = contaminationLevelAt(x: map.currentX - 1, y: map.currentY + 1)
        let top = contaminationLevelAt(x: map.currentX, y: map.currentY + 1)
        return [right, diagonal, top]
    }

    func bottomLeftQuadrantContamination() -> [Int?] {
        let left = contaminationLevelAt(x: map.currentX + 1, y: map.currentY)
        let diagonal = contaminationLevelAt(x: map.currentX + 1, y: map.currentY - 1)
        let down = contaminationLevelAt(x: map.currentX, y: map.currentY - 1)
        return [left, diagonal, down]
    }

    func bottomRightQuadrantContamination() -> [Int?] {
        let right = contaminationLevelAt(x: map.currentX - 1, y: map.currentY)
        let diagonal = contaminationLevelAt(x: map.currentX - 1, y: map.currentY - 1)
        let down = contaminationLevelAt(x: map.currentX, y: map.currentY - 1)
        return [right, diagonal, down]
    }
    
    func getMaxNearbyLevel() -> Int? {
        return [topLeftQuadrantContamination(),
                topRightQuadrantContamination(),
                bottomLeftQuadrantContamination(),
                bottomRightQuadrantContamination()]
            .flatMap({ $0 })
            .compactMap({ $0 })
            .max()
    }
}



