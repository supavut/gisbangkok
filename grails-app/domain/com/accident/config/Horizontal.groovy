package com.accident.config

class Horizontal {

    String name
    Date dateCreated
    Date lastUpdated



    static constraints = {
        name unique: true, nullable: false
    }


}
