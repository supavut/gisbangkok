<%--
  Created by IntelliJ IDEA.
  User: Home
  Date: 5/20/14
  Time: 11:27 PM
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Alert</title>
    <script type="text/javascript">
        alert(${id});
        window.location="${createLink(controller :'main',action: 'create')}";
    </script>
</head>

<body>

</body>
</html>