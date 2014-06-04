package com.accident.config

class AccidentType {

    String name
    Date dateCreated
    Date lastUpdated

    static constraints = {
        name unique: true, nullable: false
    }


}
