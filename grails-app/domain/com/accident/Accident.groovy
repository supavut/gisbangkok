package com.accident

import com.accident.config.AccidentType
import com.accident.config.CrashPattern
import com.accident.config.Horizontal
import com.accident.config.Intersection
import com.accident.config.IslandType
import com.accident.config.Light
import com.accident.config.Reason
import com.accident.config.RoadAtCurrentTime
import com.accident.config.RoadDirection
import com.accident.config.RoadHumidity
import com.accident.config.RoadLane
import com.accident.config.RoadSurface
import com.accident.config.RoadType
import com.accident.config.RoadTypeSpecial
import com.accident.config.SpecificArea
import com.accident.config.UTurn
import com.accident.config.Weather

class Accident {
    Date dateAccident
    Double lat
    Double lon
    String policeStation
    String roadName
    SpecificArea specificArea
    RoadAtCurrentTime roadAtCurrentTime
    String roadAtCurrentTimeDetail
    RoadLane roadLane
    RoadDirection roadDirection
    IslandType islandType
    RoadType roadType
    Horizontal horizontal
    Intersection intersection
    UTurn uTurn
    RoadTypeSpecial roadTypeSpecial
    RoadHumidity roadHumidity
    RoadSurface roadSurface
    Weather weather
    Light light
    Reason reason
    AccidentType accidentType
    CrashPattern crashPattern
    String eventDescription
    Integer isComplete


    static hasMany = [persons: Person]
    static belongsTo = [damageCost: DamageCost]

    static constraints = {
        specificArea nullable: true
        roadAtCurrentTime nullable: true
        roadAtCurrentTimeDetail nullable: true
        roadLane nullable: true
        roadDirection nullable: true
        islandType nullable: true
        roadType nullable: true
        horizontal nullable: true
        intersection nullable: true
        uTurn nullable: true
        roadTypeSpecial nullable: true
        roadHumidity nullable: true
        roadSurface nullable: true
        weather nullable: true
        light nullable: true
        reason nullable: true
        accidentType nullable: true
        crashPattern nullable: true
        eventDescription nullable: true
        damageCost nullable: true
    }

    static mapping = {
        eventDescription type: 'text'
    }
}
