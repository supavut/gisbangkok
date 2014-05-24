package road_accident_phase1

import com.accident.Accident
import com.accident.DamageCost
import com.accident.Passenger
import com.accident.Person

class MainController {

    def index() {

    }

    def create() {

    }

    def save(){
        Date a =  Date.parse("MM/dd/yyyy HH:mm", params.dateAccident+" "+params.hour+":"+params.minute);
        def accident = new Accident(dateAccident:a, lat:params.lat ,lon:params.lon ,policeStation:params.policeStation
        ,roadName:params.roadName)
        if(params.isComplete!=null && params.isComplete == '1'){
            println accident.dump()
            accident.specificArea=params.specificArea

            if(params.roadAtCurrentTime!=null && params.roadAtCurrentTime == '0'){
                accident.roadAtCurrentTime = params.roadAtCurrentTimeOther
            }else{
                accident.roadAtCurrentTime = params.roadAtCurrentTime
            }

            accident.roadLane=params.roadLane
            accident.roadDirection = params.roadDirection
            accident.islandType = params.islandType
            accident.roadType = params.roadType
            accident.horizontal = params.horizontal

            if(params.intersection!=null && params.intersection == '0'){
                accident.intersection = params.intersectionOther
            }else{
                accident.intersection = params.intersection
            }

            accident.uTurn = params.uTurn
            accident.roadTypeSpecial = params.roadTypeSpecial

            if(params.accidentType!=null && params.accidentType == '0'){
                accident.accidentType = params.accidentTypeOther
            }else{
                accident.accidentType = params.accidentType
            }

            accident.roadHumidity = params.roadHumidity

            if(params.roadSurface!=null && params.roadSurface == '0'){
                accident.roadSurface = params.roadSurfaceOther
            }else{
                accident.roadSurface = params.roadSurface
            }

            if(params.weather!=null && params.weather == '0'){
                accident.weather = params.weatherOther
            }else{
                accident.weather = params.weather
            }

            accident.light = params.light

            if(params.reason!=null && params.reason == '0'){
                accident.reason = params.reasonOther
            }else{
                accident.reason = params.reason
            }

            if(params.crashPattern!=null && params.crashPattern == '0'){
                accident.crashPattern = params.crashPatternOther
            }else{
                accident.crashPattern = params.crashPattern
            }

            accident.eventDescription = params.eventDescription

            accident.isComplete = 1
            if (accident.save()) {
                def damageCost = new DamageCost()
                damageCost.adultMaleDeath = Integer.parseInt(params.adultMaleDeath)
                damageCost.adultMaleHospital = Integer.parseInt(params.adultMaleHospital)
                damageCost.adultMaleSeriousInjure = Integer.parseInt(params.adultMaleSeriousInjure)
                damageCost.adultMaleInjure = Integer.parseInt(params.adultMaleInjure)
                damageCost.adultFemaleDeath = Integer.parseInt(params.adultFemaleDeath)
                damageCost.adultFemaleHospital = Integer.parseInt(params.adultFemaleHospital)
                damageCost.adultFemaleSeriousInjure = Integer.parseInt(params.adultFemaleSeriousInjure)
                damageCost.adultFemaleInjure = Integer.parseInt(params.adultFemaleInjure)
                damageCost.childMaleDeath = Integer.parseInt(params.childMaleDeath)
                damageCost.childMaleHospital = Integer.parseInt(params.childMaleHospital)
                damageCost.childMaleSeriousInjure = Integer.parseInt(params.childMaleSeriousInjure)
                damageCost.childMaleInjure = Integer.parseInt(params.childMaleInjure)
                damageCost.childFemaleDeath = Integer.parseInt(params.childFemaleDeath)
                damageCost.childFemaleHospital = Integer.parseInt(params.childFemaleHospital)
                damageCost.childFemaleSeriousInjure = Integer.parseInt(params.childFemaleSeriousInjure)
                damageCost.childFemaleInjure = Integer.parseInt(params.childFemaleInjure)
                damageCost.accident = accident
                damageCost.save()

                if(params.carType1 !=null && params.carType1 != 'ไม่มี' ){
                    def person = new Person()
                    person.carRegistration =  params.carRegistrationA1+"-"+params.carRegistrationB1
                    person.carBrand =params.carBrand1
                    person.name = params.name1
                    person.lastName = params.lastName1
                    person.identificationCard = params.identificationCard1
                    person.drivingLicense = params.drivingLicense1
                    person.age = Integer.parseInt(params.age1)
                    person.gender = params.gender1
                    person.equipment = params.equipment1
                    person.drug = params.drug1
                    person.injury =params.injury1
                    person.accident = accident
                    person.save(flush: false)
                    if(params.seatPosition1_1 !=null && params.seatPosition1_1 != ''){
                        def passenger = new Passenger()
                        passenger.seatPosition = params.seatPosition1_1
                        passenger.passengerAge = Integer.parseInt(params.passengerAge1_1)
                        passenger.passengerGender = params.passengerGender1_1
                        passenger.passengerEquipment = params.passengerEquipment1_1
                        passenger.passengerInjury = params.passengerInjury1_1
                        passenger.person = person
                        passenger.save()
                    }
                    if(params.seatPosition1_2 !=null && params.seatPosition1_2 != ''){
                        def passenger = new Passenger()
                        passenger.seatPosition = params.seatPosition1_2
                        passenger.passengerAge = Integer.parseInt(params.passengerAge1_2)
                        passenger.passengerGender = params.passengerGender1_2
                        passenger.passengerEquipment = params.passengerEquipment1_2
                        passenger.passengerInjury = params.passengerInjury1_2
                        passenger.person = person
                        passenger.save()
                    }
                    if(params.seatPosition1_3 !=null && params.seatPosition1_3 != ''){
                        def passenger = new Passenger()
                        passenger.seatPosition = params.seatPosition1_3
                        passenger.passengerAge = Integer.parseInt(params.passengerAge1_3)
                        passenger.passengerGender = params.passengerGender1_3
                        passenger.passengerEquipment = params.passengerEquipment1_3
                        passenger.passengerInjury = params.passengerInjury1_3
                        passenger.person = person
                        passenger.save()
                    }
                }
                if(params.carType2 !=null && params.carType2 != 'ไม่มี' ){
                    def person = new Person()
                    person.carRegistration =  params.carRegistrationA2+"-"+params.carRegistrationB2
                    person.carBrand =params.carBrand2
                    person.name = params.name2
                    person.lastName = params.lastName2
                    person.identificationCard = params.identificationCard2
                    person.drivingLicense = params.drivingLicense2
                    person.age = Integer.parseInt(params.age2)
                    person.gender = params.gender2
                    person.equipment = params.equipment2
                    person.drug = params.drug2
                    person.injury =params.injury2
                    person.accident = accident
                    person.save(flush: false)
                    if(params.seatPosition2_1 !=null && params.seatPosition2_1 != ''){
                        def passenger = new Passenger()
                        passenger.seatPosition = params.seatPosition2_1
                        passenger.passengerAge = Integer.parseInt(params.passengerAge2_1)
                        passenger.passengerGender = params.passengerGender2_1
                        passenger.passengerEquipment = params.passengerEquipment2_1
                        passenger.passengerInjury = params.passengerInjury2_1
                        passenger.person = person
                        passenger.save()
                    }
                    if(params.seatPosition2_2 !=null && params.seatPosition2_2 != ''){
                        def passenger = new Passenger()
                        passenger.seatPosition = params.seatPosition2_2
                        passenger.passengerAge = Integer.parseInt(params.passengerAge2_2)
                        passenger.passengerGender = params.passengerGender2_2
                        passenger.passengerEquipment = params.passengerEquipment2_2
                        passenger.passengerInjury = params.passengerInjury2_2
                        passenger.person = person
                        passenger.save()
                    }
                    if(params.seatPosition2_3 !=null && params.seatPosition2_3 != ''){
                        def passenger = new Passenger()
                        passenger.seatPosition = params.seatPosition2_3
                        passenger.passengerAge = Integer.parseInt(params.passengerAge2_3)
                        passenger.passengerGender = params.passengerGender2_3
                        passenger.passengerEquipment = params.passengerEquipment2_3
                        passenger.passengerInjury = params.passengerInjury2_3
                        passenger.person = person
                        passenger.save()
                    }
                }
                if(params.carType3 !=null && params.carType3 != 'ไม่มี' ){
                    def person = new Person()
                    person.carRegistration =  params.carRegistrationA3+"-"+params.carRegistrationB3
                    person.carBrand =params.carBrand3
                    person.name = params.name3
                    person.lastName = params.lastName3
                    person.identificationCard = params.identificationCard3
                    person.drivingLicense = params.drivingLicense3
                    person.age = Integer.parseInt(params.age3)
                    person.gender = params.gender3
                    person.equipment = params.equipment3
                    person.drug = params.drug3
                    person.injury =params.injury3
                    person.accident = accident
                    person.save(flush: false)
                    if(params.seatPosition3_1 !=null && params.seatPosition3_1 != ''){
                        def passenger = new Passenger()
                        passenger.seatPosition = params.seatPosition3_1
                        passenger.passengerAge = Integer.parseInt(params.passengerAge3_1)
                        passenger.passengerGender = params.passengerGender3_1
                        passenger.passengerEquipment = params.passengerEquipment3_1
                        passenger.passengerInjury = params.passengerInjury3_1
                        passenger.person = person
                        passenger.save()
                    }
                    if(params.seatPosition3_2 !=null && params.seatPosition3_2 != ''){
                        def passenger = new Passenger()
                        passenger.seatPosition = params.seatPosition3_2
                        passenger.passengerAge = Integer.parseInt(params.passengerAge3_2)
                        passenger.passengerGender = params.passengerGender3_2
                        passenger.passengerEquipment = params.passengerEquipment3_2
                        passenger.passengerInjury = params.passengerInjury3_2
                        passenger.person = person
                        passenger.save()
                    }
                    if(params.seatPosition3_3 !=null && params.seatPosition3_3 != ''){
                        def passenger = new Passenger()
                        passenger.seatPosition = params.seatPosition3_3
                        passenger.passengerAge = Integer.parseInt(params.passengerAge3_3)
                        passenger.passengerGender = params.passengerGender3_3
                        passenger.passengerEquipment = params.passengerEquipment3_3
                        passenger.passengerInjury = params.passengerInjury3_3
                        passenger.person = person
                        passenger.save()
                    }
                }
            }
            [id:accident.id]
           // redirect(controller: "main", action: "create")
        }else{
            accident.isComplete = 0
            if (!accident.save()) {
                accident.errors.each {
                    println it
                }
            }else{
                [id:accident.id]
               // redirect(controller: "main", action: "create")
            }

        }

        //println params
    }

    def edit() {

    }
}
