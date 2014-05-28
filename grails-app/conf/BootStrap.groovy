import com.accident.config.RoadType

class BootStrap {

    def init = { servletContext ->
        String[] roadType = ["Dry", "Wet", "Icy"]
        roadType.each { st ->
            def status = new RoadType(name: st, createdDate: new Date(), updatedDate: new Date())
            status.save()
        }


    }
    def destroy = {
    }
}
