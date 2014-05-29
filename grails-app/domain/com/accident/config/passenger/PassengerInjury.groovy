package com.accident.config.passenger

class PassengerInjury {

    String name
    Date dateCreated
    Date lastUpdated

    static constraints = {
        name unique: true, nullable: false
    }


}
