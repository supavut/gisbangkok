package com.accident



class Person {


    String carType
    String carRegistration
    String carBrand
    String name
    String lastName
    Integer age
    String gender
    String equipment
    String drug
    String identificationCard
    String drivingLicense
    String injury

    static belongsTo = [accident: Accident]
    static hasMany = [passengers: Passenger]
    static constraints = {
        carType nullable: true
        carRegistration nullable: true
        carBrand nullable: true
        name nullable: true
        lastName nullable: true
        age nullable: true
        gender nullable: true
        equipment nullable: true
        drug nullable: true
        identificationCard nullable: true
        drivingLicense nullable: true
        injury nullable: true
    }
}
