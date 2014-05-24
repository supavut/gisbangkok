package com.accident

class Passenger {

    String seatPosition
    Integer passengerAge
    String passengerGender
    String passengerEquipment
    String passengerInjury

    static belongsTo = [person: Person]

    static constraints = {
        seatPosition nullable: true
        passengerAge nullable: true
        passengerGender nullable: true
        passengerEquipment nullable: true
        passengerInjury nullable: true
    }
}
