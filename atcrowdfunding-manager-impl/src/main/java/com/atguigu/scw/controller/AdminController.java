package com.atguigu.scw.controller;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.atcrowdfunding.service.MenuService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private AdminService adminService;

    //11、更新管理员的方法
    @RequestMapping("/update")
    public String updateAdmin(TAdmin admin,HttpSession session){
        try {
            adminService.updateAdmin(admin);
        } catch (Exception e) {
            //更新失败，重定向回更新页面
            session.setAttribute("updateErrorMsg",e.getMessage());
            return "redirect:/admin/edit.html?id="+admin.getId();
        }

        Integer currentPageNum = (Integer) session.getAttribute("currentPageNum");
        //跳转到更新之前的页面
        return "redirect:/admin/index?pageNum="+currentPageNum;
    }

    //10、转发到编辑页面
    @RequestMapping("/edit.html")
    public String edit(Integer id,Model model){
        //查询要修改的Admin对象
        TAdmin admin = adminService.getAdmin(id);
        //将Admin对象放入request域中，到edit页面回显
        model.addAttribute("editAdmin",admin);
        return "admin/edit";

    }

    //9、处理批量删除的请求

    /**
     *  一个键多个值的提交方式：
     *         url?hobby=football&hobby=basketball&hobby=pingp
     *  springmvc中对参数提交进行了优化：
     *         入参类型：
     *         1、简单类型： 只要提交参数的key和方法的形参名一样就可以绑定入参
     *         2、对象类型：pojo，只要提交参数的key和pojo的属性名一样就可以绑定入参
     *              TAdmin：
     *                  String loginacct
     *                     Integer id
     *                 String email
     *         3、同一个键有多个值：使用List集合接受
     *              浏览器提交参数：url?ids=1,2,3,4
     *              springmvc接收时可以使用 @RequestParam("ids")List<Integer>ids
     */
    //集合类型的参数入参
    // url?id=1&id=2&id=3
    @RequestMapping("batchDelAdmins")
    public String batchDelAdmins(@RequestParam("ids") List<Integer> ids,HttpSession session){
        adminService.batchDelAdmins(ids);
        Integer currentPageNum = (Integer) session.getAttribute("currentPageNum");
        //跳转到删除之前的页面
        return "redirect:/admin/index?pageNum="+currentPageNum;
    }

    //8、单个删除管理员的方法
    @RequestMapping(value = "/delete/{id}")
    public String delete(@PathVariable("id") Integer id,HttpSession session){
        adminService.deleteAdmin(id);
        Integer currentPageNum = (Integer) session.getAttribute("currentPageNum");
        //跳转到删除之前的页面
        return "redirect:/admin/index?pageNum="+currentPageNum;
    }

    //7、新增管理员方法
    @RequestMapping(value = "/add",method = RequestMethod.POST)
    public String add(HttpSession session,TAdmin admin){
        try {
            adminService.addUser(admin);
        } catch (Exception e) {
            //新增失败，重定向到新增页面
            session.setAttribute("adderrorMsg",e.getMessage());
            return "redirect:/admin/add.html";
        }

        Integer totalPage = (Integer) session.getAttribute("totalPage");
        return "redirect:/admin/index?pageNum="+(totalPage+1);
    }

    //6、跳转新增管理员页面
    @RequestMapping("/add.html")
    public String addPage(){
        return "admin/add";
    }

    //5、查询管理员列表，转发到管理员页面的方法
    @RequestMapping("/index")//pageNum是从客户端传来页码
    public String listUserList(HttpSession session,Model model,
                               @RequestParam(defaultValue = "1",required = false) Integer pageNum,
                               @RequestParam(defaultValue = "",required = false) String condition){

        //设置分页每页显示几条,必须在查询业务之前
        int pageSize = 3;
        PageHelper.startPage(pageNum,pageSize);

        //查询分页用户列表
        List<TAdmin> admins = adminService.listAll(condition);
        //上面设置好了之后，这查询的结果就是分页的结果，因为虽然是查询所有，但是会被拦截器拦截

        //获取详细的分页对象：必须在分页业务查询之后
        //参数1：分页查询的数据集合，将其包装成分页对象，参数2：页面需要显示的页码数量
        PageInfo<TAdmin> pageInfo = new PageInfo<>(admins,3);
        //将总页码存入session域中，供上面的新增管理员使用
        session.setAttribute("totalPage",pageInfo.getPages());
        //将当前页码存入session域中，供上面的删除管理员使用
        session.setAttribute("currentPageNum",pageInfo.getPageNum());

        //放到Request域中共享
        model.addAttribute("pageInfo" , pageInfo);

        //转发到user页面
        return "admin/user";
    }

    //4、处理注销请求的方法
    @RequestMapping("/logout")
    public String logout(HttpSession session){
        session.invalidate();
        return "redirect:/admin/login.html";
    }

    @Autowired
    private MenuService menuService;
    //3、转发到登陆成功页面的方法
    @RequestMapping("/main.html")
    public String mainPage(HttpSession session){
        /*main.jsp页面需要显示左侧菜单栏，需要查询菜单集合
        * 转发到main页面时获取菜单集合遍历显示
        * */
        //查询已经设置了子菜单集合的父菜单集合
        List<TMenu> pMenus = menuService.getPMenus();
        //数据需要在多个页面使用，放入Session域中
        session.setAttribute("pMenus",pMenus);
        //转发到main页面时，遍历菜单集合显示
        return "admin/main";
    }

    //2、处理登录请求的方法
    @RequestMapping(value = "/login" , method = RequestMethod.POST)
    public String login(HttpSession session , Model model , String loginacct, String userpswd){
        //调用业务层方法，传入账户和密码参数
        TAdmin admin = adminService.login(loginacct,userpswd);
        //判断登陆结果
        if (admin == null){
            String errorMsg = "账号或密码错误";
            model.addAttribute("errorMsg" , errorMsg);
            return "admin/login";
        }
        session.setAttribute("admin" , admin);
        //登陆成功，保持登陆状态，重定向成功页面
        //重定向地址由浏览器解析，如果重定向地址是WEB-INF下的，浏览器不能访问
        return "redirect:/admin/main.html";
    }


    //1、转发到登陆页面的方法
    @RequestMapping("login.html")
    public String logInPage(){
        return "admin/login";
    }
}
