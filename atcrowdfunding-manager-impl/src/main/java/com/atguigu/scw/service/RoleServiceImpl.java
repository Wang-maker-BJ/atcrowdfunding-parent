package com.atguigu.scw.service;

import com.atguigu.atcrowdfunding.bean.TRole;
import com.atguigu.atcrowdfunding.bean.TRoleExample;
import com.atguigu.atcrowdfunding.mapper.TRoleMapper;
import com.atguigu.atcrowdfunding.service.RoleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class RoleServiceImpl implements RoleService {

    @Autowired
    private TRoleMapper roleMapper;

    @Override
    public List<TRole> getRoles(String condition) {

        if (StringUtils.isEmpty(condition)){
            return roleMapper.selectByExample(null);
        }

        TRoleExample exa = new TRoleExample();
        exa.createCriteria().andNameLike("%"+condition+"%");
        List<TRole> roles = roleMapper.selectByExample(exa);
        return roles;
    }

    @Override
    public void deleteRole(Integer id) {
        roleMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void batchDelRoles(List<Integer> ids) {
        TRoleExample exa = new TRoleExample();
        exa.createCriteria().andIdIn(ids);
        roleMapper.deleteByExample(exa);
    }

    @Override
    public void addRole(TRole role) {
        roleMapper.insert(role);
    }

    @Override
    public TRole getRole(Integer id) {
        TRole role = roleMapper.selectByPrimaryKey(id);
        return role;
    }

    @Override
    public void updateRole(TRole role) {
        roleMapper.updateByPrimaryKeySelective(role);
    }


}
