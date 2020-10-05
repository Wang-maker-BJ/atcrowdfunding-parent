<%--
  Created by IntelliJ IDEA.
  User: 王宇
  Date: 2020/9/14
  Time: 20:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<script src="jquery/jquery-2.1.1.min.js"></script>
<script src="bootstrap/js/bootstrap.min.js"></script>
<script src="script/docs.min.js"></script>
<script src="layer/layer.js"></script>
<script src="script/back-to-top.js"></script>

<script type="text/javascript">

    //给注销绑定单击事件
    $("#logoutBtn").click(function () {
        layer.confirm("您确定要退出吗?" , {"title":"注销提示","icon":3} , function () {
            window.location.href = "${PATH}/admin/logout";
        })
    });
</script>