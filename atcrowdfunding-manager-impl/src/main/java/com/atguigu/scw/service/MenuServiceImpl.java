package com.atguigu.scw.service;

import com.atguigu.atcrowdfunding.bean.TMenu;
import com.atguigu.atcrowdfunding.mapper.TMenuMapper;
import com.atguigu.atcrowdfunding.service.MenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class MenuServiceImpl implements MenuService {

    @Autowired
    private TMenuMapper menuMapper;

    @Override
    public List<TMenu> getPMenus() {

        //查询所有菜单
        List<TMenu> menus = menuMapper.selectByExample(null);

        //挑出所有父菜单集合
        Map<Integer,TMenu> pMenus = new HashMap<>();
        for (TMenu menu : menus) {
            if (menu.getPid() == 0){
                pMenus.put(menu.getId(),menu);
            }
        }

        //遍历所有菜单，如果正在遍历的菜单的pid和父菜单集合中的某的菜单的id一样，则将他放入父菜单的子菜单集合中
        //遍历所有菜单
        for (TMenu menu : menus) {
            if (menu.getPid() != 0){//如果正在遍历的菜单的pid不等于0，则他是某个父菜单的子菜单
                TMenu pMenu = pMenus.get(menu.getPid());//从上面的父菜单集合中，找到正在遍历的菜单的父菜单
                if (pMenu != null){//判断该父菜单是否为空
                    pMenu.getChildren().add(menu);//将正在遍历的菜单放入该父菜单的子菜单集合当中
                }
            }
        }
        //返回父菜单集合，因为所有菜单都包括了
        return new ArrayList<TMenu>(pMenus.values());
    }
}
