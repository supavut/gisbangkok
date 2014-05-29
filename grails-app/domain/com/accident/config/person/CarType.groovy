package com.accident.config.person

class CarType {

    String name
    Date dateCreated
    Date lastUpdated

    static constraints = {
        name unique: true, nullable: false
    }


}
