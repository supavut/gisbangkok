package com.accident

import com.accident.config.person.CarType
import com.accident.config.person.PersonDrivingLicense
import com.accident.config.person.PersonDrug
import com.accident.config.person.PersonEquipment
import com.accident.config.person.PersonGender
import com.accident.config.person.PersonInjury


class Person {

    CarType carType
    String carRegistration
    String carBrand
    String name
    String lastName
    Integer age
    PersonGender gender
    PersonEquipment equipment
    PersonDrug drug
    String identificationCard
    PersonDrivingLicense drivingLicense
    PersonInjury injury

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
