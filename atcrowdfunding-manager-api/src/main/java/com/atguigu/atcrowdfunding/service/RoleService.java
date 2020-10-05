package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TRole;

import java.util.List;

public interface RoleService {

    List<TRole> getRoles(String condition);

    void deleteRole(Integer id);

    void batchDelRoles(List<Integer> ids);

    void addRole(TRole role);

    TRole getRole(Integer id);

    void updateRole(TRole role);
}
