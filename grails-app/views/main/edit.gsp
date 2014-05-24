<%--
  Created by IntelliJ IDEA.
  User: yana_yanee
  Date: 4/12/14 AD
  Time: 15:59
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Edit</title>
    <meta name="layout" content="bangkokLayout"/>
    <style>
    table, td, th
    {
        font-size:13px;
        border:1px green;
    }
    td input {
        border:0px
    }
    table
    {
        width:100%;
    }
    th
    {
        background-color:#009E2D;
        color:white;
        font-family: 'Varela', sans-serif;
    }
    </style>
</head>

<body>
    <div id="page" class="container">
        <div style="float:left"><input class="button2" type="button" value="Select All" onclick="SelectAll();"/></div>
        <div style="float:right"><input class="button2" type="button" value="Delete Checked items" onclick="Delete();"/></div>
        <table>
            <tr>
                <th>Delete</th>
                <th>พิกัด</th>
                <th>วันที่เกิดเหตุ</th>
                <th>เวลา</th>
                <th>จำนวนผู้เสียชีวิต</th>
                <th>จำนวนผู้บาดเจ็บ</th>
                <th>จำนวนรถ</th>
                <th>ประเภทรถ</th>
                <th>มูลเหตุ</th>
                <th>ชนิดถนน</th>
            </tr>
            <!-- Loop -->
            <tr>
                <td><input type="checkbox" name="record1"></td>
                <td>23432.124,1234123.124132</td>
                <td>34 มิถุนายน 2557</td>
                <td>23:22</td>
                <td>1-5</td>
                <td>0</td>
                <td>1-5</td>
                <td>จักรยานยนต์</td>
                <td>ขับรถเร็วเกินอัตราที่กำหนด</td>
                <td>ถนน</td>
            </tr>
            <tr>
                <td><input type="checkbox" name="record1"></td>
                <td>23432.124,1234123.124132</td>
                <td>34 มิถุนายน 2557</td>
                <td>23:22</td>
                <td>1-5</td>
                <td>0</td>
                <td>1-5</td>
                <td>จักรยานยนต์</td>
                <td>ขับรถเร็วเกินอัตราที่กำหนด</td>
                <td>ถนน</td>
            </tr>
            <tr>
                <td><input type="checkbox" name="record1"></td>
                <td>23432.124,1234123.124132</td>
                <td>34 มิถุนายน 2557</td>
                <td>23:22</td>
                <td>1-5</td>
                <td>0</td>
                <td>1-5</td>
                <td>จักรยานยนต์</td>
                <td>ขับรถเร็วเกินอัตราที่กำหนด</td>
                <td>ถนน</td>
            </tr>
            <tr>
                <td><input type="checkbox" name="record1"></td>
                <td>23432.124,1234123.124132</td>
                <td>34 มิถุนายน 2557</td>
                <td>23:22</td>
                <td>1-5</td>
                <td>0</td>
                <td>1-5</td>
                <td>จักรยานยนต์</td>
                <td>ขับรถเร็วเกินอัตราที่กำหนด</td>
                <td>ถนน</td>
            </tr>
            <tr>
                <td><input type="checkbox" name="record1"></td>
                <td>23432.124,1234123.124132</td>
                <td>34 มิถุนายน 2557</td>
                <td>23:22</td>
                <td>1-5</td>
                <td>0</td>
                <td>1-5</td>
                <td>จักรยานยนต์</td>
                <td>ขับรถเร็วเกินอัตราที่กำหนด</td>
                <td>ถนน</td>
            </tr>
            <tr>
                <td><input type="checkbox" name="record1"></td>
                <td>23432.124,1234123.124132</td>
                <td>34 มิถุนายน 2557</td>
                <td>23:22</td>
                <td>1-5</td>
                <td>0</td>
                <td>1-5</td>
                <td>จักรยานยนต์</td>
                <td>ขับรถเร็วเกินอัตราที่กำหนด</td>
                <td>ถนน</td>
            </tr>
        </table>
    </div>
</body>
</html>