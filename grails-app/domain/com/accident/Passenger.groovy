package com.accident

import com.accident.config.passenger.PassengerEquipment
import com.accident.config.passenger.PassengerGender
import com.accident.config.passenger.PassengerInjury
import com.accident.config.passenger.SeatPosition

class Passenger {

    SeatPosition seatPosition
    Integer passengerAge
    PassengerGender passengerGender
    PassengerEquipment passengerEquipment
    PassengerInjury passengerInjury

    static belongsTo = [person: Person]

    static constraints = {
        seatPosition nullable: true
        passengerAge nullable: true
        passengerGender nullable: true
        passengerEquipment nullable: true
        passengerInjury nullable: true
    }
    static mapping = {
        sort id: "asc" // or "asc"
    }
}
