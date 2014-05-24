package com.accident

class Accident {
    Date dateAccident
    Double lat
    Double lon
    String policeStation
    String roadName
    String specificArea
    String roadAtCurrentTime
    String roadLane
    String roadDirection
    String islandType
    String roadType
    String horizontal
    String intersection
    String uTurn
    String roadTypeSpecial
    String roadHumidity
    String roadSurface
    String weather
    String light
    String reason
    String accidentType
    String crashPattern
    String eventDescription
    Integer isComplete


    static hasMany = [persons: Person]
    static belongsTo = [damageCost: DamageCost]

    static constraints = {
        specificArea nullable: true
        roadAtCurrentTime nullable: true
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
