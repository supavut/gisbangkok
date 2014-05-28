import com.accident.config.RoadAtCurrentTime
import com.accident.config.RoadLane
import com.accident.config.RoadType
import com.accident.config.SpecificArea

class BootStrap {

    def init = { servletContext ->

        String[] roadType = ["คอนกรีต", "ลาดยาง", "ลูกรัง"]
        roadType.each { name ->
            def item = new RoadType(name: name, createdDate: new Date(), updatedDate: new Date())
            item.save()
        }

        String[] specificArea = ["ถนนทั่วไป ไม่มีทางขนาน", "ทางหลัก", "ทางขนาน", "ทางเข้าหรือออกทางหลัก", "ไม่ระบุ"]
        specificArea.each { name ->
            def item = new SpecificArea(name: name, createdDate: new Date(), updatedDate: new Date())
            item.save()
        }

        String[] roadAtCurrentTime = ["ใช้งานปกติ", "มีงานบำรุงรักษา", "มีงานก่อสร้าง"]
        roadAtCurrentTime.each { name ->
            def item = new RoadAtCurrentTime(name: name, createdDate: new Date(), updatedDate: new Date())
            item.save()
        }

        String[] roadLane = ["2 ช่อง", "4 ช่อง", "6 ช่อง", "8 หรือมากกว่า"]
        roadLane.each { name ->
            def item = new RoadLane(name: name, createdDate: new Date(), updatedDate: new Date())
            item.save()
        }

    }
    def destroy = {
    }
}
