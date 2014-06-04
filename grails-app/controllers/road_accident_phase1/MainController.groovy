package road_accident_phase1

import com.accident.Accident
import com.accident.DamageCost
import com.accident.Passenger
import com.accident.Person
import com.accident.config.AccidentType
import com.accident.config.CrashPattern
import com.accident.config.Horizontal
import com.accident.config.Intersection
import com.accident.config.IslandType
import com.accident.config.Light
import com.accident.config.Reason
import com.accident.config.RoadAtCurrentTime
import com.accident.config.RoadDirection
import com.accident.config.RoadHumidity
import com.accident.config.RoadLane
import com.accident.config.RoadSurface
import com.accident.config.RoadType
import com.accident.config.RoadTypeSpecial
import com.accident.config.SpecificArea
import com.accident.config.UTurn
import com.accident.config.Weather
import com.accident.config.passenger.PassengerEquipment
import com.accident.config.passenger.PassengerGender
import com.accident.config.passenger.PassengerInjury
import com.accident.config.passenger.SeatPosition
import com.accident.config.person.CarType
import com.accident.config.person.PersonDrivingLicense
import com.accident.config.person.PersonDrug
import com.accident.config.person.PersonEquipment
import com.accident.config.person.PersonGender
import com.accident.config.person.PersonInjury
import grails.plugin.springsecurity.annotation.Secured

@Secured('ROLE_ADMIN')
class MainController {

    def index() {

    }

    def create() {


        def roadAtCurrentTime = RoadAtCurrentTime.createCriteria().list{gt('id',0L)}
        roadAtCurrentTime.add(RoadAtCurrentTime.findById(-1))

        def intersection =  Intersection.createCriteria().list{gt('id',0L)}
        intersection.add(Intersection.findById(-1))

        def roadSurface = RoadSurface.createCriteria().list{gt('id',0L)}
        roadSurface.add(RoadSurface.findById(-1))

        def weather = Weather.createCriteria().list{gt('id',0L)}
        weather.add(Weather.findById(-1))

        def reason = Reason.createCriteria().list{gt('id',0L)}
        reason.add(Reason.findById(-1))

        def accidentType = AccidentType.createCriteria().list{gt('id',0L)}
        accidentType.add(AccidentType.findById(-1))

        def crashPattern = CrashPattern.createCriteria().list{gt('id',0L)}
        crashPattern.add(CrashPattern.findById(-1));



        [specificArea: SpecificArea.findAll(),
                roadAtCurrentTime:roadAtCurrentTime,
                roadLane:RoadLane.findAll(),
                roadDirection:RoadDirection.findAll(),
                islandType:IslandType.findAll(),
                roadType:RoadType.findAll(),
                horizontal:Horizontal.findAll(),
                intersection:intersection,
                uTurn:UTurn.findAll(),
                roadTypeSpecial:RoadTypeSpecial.findAll(),
                roadHumidity:RoadHumidity.findAll(),
                roadSurface:roadSurface,
                weather:weather,
                light:Light.findAll(),
                reason:reason,
                accidentType:accidentType,
                crashPattern:crashPattern,
                carType:CarType.findAll(),
                personGender:PersonGender.findAll(),
                personEquipment:PersonEquipment.findAll(),
                personDrug:PersonDrug.findAll(),
                personDrivingLicense:PersonDrivingLicense.findAll(),
                personInjury:PersonInjury.findAll(),
                seatPosition:SeatPosition.findAll(),
                passengerGender:PassengerGender.findAll(),
                passengerEquipment:PassengerEquipment.findAll(),
                passengerInjury:PassengerInjury.findAll()]
    }

    def save(){
        Date a =  Date.parse("MM/dd/yyyy HH:mm", params.dateAccident+" "+params.hour+":"+params.minute);
        def accident = new Accident()
        accident.dateAccident = a
        accident.lat =Double.parseDouble(params.lat)
        accident.lon = Double.parseDouble(params.lon)
        accident.policeStation = params.policeStation
        accident.roadName = params.roadName
        accident.bookPage = params.bookPage
        accident.caseId = params.caseId

        if(params.isComplete && params.isComplete == '1'){
            accident.specificArea=params.specificArea?SpecificArea.findById(Long.parseLong(params.specificArea)):null

            accident.roadAtCurrentTime=params.roadAtCurrentTime?RoadAtCurrentTime.findById(Long.parseLong(params.roadAtCurrentTime)):null

            if(params.roadAtCurrentTime!=null && params.roadAtCurrentTime == '-1'){
                accident.roadAtCurrentTimeDetail = params.roadAtCurrentTimeDetail
            }

            accident.roadLane= params.roadLane?RoadLane.findById(Long.parseLong(params.roadLane)):null

            accident.roadDirection= params.roadDirection?RoadDirection.findById(Long.parseLong(params.roadDirection)):null

            accident.islandType= params.islandType?IslandType.findById(Long.parseLong(params.islandType)):null

            accident.roadType= params.roadType?RoadType.findById(Long.parseLong(params.roadType)):null

            accident.horizontal= params.horizontal?Horizontal.findById(Long.parseLong(params.horizontal)):null

            accident.intersection= params.intersection?Intersection.findById(Long.parseLong(params.intersection)):null

            if(params.intersection!=null && params.intersection == '-1'){
                accident.intersectionDetail = params.intersectionDetail
            }

            accident.uTurn= params.uTurn?UTurn.findById(Long.parseLong(params.uTurn)):null

            accident.roadTypeSpecial= params.roadTypeSpecial?RoadTypeSpecial.findById(Long.parseLong(params.roadTypeSpecial)):null

            accident.accidentType= params.accidentType?AccidentType.findById(Long.parseLong(params.accidentType)):null

            if(params.accidentType!=null && params.accidentType == '-1'){
                accident.accidentTypeDetail = params.accidentTypeDetail
            }

            accident.roadHumidity= params.roadHumidity?RoadHumidity.findById(Long.parseLong(params.roadHumidity)):null

            accident.roadSurface= params.roadSurface?RoadSurface.findById(Long.parseLong(params.roadSurface)):null

            if(params.roadSurface!=null && params.roadSurface == '0'){
                accident.roadSurfaceDetail = params.roadSurfaceDetail
            }

            accident.weather= params.weather?Weather.findById(Long.parseLong(params.weather)):null

            if(params.weather!=null && params.weather == '0'){
                accident.weatherDetail = params.weatherDetail
            }

            accident.light= params.light?Light.findById(Long.parseLong(params.light)):null

            accident.reason= params.reason?Reason.findById(Long.parseLong(params.reason)):null

            if(params.reason!=null && params.reason == '0'){
                accident.reasonDetail = params.reasonDetail
            }

            accident.crashPattern= params.crashPattern?CrashPattern.findById(Long.parseLong(params.crashPattern)):null

            if(params.crashPattern!=null && params.crashPattern == '0'){
                accident.crashPatternDetail = params.crashPatternDetail
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
                for (int i=1;i<=Integer.parseInt(params.countPerson);i++){
                    def person = new Person();
                    person.carType = params.get('carType_'+i)?CarType.findById(Long.parseLong(params.get('carType_'+i))):null
                    person.carRegistration = params.get("carRegistration_"+i)
                    person.carBrand = params.get("carBrand_"+i)
                    person.name = params.get("name_"+i)
                    person.lastName = params.get("lastName_"+i)
                    person.identificationCard = params.get("identificationCard_"+i)
                    person.drivingLicense  = params.get('personDrivingLicense_'+i)?PersonDrivingLicense.findById(Long.parseLong(params.get('personDrivingLicense_'+i))):null
                    person.age = params.get("age_"+i)?Integer.parseInt(params.get("age_"+i)):null
                    person.gender = params.get('personGender_'+i)?PersonGender.findById(Long.parseLong(params.get('personGender_'+i))):null
                    person.equipment = params.get('personEquipment_'+i)?PersonEquipment.findById(Long.parseLong(params.get('personEquipment_'+i))):null
                    person.drug = params.get('personDrug_'+i)?PersonDrug.findById(Long.parseLong(params.get('personDrug_'+i))):null
                    person.injury = params.get('personInjury_'+i)?PersonInjury.findById(Long.parseLong(params.get('personInjury_'+i))):null
                    person.accident = accident
                    person.save()
                    int countPassenger =params.get("countPassenger_"+i)?Integer.parseInt(params.get("countPassenger_"+i)):0
                    for (int j=1;j<=countPassenger  ;j++){
                        def passenger = new Passenger()
                        passenger.seatPosition = params.get('seatPosition_'+i+'_'+j)?SeatPosition.findById(Long.parseLong(params.get('seatPosition_'+i+'_'+j))):null
                        passenger.passengerAge = params.get('passengerAge_'+i+'_'+j)?Integer.parseInt(params.get('passengerAge_'+i+'_'+j)):null
                        passenger.passengerGender = params.get('passengerGender_'+i+'_'+j)?PassengerGender.findById(Long.parseLong(params.get('passengerGender_'+i+'_'+j))):null
                        passenger.passengerEquipment = params.get('passengerEquipment_'+i+'_'+j)?PassengerEquipment.findById(Long.parseLong(params.get('passengerEquipment_'+i+'_'+j))):null
                        passenger.passengerInjury = params.get('passengerInjury_'+i+'_'+j)?PassengerInjury.findById(Long.parseLong(params.get('passengerInjury_'+i+'_'+j))):null
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

    def list() {
        def accidents =  Accident.findAll();
        [accidents:accidents]
    }

    def edit(){


        if(params.editAction == null){
            def roadAtCurrentTime = RoadAtCurrentTime.createCriteria().list{gt('id',0L)}
            roadAtCurrentTime.add(RoadAtCurrentTime.findById(-1))

            def intersection =  Intersection.createCriteria().list{gt('id',0L)}
            intersection.add(Intersection.findById(-1))

            def roadSurface = RoadSurface.createCriteria().list{gt('id',0L)}
            roadSurface.add(RoadSurface.findById(-1))

            def weather = Weather.createCriteria().list{gt('id',0L)}
            weather.add(Weather.findById(-1))

            def reason = Reason.createCriteria().list{gt('id',0L)}
            reason.add(Reason.findById(-1))

            def accidentType = AccidentType.createCriteria().list{gt('id',0L)}
            accidentType.add(AccidentType.findById(-1))

            def crashPattern = CrashPattern.createCriteria().list{gt('id',0L)}
            crashPattern.add(CrashPattern.findById(-1));

            def selectId = Integer.parseInt(params.selectId)
            def selectAccident =  Accident.get(selectId);
            if(params.editView == '1'){
                render(view: 'edit1',model:[accident:selectAccident])
            }else{
                render(view: 'edit2',model:[accident:selectAccident,specificArea: SpecificArea.findAll(),
                        roadAtCurrentTime:roadAtCurrentTime,
                        roadLane:RoadLane.findAll(),
                        roadDirection:RoadDirection.findAll(),
                        islandType:IslandType.findAll(),
                        roadType:RoadType.findAll(),
                        horizontal:Horizontal.findAll(),
                        intersection:intersection,
                        uTurn:UTurn.findAll(),
                        roadTypeSpecial:RoadTypeSpecial.findAll(),
                        roadHumidity:RoadHumidity.findAll(),
                        roadSurface:roadSurface,
                        weather:weather,
                        light:Light.findAll(),
                        reason:reason,
                        accidentType:accidentType,
                        crashPattern:crashPattern,
                        carType:CarType.findAll(),
                        personGender:PersonGender.findAll(),
                        personEquipment:PersonEquipment.findAll(),
                        personDrug:PersonDrug.findAll(),
                        personDrivingLicense:PersonDrivingLicense.findAll(),
                        personInjury:PersonInjury.findAll(),
                        seatPosition:SeatPosition.findAll(),
                        passengerGender:PassengerGender.findAll(),
                        passengerEquipment:PassengerEquipment.findAll(),
                        passengerInjury:PassengerInjury.findAll()])
            }

        }else  if(params.editAction == '1'){
            def accidentId = Integer.parseInt(params.accidentId)
            def selectAccident =  Accident.get(accidentId);
            selectAccident.lat = Double.parseDouble(params.lat);
            selectAccident.lon = Double.parseDouble(params.lon);
            selectAccident.save();
            redirect(controller: 'main',action: 'list');
        }else{
            Date a =  Date.parse("MM/dd/yyyy HH:mm", params.dateAccident+" "+params.hour+":"+params.minute);
            def accident = Accident.findById(Long.parseLong(params.accidentId))
            accident.dateAccident = a
            accident.lat =Double.parseDouble(params.lat)
            accident.lon = Double.parseDouble(params.lon)
            accident.policeStation = params.policeStation
            accident.roadName = params.roadName
            accident.bookPage = params.bookPage
            accident.caseId = params.caseId

            if(params.isComplete && params.isComplete == '1'){
                accident.specificArea=params.specificArea?SpecificArea.findById(Long.parseLong(params.specificArea)):null

                accident.roadAtCurrentTime=params.roadAtCurrentTime?RoadAtCurrentTime.findById(Long.parseLong(params.roadAtCurrentTime)):null

                if(params.roadAtCurrentTime!=null && params.roadAtCurrentTime == '-1'){
                    accident.roadAtCurrentTimeDetail = params.roadAtCurrentTimeDetail
                }

                accident.roadLane= params.roadLane?RoadLane.findById(Long.parseLong(params.roadLane)):null

                accident.roadDirection= params.roadDirection?RoadDirection.findById(Long.parseLong(params.roadDirection)):null

                accident.islandType= params.islandType?IslandType.findById(Long.parseLong(params.islandType)):null

                accident.roadType= params.roadType?RoadType.findById(Long.parseLong(params.roadType)):null

                accident.horizontal= params.horizontal?Horizontal.findById(Long.parseLong(params.horizontal)):null

                accident.intersection= params.intersection?Intersection.findById(Long.parseLong(params.intersection)):null

                if(params.intersection!=null && params.intersection == '-1'){
                    accident.intersectionDetail = params.intersectionDetail
                }

                accident.uTurn= params.uTurn?UTurn.findById(Long.parseLong(params.uTurn)):null

                accident.roadTypeSpecial= params.roadTypeSpecial?RoadTypeSpecial.findById(Long.parseLong(params.roadTypeSpecial)):null

                accident.accidentType= params.accidentType?AccidentType.findById(Long.parseLong(params.accidentType)):null

                if(params.accidentType!=null && params.accidentType == '-1'){
                    accident.accidentTypeDetail = params.accidentTypeDetail
                }

                accident.roadHumidity= params.roadHumidity?RoadHumidity.findById(Long.parseLong(params.roadHumidity)):null

                accident.roadSurface= params.roadSurface?RoadSurface.findById(Long.parseLong(params.roadSurface)):null

                if(params.roadSurface!=null && params.roadSurface == '0'){
                    accident.roadSurfaceDetail = params.roadSurfaceDetail
                }

                accident.weather= params.weather?Weather.findById(Long.parseLong(params.weather)):null

                if(params.weather!=null && params.weather == '0'){
                    accident.weatherDetail = params.weatherDetail
                }

                accident.light= params.light?Light.findById(Long.parseLong(params.light)):null

                accident.reason= params.reason?Reason.findById(Long.parseLong(params.reason)):null

                if(params.reason!=null && params.reason == '0'){
                    accident.reasonDetail = params.reasonDetail
                }

                accident.crashPattern= params.crashPattern?CrashPattern.findById(Long.parseLong(params.crashPattern)):null

                if(params.crashPattern!=null && params.crashPattern == '0'){
                    accident.crashPatternDetail = params.crashPatternDetail
                }

                accident.eventDescription = params.eventDescription

                accident.isComplete = 1

                if (accident.save()) {
                    def damageCost = accident.damageCost
                    if(!(damageCost)){
                        damageCost = new DamageCost()
                        damageCost.accident = accident
                    }
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
                    damageCost.save()
                    for (int i=1;i<=Integer.parseInt(params.countPerson);i++){
                        def personId =  Long.parseLong(params.get('personId_'+i))
                        def person
                        if(personId==0){
                            person= new Person();
                            person.accident = accident
                        }else{
                            person= Person.findById(personId)
                        }
                        person.carType = params.get('carType_'+i)?CarType.findById(Long.parseLong(params.get('carType_'+i))):null
                        person.carRegistration = params.get("carRegistration_"+i)
                        person.carBrand = params.get("carBrand_"+i)
                        person.name = params.get("name_"+i)
                        person.lastName = params.get("lastName_"+i)
                        person.identificationCard = params.get("identificationCard_"+i)
                        person.drivingLicense  = params.get('personDrivingLicense_'+i)?PersonDrivingLicense.findById(Long.parseLong(params.get('personDrivingLicense_'+i))):null
                        person.age = params.get("age_"+i)?Integer.parseInt(params.get("age_"+i)):null
                        person.gender = params.get('personGender_'+i)?PersonGender.findById(Long.parseLong(params.get('personGender_'+i))):null
                        person.equipment = params.get('personEquipment_'+i)?PersonEquipment.findById(Long.parseLong(params.get('personEquipment_'+i))):null
                        person.drug = params.get('personDrug_'+i)?PersonDrug.findById(Long.parseLong(params.get('personDrug_'+i))):null
                        person.injury = params.get('personInjury_'+i)?PersonInjury.findById(Long.parseLong(params.get('personInjury_'+i))):null
                        person.save()
                        println "Data to do" + params.get("countPassenger_"+i);

                        int countPassenger =Integer.parseInt(params.get("countPassenger_"+i))
                        for (int j=1;j<=countPassenger  ;j++){
                            def passenger
                            def passengerId = Long.parseLong(params.get('passengerId_'+i+'_'+j))
                            if(passengerId==0){
                                passenger = new Passenger()
                                passenger.person = person
                            }else{
                                passenger = Passenger.findById(passengerId)
                            }
                            passenger.seatPosition = params.get('seatPosition_'+i+'_'+j)?SeatPosition.findById(Long.parseLong(params.get('seatPosition_'+i+'_'+j))):null
                            passenger.passengerAge = params.get('passengerAge_'+i+'_'+j)?Integer.parseInt(params.get('passengerAge_'+i+'_'+j)):null
                            passenger.passengerGender = params.get('passengerGender_'+i+'_'+j)?PassengerGender.findById(Long.parseLong(params.get('passengerGender_'+i+'_'+j))):null
                            passenger.passengerEquipment = params.get('passengerEquipment_'+i+'_'+j)?PassengerEquipment.findById(Long.parseLong(params.get('passengerEquipment_'+i+'_'+j))):null
                            passenger.passengerInjury = params.get('passengerInjury_'+i+'_'+j)?PassengerInjury.findById(Long.parseLong(params.get('passengerInjury_'+i+'_'+j))):null
                            passenger.save()
                        }
                    }
                }
                 redirect(controller: "main", action: "list")
            }else{
                accident.isComplete = 0
                if (!accident.save()) {
                    accident.errors.each {
                        println it
                    }
                }else{
                     redirect(controller: "main", action: "list")
                }

            }

        }

    }
}
