package com.accident.config.person

class PersonEquipment {

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
