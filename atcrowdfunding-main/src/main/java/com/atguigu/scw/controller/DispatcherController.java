package com.atguigu.scw.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class DispatcherController {


    //1、转发到首页的方法
    @RequestMapping(value = {"/","/index","/index.html"} , method = RequestMethod.GET)
    public String jumpToIndex(){
        return "index";
    }


    /*@Autowired
    TMenuMapper menuMapper;

    @ResponseBody
    @RequestMapping("/getMenu")
    public List<TMenu> getMenus(){
        return menuMapper.selectByExample(null);
    }*/
}
