package com.accident.config

class Intersection {

    String name
    Date dateCreated
    Date lastUpdated



    static constraints = {
        name unique: true, nullable: false
    }


}
