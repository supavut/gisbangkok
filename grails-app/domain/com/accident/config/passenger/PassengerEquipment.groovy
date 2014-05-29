package com.accident.config.passenger

class PassengerEquipment {

    String name
    Date dateCreated
    Date lastUpdated


    static constraints = {
        name unique: true, nullable: false
    }


}
