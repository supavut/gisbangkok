package com.accident.config.person

class CarType {

    String name
    Date createdDate
    Date updatedDate

    static constraints = {
        name unique: true, nullable: false
    }

    static mapping = {
        createdDate defaultValue: "now()"
        updatedDate defaultValue: "now()"
    }
}
