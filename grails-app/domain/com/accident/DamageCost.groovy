package com.accident

class DamageCost {

  Integer adultMaleDeath
  Integer adultMaleHospital
  Integer adultMaleSeriousInjure
  Integer adultMaleInjure
  Integer adultFemaleDeath
  Integer adultFemaleHospital
  Integer adultFemaleSeriousInjure
  Integer adultFemaleInjure
  Integer childMaleDeath
  Integer childMaleHospital
  Integer childMaleSeriousInjure
  Integer childMaleInjure
  Integer childFemaleDeath
  Integer childFemaleHospital
  Integer childFemaleSeriousInjure
  Integer childFemaleInjure

  static belongsTo = [accident:Accident]

  static constraints = {
  }
}
