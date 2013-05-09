package com.bdt.service.impl;

import com.bdt.bean.Baseinfo;
import com.bdt.bean.BaseinfoExample;
import com.bdt.common.bean.Page;
import com.bdt.common.util.MyStrUtil;
import com.bdt.mapper.BaseinfoMapper;
import com.bdt.service.BaseinfoService;
import org.apache.commons.lang3.StringUtils;

import javax.inject.Inject;
import java.util.List;

/**
 * Created with IntelliJ IDEA.
 * User: yang
 * Date: 13-5-2
 * Time: 上午8:34
 * To change this template use File | Settings | File Templates.
 */
public class BaseinfoServiceImpl implements BaseinfoService {
    @Inject
    private BaseinfoMapper baseinfoMapper;

    @Override
    public void add(Baseinfo model){
        baseinfoMapper.insert(model);
    }

    @Override
    public void modify(Baseinfo model){
        baseinfoMapper.updateByPrimaryKeySelective(model);
    }

    @Override
    public void delete(String rids){
        List<Integer> ids= MyStrUtil.stringToListInteger(rids);
        BaseinfoExample example=new BaseinfoExample();
        BaseinfoExample.Criteria criteria=example.createCriteria();
        criteria.andRidIn(ids);
        baseinfoMapper.deleteByExample(example);
    }

    @Override
    public Page<Baseinfo> queryByPage(Baseinfo model, Integer start, Integer limit){
        Page<Baseinfo> page=new Page<Baseinfo>(start,limit);
        BaseinfoExample example=new BaseinfoExample();
        BaseinfoExample.Criteria criteria=example.createCriteria();
        if(StringUtils.isNotBlank(model.getCcode())){
            criteria.andCcodeLike("%"+model.getCcode()+"%");
        }
        int count=baseinfoMapper.countByExample(example);
        List<Baseinfo> baseinfos=baseinfoMapper.selectByExample(example,page.createRowBounds());
        page.setTotal(count);
        page.setRoot(baseinfos);
        return page;
    }
}