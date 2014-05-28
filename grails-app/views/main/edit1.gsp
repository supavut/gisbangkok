<%--
  Created by IntelliJ IDEA.
  User: Home
  Date: 5/25/14
  Time: 1:01 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
<head>
    <title>Create</title>
    <meta name="layout" content="bangkokLayout"/>
    <!-- Openlayers -->
<g:javascript src="OpenLayers-2.13.1/OpenLayers.js"/>
<script src="http://maps.google.com/maps/api/js?v=3&amp;sensor=false"></script>
<script>
    var drawControls;
    var draw_point;
    var click;
    var map;
    var vector;
    var geocoder = null;
    OpenLayers.Control.Click = OpenLayers.Class(OpenLayers.Control, {
        defaultHandlerOptions: {
            'single': true,
            'double': false,
            'pixelTolerance': 0,
            'stopSingle': false,
            'stopDouble': false
        },

        initialize: function (options) {
            this.handlerOptions = OpenLayers.Util.extend(
                    {}, this.defaultHandlerOptions
            );
            OpenLayers.Control.prototype.initialize.apply(
                    this, arguments
            );
            this.handler = new OpenLayers.Handler.Click(
                    this, {
                        'click': this.trigger
                    }, this.handlerOptions
            );
        },

        trigger: function (e) {
            var clickPosition = map.getLonLatFromPixel(e.xy);
            drawPoint(clickPosition.lat, clickPosition.lon);
            console.log("You clicked near lat: " + clickPosition.lat + " N, lon: " + +clickPosition.lon + " E");
        }

    });
    var mode = '0';
    var currentPoint;
    var newPoint = 1;

    function init() {
        map = new OpenLayers.Map("map-canvas");

        //restrict to focus only bangkok area
        //map.setOptions({restrictedExtent: new OpenLayers.Bounds(8, 44.5, 19, 50)});

        //create based layer
        var gmap = new OpenLayers.Layer.Google("Google Streets", {numZoomLevels: 20});

        //create vector layer
        vector = new OpenLayers.Layer.Vector("Vectors", {
                    style: {
                        externalGraphic: "${resource(dir: 'images', file: 'marker.png')}",
                        graphicWidth: 21,
                        graphicHeight: 25,
                        graphicYOffset: -24
                    }
                }
        );
        map.addLayers([gmap, vector]);

      /*  var p1 = new OpenLayers.Geometry.Point(parseFloat(${accident.lon}), parseFloat(${accident.lat}));
        var point = new OpenLayers.Feature.Vector(p1);
        vector.addFeatures(point);*/

        //set map center
        var BangkokPosition = new OpenLayers.LonLat("11193299.296468", "1545835.5748853");
        map.setCenter(BangkokPosition, 12);
        currentPoint = BangkokPosition;
        //map.addControl(new OpenLayers.Control.LayerSwitcher());

        drawPoint("${accident.lat}","${accident.lon}");

        //add click event
        click = new OpenLayers.Control.Click();
        map.addControl(click);
        click.activate();

       //createTime();

        $(function () {
            $("#datepicker").datepicker({
                changeMonth: true,
                changeYear: true
            });
        });

        geocoder = new google.maps.Geocoder();

    }

    function toggleStreetView() {
        if(mode == 0){
            var projWGS84 = new OpenLayers.Projection("EPSG:4326");
            var proj900913 = new OpenLayers.Projection("EPSG:900913");
            var point2
            if(newPoint==1){
                point2 =  currentPoint.transform(proj900913, projWGS84);
                newPoint=0;
            }else{
                point2=currentPoint;
            }
            //console.log(point2.lat);
            //console.log(point2.lon);
            document.getElementById("map-canvas").style.display='none';
            document.getElementById("street-view").style.display='block';
            var fenway = new google.maps.LatLng(point2.lat,point2.lon);
            var panoOptions = {
                position: fenway,
                addressControlOptions: {
                    position: google.maps.ControlPosition.BOTTOM
                },
                linksControl: false,
                panControl: false,
                zoomControlOptions: {
                    style: google.maps.ZoomControlStyle.SMALL
                },
                enableCloseButton: false,
                visible:true
            };

            var panorama = new google.maps.StreetViewPanorama(
                    document.getElementById("street-view"), panoOptions);
            mode = 1;
        }else{
            document.getElementById("map-canvas").style.display='block';
            document.getElementById("street-view").style.display='none';
            mode = 0;
        }

    }

    function getAddress() {

        var addr = document.getElementById("address").value;
        var SearchPosition;
        //alert(addr);
        geocoder.geocode({'address': addr}, function (results, status) {
            console.log("latitude : " + results[0].geometry.location.lat());
            console.log("longitude : " + results[0].geometry.location.lng());
            var lat = results[0].geometry.location.lat();
            var lon = results[0].geometry.location.lng();
            SearchPosition = new OpenLayers.LonLat(lon, lat);
            map.setCenter(SearchPosition.transform(
                    new OpenLayers.Projection("EPSG:4326"),
                    map.getProjectionObject()
            ), 17);
        });
    }
    function drawPoint(lat, lon) {
        vector.removeAllFeatures();
        var p1 = new OpenLayers.Geometry.Point(parseFloat(lon), parseFloat(lat));
        currentPoint =  new OpenLayers.LonLat(parseFloat(lon),  parseFloat(lat));
        newPoint = 1;
        var point = new OpenLayers.Feature.Vector(p1);
        vector.addFeatures(point);
        document.getElementById("lat").value = lat;
        document.getElementById("lon").value = lon;
    }
    function reset() {
        vector.removeAllFeatures();
        document.getElementById("lat").value = "";
        document.getElementById("lon").value = "";
    }
   /* function createTime() {
        var min = 00,
                max = 55,
                plus = 5,
                select = document.getElementById('minute');

        for (var i = min; i <= max; i = i + plus) {
            var opt = document.createElement('option');
            opt.value = i;
            opt.innerHTML = i;
            select.appendChild(opt);
        }
        var hourMin = 00;
        var hourMax = 24;
        select = document.getElementById('hour');

        for (var i = hourMin; i <= hourMax; i++) {
            var opt = document.createElement('option');
            opt.value = i;
            opt.innerHTML = i;
            select.appendChild(opt);
        }
    }*/

    window.onload = init;
</script>
<script>
    function isNumber(e) {
        e = e || window.event;
        var charCode = e.which ? e.which : e.keyCode;
        return /\d/.test(String.fromCharCode(charCode));
    }
</script>
</head>

<body onload="init();">

<g:form action="edit">


    <div id="sec1" style="display:block">
        <div class="extra container">
            <h2 align="middle">Section ข้อมูลพื้นฐาน</h2>
            <div>
                <input id="address" value="" type="text" size="200" placeholder="ค้นหาสถานที่"/>
                <a href="" onclick="getAddress();
                return false" class="button2">Search</a>
                <br/>
            </div>
            <div id="all-map" style="position: relative;width: 100%;height: 500px;margin: 5px 0px;">
                <input type="button" value="Toggle Street View" style="position: absolute;z-index: 2;right: 0;" onclick="toggleStreetView();" />
                <div id="map-canvas">

                </div>
                <div id="street-view" style="height: 100%;display:none">
                </div>
            </div>
            <g:field name="accidentId" type="hidden" value="${accident.id}" />
            <g:field name="editAction" type="hidden" value="1" />
            <div class="box">
                <table>
                    <tr>
                        <td colspan="3"><h4>พิกัดจีพีเอส</h4></td>
                    </tr>
                    <tr>
                        <td>
                            ละติจูด
                        </td>
                        <td colspan="2">
                            <g:field type="text" name="lat" id="lat" readonly="" value="" required="required"
                                     placeholder="- คลิกบนแผนที่ -"/>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            ลองติจูด
                        </td>
                        <td>
                            <g:field type="text" name="lon" id="lon" size="20" readonly="" value="" required="required"
                                     placeholder="- คลิกบนแผนที่ -"/>
                        </td>
                        <td>
                            <a href="" class="button2" onclick="reset();
                            return false;">Reset</a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
    <div id="secAction" style="display:block;text-align: right">
        <div class="extra container">
            <g:submitButton name="update" value="Update" class="button2"/>
        </div>
    </div>
</g:form>

<body>

</body>
</html>