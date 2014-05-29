package com.accident.config

class RoadLane {

    String name
    Date dateCreated
    Date lastUpdated

    static constraints = {
        name unique: true, nullable: false
    }


}
