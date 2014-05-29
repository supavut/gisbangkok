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

class BootStrap {

    def init = { servletContext ->



        String[] specificArea = ["ถนนทั่วไป ไม่มีทางขนาน", "ทางหลัก", "ทางขนาน", "ทางเข้าหรือออกทางหลัก", "ไม่ระบุ"]
        specificArea.each { name ->

            def item = new SpecificArea(name: name)
            item.save()
        }

       // sql.execute("INSERT INTO  `test`.`road_at_current_time` (`id` ,`version` ,`created_date` ,`name` ,`updated_date`)VALUES ('-1',  '',CURRENT_TIMESTAMP ,  'อื่นๆ , 'CURRENT_TIMESTAM );")
        String[] roadAtCurrentTime = ["ใช้งานปกติ", "มีงานบำรุงรักษา", "มีงานก่อสร้าง"]
        roadAtCurrentTime.each { name ->
            def item = new RoadAtCurrentTime(name: name)
            item.save()
        }

        String[] roadLane = ["2 ช่อง", "4 ช่อง", "6 ช่อง", "8 หรือมากกว่า"]
        roadLane.each { name ->
            def item = new RoadLane(name: name)
            item.save()
        }

        String[] roadDirection = ["มุ่งเหนือ", "มุ่งใต้", "มุ่งตะวันออก", "มุ่งตะวันตก"]
        roadDirection.each { name ->
            def item = new RoadDirection(name: name)
            item.save()
        }

        String[] islandType = ["ไม่มีเกาะกลาง", "เกาะกลางแบบสี", "เกาะกลางแบบถมยกขึ้น", "มีอุปกรณ์กั้นกลางถนน", "เกาะกลางแบบร่อง", "ไม่ระบุ"]
        islandType.each { name ->
            def item = new IslandType(name: name)
            item.save()
        }

        String[] roadType = ["คอนกรีต", "ลาดยาง", "ลูกรัง"]
        roadType.each { name ->
            def item = new RoadType(name: name)
            item.save()
        }

        String[] horizontal = ["ทางตรง", "ทางโค้งปกติ", "ทางโค้งหักศอก"]
        horizontal.each { name ->
            def item = new Horizontal(name: name)
            item.save()
        }


        String[] intersection = ["ไม่ได้เกิดเหตุที่ทางแยก", "ทางแยกรูปตัว +", "ทางแยกรูปตัว T", "ทางแยกรูปตัว Y", "วงเวียน", "ทางแยกต่างระดับ(Ramps)", "ทางแยกเข้าซอย/ทางเชื่อม"]
        intersection.each { name ->
            def item = new Intersection(name: name)
            item.save()
        }

        String[] uTurn = ["ไม่ได้เกิดเหตุที่จุดยูเทิร์น", "จุดยูเทิร์น มีช่องลดความเร็ว", "จุดยูเทิร์น ไม่มีช่องลดความเร็ว"]
        uTurn.each { name ->
            def item = new UTurn(name: name)
            item.save()
        }

        String[] roadTypeSpecial = ["ทางรถจักรยานยนต์", "ทางจักรยาน", "ทางคนเดินเท้า", "ทางม้าลาย", "สะพาน", "ทางลอด", "ทางรถไฟตัดผ่าน", "มีการเปลี่ยนความกว้างของช่องจราจร", "จุดกลับรถต่างระดับ", "บริเวณที่เกิดเหตุไม่มีลักษณะเฉพาะที่กล่าวมา"]
        roadTypeSpecial.each { name ->
            def item = new RoadTypeSpecial(name: name)
            item.save()
        }

        String[] roadHumidity = ["เปียก", "แห้ง"]
        roadHumidity.each { name ->
            def item = new RoadHumidity(name: name)
            item.save()
        }

        String[] roadSurface = ["ดี", "สกปรก", "เป็นคลื่น/หลุม/บ่อ"]
        roadSurface.each { name ->
            def item = new RoadSurface(name: name)
            item.save()
        }

        String[] weather = ["แจ่มใส", "ฝนตก", "มีควัน/ฝุ่น", "มีหมอก"]
        weather.each { name ->
            def item = new Weather(name: name)
            item.save()
        }

        String[] light = ["มีแสงสว่างเพียงพอ", "ไม่มีแสงสว่างเพียงพอ", "ไม่ระบุ"]
        light.each { name ->
            def item = new Light(name: name)
            item.save()
        }

        String[] reason = ["ขับรถเร็วเกินอัตราที่กำหนด", "ขับรถตัดหน้าระยะกระชั้นชิด", "แซงรถอย่างผิดกฎหมาย", "ขับรถตามระยะกระชั้นชิด", "ไม่ให้สัญญาณชะลอ/เลี้ยว",
        "ขับรถไม่เปิดไฟ/ไม่ใช้แสงสว่างตามกำหนด", "ไม่ให้สิทธิรถที่มาก่อนผ่านทาง เช่น ทางแยก", "ไม่ให้สัญญาณเข้าจอดหรือออกจากที่จอด", "ฝ่าฝืนป้ายหยุดขณะออกจากทางร่วม/ทางแยก",
        "รถเสียไม่แสดงเครื่องหมายหรือสัญญาณไฟที่กำหนด", "ไม่ขับรถในช่องทางเดินรถซ้ายสุดในถนนที่มี4 ช่องทาง", "ฝ่าฝืนสัญญาณไฟ/เครื่องหมาย", "ขับรถไม่ชำนาญ/ไม่เป็น",
        "บรรทุกเกินอัตรา", "มีสิ่งกีดขวางบนถนน", "อุปกรณ์รถบกพร่อง", "หลับใน", "เมาสุรา", "ชะลอ/หยุดรถกะทันหัน", "ขับรถโดยประมาท/ไม่ระมัดระวัง"]
        reason.each { name ->
            def item = new Reason(name: name)
            item.save()
        }

        String[] accidentType = ["รถยนต์ ชน รถยนต์", "จยย. ชน จยย.", "รถยนต์ ชน รถไฟ", "จยย. ชน รถยนต์", "รถยนต์ ชน จยย.", "จยย. ชน รถจักรยาน/รถสามล้อ",
        "รถยนต์ ชน รถจักรยาน/รถสามล้อ", "จยย. ชน คน", "รถยนต์ ชน คน", "จยย. ชน สัตว์/รถลากจูงด้วยสัตว์", "รถยนต์ ชน สัตว์/รถลากจูงด้วยสัตว์", "จยย. ชน วัตถุ/สิ่งของ",
        "รถยนต์ ชน วัตถุ/สิ่งของ", "จยย. พลิกคว่ำ/ตกถนน", "รถยนต์ พลิกคว่ำ/ตกถนน"]
        accidentType.each { name ->
            def item = new AccidentType(name: name)
            item.save()
        }

        String[] crashPattern = ["ชนที่ทางแยก", "ชนที่จุดยูเทิร์น", "ชนประสานงา", "ชนท้าย", "ชนด้านข้าง", "พลิกคว่ำ/ตกถนน", "ชนสิ่งกีดขวางข้างทาง", "เสียหลัก/ล้มเอง"]
        crashPattern.each { name ->
            def item = new CrashPattern(name: name)
            item.save()
        }

        String[] carType = ["รถจักรยาน",
                            "รถจักรยานยนต์",
                            "รถสามล้อ",
                            "รถสามล้อเครื่อง",
                            "รถยนต์นั่ง",
                            "รถตู้",
                            "รถปิคอัพโดยสาร",
                            "รถปิคอัพบรรทุก 4 ล้อ",
                            "รถโดยสารขนาดใหญ่",
                            "รถบรรทุก 6 ล้อ",
                            "รถบรรทุกมากกว่า6 ล้อไม่เกิน10 ล้อ",
                            "รถบรรทุกมากกว่า10 ล้อ(รถพ่วง)",
                            "รถอีแต๋น",
                            "รถอื่นๆ(ระบุ)",
                            "คนเดินเท้า"
        ]
        carType.each { name ->
            def item = new CarType(name: name)
            item.save()
        }

        String[] gender = ["ชาย", "หญิง"]
        gender.each { name ->
            def item = new PersonGender(name: name)
            item.save()
        }

        String[] equipment = ["หมวกนิรภัย",
                              "เข็มขัดนิรภัย",
                              "ไม่ใช้",
                              "ไม่ระบุ"
        ]
        equipment.each { name ->
            def item = new PersonEquipment(name: name)
            item.save()
        }

        String[] drug = ["มี",
                         "ไม่มี",
                         "ไม่ระบุ"
        ]
        drug.each { name ->
            def item = new PersonDrug(name: name)
            item.save()
        }

        String[] drivingLicense = ["มี",
                         "ไม่มี",
                         "ไม่ระบุ"
        ]
        drivingLicense.each { name ->
            def item = new PersonDrivingLicense(name: name)
            item.save()
        }

        String[] personInjury = ["ตายที่จุดเกิดเหตุ",
                                 "ตายที่โรงพยาบาล",
                                 "บาดเจ็บสาหัส",
                                 "บาดเจ็บเล็กน้อย",
                                 "ไม่บาดเจ็บ",
        ]
        personInjury.each { name ->
            def item = new PersonInjury(name: name)
            item.save()
        }

        String[] seatPosition = ["ซ้อนท้าย จยย.",
                                 "ด้านหน้ารถยนต์",
                                 "ด้านหลังรถยนต์",
                                 "ไม่ระบุ",
        ]
        seatPosition.each { name ->
            def item = new SeatPosition(name: name)
            item.save()
        }

        String[] passengerGender = ["ชาย", "หญิง"]
        passengerGender.each { name ->
            def item = new PassengerGender(name: name)
            item.save()
        }

        String[] passengerEquipment = ["หมวกนิรภัย",
                                       "เข็มขัดนิรภัย",
                                       "ไม่ใช้",
                                       "ไม่ระบุ",
        ]
        passengerEquipment.each { name ->
            def item = new PassengerEquipment(name: name)
            item.save()
        }

        String[] passengerInjury = ["ตายที่จุดเกิดเหตุ",
                                    "ตายที่โรงพยาบาล",
                                    "บาดเจ็บสาหัส",
                                    "บาดเจ็บเล็กน้อย",
                                    "ไม่บาดเจ็บ",
        ]
        passengerInjury.each { name ->
            def item = new PassengerInjury(name: name)
            item.save()
        }

    }
    def destroy = {
    }
}
