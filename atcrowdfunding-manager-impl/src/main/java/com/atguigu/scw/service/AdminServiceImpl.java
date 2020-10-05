package com.atguigu.scw.service;

import com.atguigu.atcrowdfunding.bean.TAdmin;
import com.atguigu.atcrowdfunding.bean.TAdminExample;
import com.atguigu.atcrowdfunding.mapper.TAdminMapper;
import com.atguigu.atcrowdfunding.service.AdminService;
import com.atguigu.scw.utils.DateUtil;
import com.atguigu.scw.utils.MD5Util;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.CollectionUtils;
import org.springframework.util.StringUtils;

import java.util.List;

@Service
public class AdminServiceImpl implements AdminService {

    @Autowired
    private TAdminMapper adminMapper;

    @Override
    public TAdmin login(String loginacct, String userpswd) {

        //Example帮助我们封装查询条件
        TAdminExample exa = new TAdminExample();
        //Criteria封装动态条件，会生成动态的SQL语句
        exa.createCriteria().andLoginacctEqualTo(loginacct).andUserpswdEqualTo(MD5Util.digest(userpswd));
        List<TAdmin> admins = adminMapper.selectByExample(exa);

        if (CollectionUtils.isEmpty(admins) || admins.size() > 1){
            //如果没有查询到，或者查询到的管理员超过一个人，都认为查询失败
            return null;
        }
        TAdmin admin = admins.get(0);
        return admin;
    }

    @Override
    public List<TAdmin> listAll(String condition) {
        //如果有条件则带条件查询分页数据：  select * from t_admin where xxx like '' limit index ,size
        //如果没有条件则查询所有数据的分页数据  select * from t_admin  like '' limit index ,size
        if (StringUtils.isEmpty(condition)){
            return adminMapper.selectByExample(null);
        }
        TAdminExample exa = new TAdminExample();
        //select * from t_admin where loginacct like '%xxx%' or username like '%xx%'  or email like '%xxx%'  limit index ,size
        TAdminExample.Criteria c1 = exa.createCriteria();//exa的第一个默认的条件
        c1.andLoginacctLike("%" + condition + "%");
        TAdminExample.Criteria c2 = exa.createCriteria();
        c2.andUsernameLike("%" + condition + "%");
        TAdminExample.Criteria c3 = exa.createCriteria();
        c3.andEmailLike("%" + condition + "%");

        exa.or(c2);
        exa.or(c3);

        return adminMapper.selectByExample(exa);
    }

    @Override
    public void addUser(TAdmin admin) {
        //账号邮箱唯一性校验
        TAdminExample exa = new TAdminExample();
        exa.createCriteria().andLoginacctEqualTo(admin.getLoginacct());
        long loginacctCount = adminMapper.countByExample(exa);
        if (loginacctCount > 0){
            throw new RuntimeException("账号已被占用");
        }

        exa.clear();
        exa.createCriteria().andEmailEqualTo(admin.getEmail());
        long emailCount = adminMapper.countByExample(exa);
        if (emailCount > 0){
            throw new RuntimeException("邮箱已被占用");
        }

        //初始化其他数据
        admin.setCreatetime(DateUtil.getFormatTime());
        //密码加密保存：登录使用加密登录
        admin.setUserpswd(MD5Util.digest(admin.getUserpswd()));

        adminMapper.insert(admin);
    }

    @Override
    public void deleteAdmin(Integer id) {
        adminMapper.deleteByPrimaryKey(id);
    }

    @Override
    public void batchDelAdmins(List<Integer> ids) {
        TAdminExample exa = new TAdminExample();
        exa.createCriteria().andIdIn(ids);
        adminMapper.deleteByExample(exa);
    }

    @Override
    public TAdmin getAdmin(Integer id) {
        TAdmin admin = adminMapper.selectByPrimaryKey(id);
        return admin;
    }

    @Override
    public void updateAdmin(TAdmin admin) {

        //账号和邮箱唯一性校验
        TAdmin beforeAdmin = adminMapper.selectByPrimaryKey(admin.getId());

        if (!(beforeAdmin.getLoginacct().equals(admin.getLoginacct()))){
            TAdminExample exa = new TAdminExample();
            exa.createCriteria().andLoginacctEqualTo(admin.getLoginacct());
            long loginacctCount = adminMapper.countByExample(exa);
            if (loginacctCount>0){
                throw new RuntimeException(admin.getLoginacct() + ",已被占用");
            }
        }

        if (!(beforeAdmin.getEmail().equals(admin.getEmail()))){
            TAdminExample exa = new TAdminExample();
            exa.createCriteria().andEmailEqualTo(admin.getEmail());
            long emailCount = adminMapper.countByExample(exa);
            if (emailCount>0){
                throw new RuntimeException(admin.getEmail() + ",已被占用");
            }
        }

        //有选择地更新，admin里面有值的根据主键去更新，为null的则不去更新
        adminMapper.updateByPrimaryKeySelective(admin);
    }
}
