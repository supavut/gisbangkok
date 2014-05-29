package com.accident.config.passenger

class SeatPosition {

    String name
    Date dateCreated
    Date lastUpdated

    static constraints = {
        name unique: true, nullable: false
    }


}
