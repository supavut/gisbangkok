package com.accident.config

class Weather {

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
