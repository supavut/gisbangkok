package com.accident.config

class RoadAtCurrentTime {

    String name
    Date createdDate
    Date updatedDate

    static constraints = {
        name unique: true, nullable: false
    }

    static mapping = {
        createdDate defaultValue: new Date()
        updatedDate defaultValue: new Date()
    }
}
