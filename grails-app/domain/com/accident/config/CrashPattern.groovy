package com.accident.config

class CrashPattern {

    String name
    Date dateCreated
    Date lastUpdated


    static constraints = {
        name unique: true, nullable: false
    }


}
