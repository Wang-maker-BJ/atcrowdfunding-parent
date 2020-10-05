package com.atguigu.scw.controller;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.service.RoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
@RequestMapping("/role")
public class RoleController {

    @Autowired
    private RoleService roleService;

    //7、处理异步更新角色的方法
    @ResponseBody
    @RequestMapping("/updateRole")
    public String updateRole(TRole role){
        roleService.updateRole(role);
        return "ok";
    }

    //6、更新角色，先查询要更新的角色，用于回显
    @ResponseBody
    @RequestMapping("/getRole")
    public TRole getRole(@RequestParam("id") Integer id){
        TRole role = roleService.getRole(id);
        return role;
    }

    //5、新增角色的方法
    @ResponseBody
    @RequestMapping("/addRole")
    public String addRole(TRole role){
        roleService.addRole(role);

        return "ok";
    }
    //4、批量异步删除指定角色的方法
    @ResponseBody
    @RequestMapping("/batchDelRoles")
    public String batchDelRoles(@RequestParam("ids") List<Integer> ids){
        roleService.batchDelRoles(ids);

        return "ok";
    }
    //3、处理异步删除指定角色的方法
    @ResponseBody
    @RequestMapping("/delete")
    public String delete(@RequestParam("id") Integer id){
        roleService.deleteRole(id);
        //返回"ok"代表成功，"fail"代表失败
        return "ok";
    }

    //2、异步查询角色列表的方法，带条件的分页查询，返回分页对象
    @ResponseBody
    @RequestMapping("getRoles")
    public PageInfo<TRole> getRoles(@RequestParam(defaultValue = "1",required = false) Integer pageNum,
                                    @RequestParam(defaultValue = "",required = false) String condition){
        //设置分页每页显示几条,必须在查询业务之前
        int pageSize = 3;
        PageHelper.startPage(pageNum,pageSize);

        //查询分页列表
        List<TRole> roles = roleService.getRoles(condition);
        //上面设置好了之后，这查询的结果就是分页的结果，因为虽然是查询所有，但是会被拦截器拦截

        //获取详细的分页对象：必须在分页业务查询之后
        //参数1：分页查询的数据集合，将其包装成分页对象，参数2：页面需要显示的页码数量
        PageInfo<TRole> pageInfo = new PageInfo<>(roles,3);

        return pageInfo;
    }

    //1、转发到role.jsp页面
    @RequestMapping("/index")
    public String jumpToRole(){
        return "/role/role";
    }
}
