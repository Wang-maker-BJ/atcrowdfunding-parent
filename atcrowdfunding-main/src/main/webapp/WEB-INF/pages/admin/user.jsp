<%--
  Created by IntelliJ IDEA.
  User: 王宇
  Date: 2020/9/14
  Time: 21:08
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <%@include file="/WEB-INF/pages/include/base_css.jsp"%>

    <style>
        .tree li {
            list-style-type: none;
            cursor:pointer;
        }
        table tbody tr:nth-child(odd){background:#F4F4F4;}
        table tbody td:nth-child(even){color:#C00;}
    </style>
</head>

<body>

<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container-fluid">
        <div class="navbar-header">
            <div><a class="navbar-brand" style="font-size:32px;" href="#">众筹平台 - 用户维护</a></div>
        </div>
        <%@include file="/WEB-INF/pages/include/manager_loginbar.jsp"%>

    </div>
</nav>

<div class="container-fluid">
    <div class="row">
        <div class="col-sm-3 col-md-2 sidebar">
            <%@include file="/WEB-INF/pages/include/manager_menu.jsp"%>
        </div>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">
                    <form action="${PATH}/admin/index" class="form-inline" role="form" style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input value="${param.condition}" name="condition" class="form-control has-success" type="text" placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>
                    <button type="button" id="batchDelAdminBtn" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button type="button" class="btn btn-primary" style="float:right;" onclick="window.location.href='${PATH}/admin/add.html'"><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <th width="30"><input type="checkbox"></th>
                                <th>账号</th>
                                <th>名称</th>
                                <th>邮箱地址</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%--
                                    admins 集合使用 一个表格显示，user对象使用一行显示
                                    varStatus: 当前遍历的状态对象，遍历开始时标签创建该对象，每次迭代时会自动更新该对象的属性值
                                        index:正在遍历元素的索引，从0开始
                                        count：正在遍历的元素是第几个,从1开始
                                        current：正在遍历的元素对象
                                        isFirst：是否是第一个,isLast：是否是最后一个
                            --%>
                            <c:if test="${!empty pageInfo.list}">
                                <c:forEach items="${pageInfo.list}" var="user" varStatus="vs">
                                    <tr>
                                        <td>${vs.count}</td>
                                        <td><input type="checkbox" adminid="${user.id}"></td>
                                        <td>${user.loginacct}</td>
                                        <td>${user.username}</td>
                                        <td>${user.email}</td>
                                        <td>
                                            <button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>
                                            <button type="button" onclick="window.location='${PATH}/admin/edit.html?id=${user.id}'" class="btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>
                                            <button type="button" adminid="${user.id}" class="btn btn-danger btn-xs deleteAdminBtn"><i class=" glyphicon glyphicon-remove"></i></button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:if>
                            </tbody>
                            <tfoot>
                            <tr>
                                <td colspan="6" align="center">
                                    <ul class="pagination">
                                        <c:choose>
                                            <c:when test="${pageInfo.isFirstPage}">
                                                <%--当前页面是第一页，上一页禁用--%>
                                                <li class="disabled"><a href="javascript:void(0)">上一页</a></li>
                                            </c:when>
                                            <c:otherwise>
                                                <%--当前页面不是第一页，上一页可以点击--%>
                                                <li><a href="${PATH}/admin/index?pageNum=${pageInfo.pageNum-1}&condition=${param.condition}">上一页</a></li>
                                            </c:otherwise>
                                        </c:choose>

                                        <%--当前页码--%>
                                        <c:forEach items="${pageInfo.navigatepageNums}" var="index">
                                            <c:choose>
                                                <c:when test="${index == pageInfo.pageNum}">
                                                    <%--正在遍历当前页，高亮显示，禁止点击--%>
                                                    <li class="active"><a href="#">${index}<span class="sr-only">(current)</span></a></li>
                                                </c:when>
                                                <c:otherwise>
                                                    <li><a href="${PATH}/admin/index?pageNum=${index}&condition=${param.condition}">${index}</a></li>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>

                                        <c:choose>
                                            <c:when test="${pageInfo.isLastPage}">
                                                <%--当前页面是最后一页，下一页禁用--%>
                                                <li class="disabled"><a href="javascript:void(0)">下一页</a></li>
                                            </c:when>
                                            <c:otherwise>
                                                <%--当前页面不是最后一页，下一页可以点击--%>
                                                <li><a href="${PATH}/admin/index?pageNum=${pageInfo.pageNum+1}&condition=${param.condition}">下一页</a></li>
                                            </c:otherwise>
                                        </c:choose>
                                    </ul>
                                </td>
                            </tr>

                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/pages/include/base_js.jsp"%>
<script type="text/javascript">
    //批量删除的单机事件
    $("#batchDelAdminBtn").click(function () {
        //获取复选框选中的tbody内的管理员id交给后台删除
        var $checkedIpu = $("table tbody :checkbox:checked");

        var idsArr = new Array();//js数组
        //遍历集合，将每个input管理员id获取到
        $checkedIpu.each(function () {
            //jQuery的增强for循环，会自动对jQuery对象进行遍历，使用遍历的dom对象调用传入的函数
            //this代表正在遍历的dom对象
            idsArr.push($(this).attr("adminid"));//向数组中添加元素
        });

        if (idsArr.length==0){
            layer.msg("请选择要删除的管理员");
            return;
        }

        //idsArr.join()将数组中的元素每两个使用逗号连接成一个字符串，例如：[1,2,3] ==> 1,2,3
        layer.confirm("您真的要删除吗？",function () {
            window.location = "${PATH}/admin/batchDelAdmins?ids="+idsArr.join();
        });
    });


    //批量删除的全选效果
    //1、thead中的全选框的单击事件：点击时设置所有的tbody内的复选框状态和自己一致
    $("table thead :checkbox").click(function () {
        $("table tbody :checkbox").prop("checked",this.checked);
    });


    //tobody中的子复选框的单击事件，每个子复选框被点击时，都需要检查子复选框是否都被选中
    //如果都被选中，则全选框被选中
    $("table tbody :checkbox").click(function () {
        //获取所有tbody子复选框的数量
        var totalCount = $("table tbody :checkbox").length;
        //获取tbody内被选中的复选框的数量
        var checkedCount = $("table tbody :checkbox:checked").length;
        $("table thead :checkbox").prop("checked",totalCount==checkedCount);
    });



    //删除单个管理员的单击事件
    $(".deleteAdminBtn").click(function () {
        //获取要删除的管理员的id，被点击按钮所在行的管理员的id
        //this代表被点击的按钮dom对象
        //this.prop()获取标签的自带属性  this.attr()获取我们设置的自定义值
        var adminid = $(this).attr("adminid");
        //获取删除的管理员名称
        var name = $(this).parents("tr").children("td:eq(2)").text();

        layer.confirm("您确定要删除《"+name+"》吗?" , {icon:3} , function () {
            //确认的单击事件
            window.location = "${PATH}/admin/delete/" + adminid;
        });
    });

    //当前页面所在模块的菜单自动展开+模块标签高亮显示
    $(".list-group-item:contains('权限管理')").removeClass("tree-closed");
    $(".list-group-item:contains('权限管理') ul").show();
    $(".list-group-item:contains('权限管理') li :contains('用户维护')").css("color","red");



    $(function () {
        $(".list-group-item").click(function(){
            if ( $(this).find("ul") ) {
                $(this).toggleClass("tree-closed");
                if ( $(this).hasClass("tree-closed") ) {
                    $("ul", this).hide("fast");
                } else {
                    $("ul", this).show("fast");
                }
            }
        });
    });
   /* $("tbody .btn-success").click(function(){
        window.location.href = "assignRole.html";
    });
    $("tbody .btn-primary").click(function(){
        window.location.href = "edit.html";
    });*/
</script>
</body>
</html>
