<%--
  Created by IntelliJ IDEA.
  User: 王宇
  Date: 2020/9/17
  Time: 16:18
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
            <div><a class="navbar-brand" style="font-size:32px;" href="#">众筹平台 - 角色维护</a></div>
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
                    <form class="form-inline" role="form" style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input name="condition" class="form-control has-success" type="text" placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button type="button" id="queryRolesBtn" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>
                    <button type="button" id="batchDelRolesBtn" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button type="button" id="showAddRoleModalBtn" class="btn btn-primary" style="float:right;"><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <th width="30"><input type="checkbox"></th>
                                <th>名称</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody>

                            </tbody>
                            <tfoot>
                            <tr>
                                <td colspan="6" align="center">
                                    <ul class="pagination">

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

<%--新增角色的模态框--%>
<div class="modal fade" id="addRoleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="exampleModalLabel">新增角色</h4>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">角色名称</label>
                        <input type="text" name="name" class="form-control" id="recipient-name">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" id="addRoleBtn" class="btn btn-primary">提交</button>
            </div>
        </div>
    </div>
</div>
<%--新增角色的模态框--%>


<%--更新角色的模态框--%>
<div class="modal fade" id="updateRoleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="exampleModalLabel">更新角色</h4>
            </div>
            <div class="modal-body">
                <form>
                    <input type="hidden" name="id">
                    <div class="form-group">
                        <label for="recipient-name" class="control-label">角色名称</label>
                        <input type="text" name="name" class="form-control" id="recipient-name">
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                <button type="button" id="updateRoleModalBtn" class="btn btn-primary">提交</button>
            </div>
        </div>
    </div>
</div>
<%--更新角色的模态框--%>

<%@include file="/WEB-INF/pages/include/base_js.jsp"%>
<script type="text/javascript">
    //定义全局变量，获取当前页码
    var currentPageNum;
    var totalPageNum;

    //1、全选效果  thead中的全选框绑定单击事件
    $("thead :checkbox").click(function () {
        $("tbody :checkbox").prop("checked",this.checked);
    });

    //2、子复选框的单击事件
    $("tbody").delegate(":checkbox","click",function () {
        $("thead :checkbox").prop("checked",$("tbody :checkbox").length== $("tbody :checkbox:checked").length)
    });

    //3、给批量删除的按钮绑定单击事件
    $("#batchDelRolesBtn").click(function () {
        var roleIdArr = new Array();
        $("tbody :checkbox:checked").each(function () {
            roleIdArr.push($(this).attr("roleid"));
        });
        if (roleIdArr.length == 0) {
            layer.msg("请选择要删除的角色");
            return;
        }
        var roleIds = roleIdArr.join();
        $.ajax({
            type:"get",
            url:"${PATH}/role/batchDelRoles",
            data:{"ids":roleIds},
            success:function (result) {
                if (result=="ok"){
                    layer.msg("批量删除成功");
                    var condition = $("input[name='condition']").val();
                    getRoles(currentPageNum,condition);
                }
            }
        });
    });

    //4、给新增按钮绑定单击事件
    $("#showAddRoleModalBtn").click(function () {
        //显示模态框
        $('#addRoleModal').modal("toggle");
    });

    //5、给新增角色模态框提交按钮绑定单击事件
    $("#addRoleBtn").click(function () {
        $.ajax({
            type:"post",
            url:"${PATH}/role/addRole",
            data:$("#addRoleModal form").serialize(),//表单的表单项必须有name属性值才会拼接
            success:function (result) {
                if (result=="ok"){
                    //关闭模态框
                    $('#addRoleModal').modal("toggle");
                    //跳转到最后一页
                    getRoles(totalPageNum+1);
                    layer.msg("添加成功");
                }

            }
        });
    });

    //6、给更新按钮绑定单击事件
    $("tbody").delegate(".updateRoleBtn","click",function () {
        var roleid = $(this).attr("roleid");
        $.get("${PATH}/role/getRole",{id:roleid},function (role) {
            $("#updateRoleModal input[name='id']").val(role.id);
            $("#updateRoleModal input[name='name']").val(role.name);
            $('#updateRoleModal').modal("toggle");
        });
    });
    //7、给更新角色模态框提交按钮绑定单击事件
    $("#updateRoleModalBtn").click(function () {
        var roleid = $("input[name='id']").val();
        $.ajax({
            type:"get",
            url:"${PATH}/role/updateRole",
            data:$("#updateRoleModal form").serialize(),
            success:function (result) {
                if (result=="ok"){
                    var condition = $("input[name=condition]").val();
                    layer.msg("更新成功")
                    $('#updateRoleModal').modal("toggle");
                    getRoles(currentPageNum,condition);
                }
            }
        });
    });

    //提交删除请求的单击事件
    $("tbody").delegate(".deleteRoleBtn","click",function () {
        var $tr = $(this).parents("tr");//后台响应成功，需要删除tr对象
        var roleid = $(this).attr("roleid");//异步请求删除角色的id
        layer.confirm("您确定要删除吗？", {title:"删除提示:","icon":3} ,function () {
            $.ajax({
                type:"get",
                url:"${PATH}/role/delete",
                data:{"id":roleid},
                success:function (result) {
                    if (result=="ok") {
                        layer.msg("删除成功");
                        //删除当前按钮所在行的角色标签
                        $tr.remove();
                        //判断本次删除后，本页是否还有角色数据
                        if ($("tbody tr").length===0){
                            //tbody内没有角色列表，刷新当前页
                            var condition = $("input[name='condition']").val();
                            getRoles(currentPageNum,condition);
                        }
                    }
                }
            });
       });
    });


    //给带条件查询按钮绑定单击事件，点击提交异步加载带条件分页数据，并解析的请求
    $("#queryRolesBtn").click(function () {
        var condition = $("input[name='condition']").val();
        getRoles(1,condition)
    });

    getRoles(1);
    /*
    * 1、当前页面浏览器访问后立即发送ajax请求加载角色列表数据显示
    * */
    //抽取的异步请求角色分页数据并解析的方法
    function getRoles(pageNum , condition){
        //还原全选框选中状态
        $("thead :checkbox").prop("checked",false);
        //删除之前异步生成的标签
        $("tbody").empty();//删除tbody内的标签，tbody标签本身不会被删除
        $("tfoot ul").empty();//删除tfoot下的ul标签内的标签，ul标签本身不会被删除

        $.ajax({
            url:"${PATH}/role/getRoles",//请求地址
            type:"get",//请求方式
            data:{"pageNum":pageNum,"condition":condition},//请求参数
            success:function (pageInfo) {//请求成功后的回调函数，result代表服务器响应的结果(响应体)
                //将分页数据中的当前页码使用全局变量保存
                currentPageNum = pageInfo.pageNum;
                totalPageNum = pageInfo.pages;

                //1、解析pageInfo.list集合，将数据显示到tbody内：
                initRoleList(pageInfo);

                //2、解析pageInfo.navigatepageNum,生成页码导航条
                initRoleNav(pageInfo);
            }
        });
    }

    //解析分页数据的角色集合显示到tbody的方法
    function initRoleList(pageInfo){
        //list中的一条记录使用一行显示
        $.each(pageInfo.list,function (index) {
            $('<tr>\n' +
                '<td>'+(index+1)+'</td>\n' +
                '<td><input roleid="'+this.id+'" type="checkbox"></td>\n' +
                '    <td>'+this.name+'</td>\n' +
                '    <td>\n' +
                '    <button roleid="'+this.id+'"type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>\n' +
                '    <button roleid="'+this.id+'"type="button" class="btn btn-primary btn-xs updateRoleBtn"><i class=" glyphicon glyphicon-pencil"></i></button>\n' +
                '    <button roleid="'+this.id+'"type="button" class="btn btn-danger btn-xs deleteRoleBtn"><i class=" glyphicon glyphicon-remove"></i></button>\n' +
                '</td>\n' +
                '</tr>').appendTo("tbody");
        });
    }

    function initRoleNav(pageInfo){
        //分页导航条的单击事件，请求分页数据时后台只会响应分页的json，如果让浏览器发送同步请求浏览器会显示json覆盖之前的页面(同步)
        //分页导航栏超链接应该由js代码发送异步请求，成功后js可以接收并解析异步响应的结果，通过dom解析显示到页面中

        //上一页的li
        if (pageInfo.isFirstPage){
            $('<li class="disabled"><a href="javascript:void(0)">上一页</a></li>').appendTo("tfoot ul");
        }else {
            $('<li><a class="navA" pageNum="'+(pageInfo.pageNum-1)+'" href="javascript:void(0)">上一页</a></li>').appendTo("tfoot ul");
        }

        //中间页码："navigatepageNums":[1,2,3]
        $.each(pageInfo.navigatepageNums,function () {
            if (this==pageInfo.pageNum){
                $('<li class="active"><a href="javascript:void(0)">'+this+'<span class="sr-only">(current)</span></a></li>').appendTo("tfoot ul");
            }else {
                $('<li><a class="navA" pageNum="'+this+'" href="javascript:void(0)">'+this+'</a></li>').appendTo("tfoot ul");
            }
        });

        //下一页的li
        if (pageInfo.isLastPage){
            $('<li class="disabled"><a href="javascript:void(0)">下一页</a></li>').appendTo("tfoot ul");
        }else {
            $('<li><a class="navA" pageNum="'+(pageInfo.pageNum+1)+'" href="javascript:void(0)">下一页</a></li>').appendTo("tfoot ul");
        }

        /*//在上面的标签创建之后，给分页超链接绑定单击事件
        $(".navA").click(function () {
            var pageNum = $(this).attr("pageNum");
            getRoles(pageNum);
        });*/
    }
    //由于class值为navA的标签在异步请求成功之后才会解析生成，$(".navA")在js代码的主线程中会立即执行，在异步请求还未成功时
    //主线程就需要使用这个标签，所以查找失败
    //动态委派：无论现有的标签，还是异步生成的标签都可以绑定上单击事件
    // 主线程在页面中监听一个范围，如果范围内有新增的标签，主线程会检查标签是否需要绑定事件
    // $(".navA").live("click" , function(){})；如果页面中有新增的标签，class值为navA，则绑定单击事件
    //live()方法性能差，已经淘汰，使用delegate()
    //$("祖先元素").delegate("后代元素","事件类型",事件处理函数)
    $("tfoot").delegate(".navA","click",function () {
        var pageNum = $(this).attr("pageNum");
        //获取分页查询的条件
        var condition = $("input[name='condition']").val();
        getRoles(pageNum,condition);
    });



    //当前页面所在模块的菜单自动展开+模块标签高亮显示
    $(".list-group-item:contains('权限管理')").removeClass("tree-closed");
    $(".list-group-item:contains('权限管理') ul").show();
    $(".list-group-item:contains('权限管理') li :contains('角色维护')").css("color","red");

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

    $("tbody .btn-success").click(function(){
        window.location.href = "assignPermission.html";
    });
</script>
</body>
</html>
