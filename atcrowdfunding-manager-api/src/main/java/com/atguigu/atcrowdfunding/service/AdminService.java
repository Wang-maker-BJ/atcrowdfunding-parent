package com.atguigu.atcrowdfunding.service;

import com.atguigu.atcrowdfunding.bean.TAdmin;

import java.util.List;

public interface AdminService {
    TAdmin login(String loginacct, String userpswd);

    List<TAdmin> listAll(String condition);

    void addUser(TAdmin admin);

    void deleteAdmin(Integer id);

    void batchDelAdmins(List<Integer> ids);

    TAdmin getAdmin(Integer id);

    void updateAdmin(TAdmin admin);
}
