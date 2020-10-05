<%--
  Created by IntelliJ IDEA.
  User: 王宇
  Date: 2020/9/14
  Time: 20:48
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<div class="tree">
    <ul style="padding-left:0px;" class="list-group">
        <c:forEach items="${pMenus}" var="item">
            <c:choose>
                <c:when test="${empty item.children}">
                    <li class="list-group-item tree-closed" >
                        <a href="${PATH}/${item.url}"><i class="${item.icon}"></i> ${item.name}</a>
                    </li>
                </c:when>
                <c:otherwise>
                    <li class="list-group-item tree-closed">
                        <span><i class="${item.icon}"></i> ${item.name} <span class="badge" style="float:right">${item.children.size()}</span></span>
                        <ul style="margin-top:10px;display:none;">
                            <c:forEach items="${item.children}" var="cMenus">
                                <li style="height:30px;">
                                    <a href="${PATH}/${cMenus.url}"><i class="${cMenus.icon}"></i> ${cMenus.name}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </li>
                </c:otherwise>
            </c:choose>
        </c:forEach>
    </ul>
</div>
