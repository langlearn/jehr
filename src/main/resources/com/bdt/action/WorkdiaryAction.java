package com.bdt.action;

import com.bdt.bean.*;
import com.bdt.common.base.MyActionSupport;
import com.bdt.common.bean.Page;
import com.bdt.service.DataDictionaryService;
import com.bdt.service.WorkDiaryService;
import com.bdt.service.WorkOrderService;
import com.fasterxml.jackson.core.JsonProcessingException;

import javax.inject.Inject;
import java.util.Date;
import java.util.List;

/**
 * 工作日志
 *
 * @author lim
 */
public class WorkdiaryAction extends MyActionSupport<WorkDiary> {

    private WorkDiary model = new WorkDiary();

    @Override
    public WorkDiary getModel() {
        return model;
    }

    @Inject
    private WorkDiaryService workDiaryService;
    @Inject
    private WorkOrderService workOrderService;
    @Inject
    private DataDictionaryService dataDictionaryService;

    public void add() {
        model.setReportTime(new Date());
        model.setUserId(optid);
        workDiaryService.add(model);
        responseUtil.writeSuccess(response);
    }

    public void modify() {
        workDiaryService.modify(model, optid);
        responseUtil.writeSuccess(response);
    }

    public void delete() {
        String rids = request.getParameter("rids");
        workDiaryService.delete(rids, optid);
        responseUtil.writeSuccess(response);
    }

    public void query() {
        model.setUserId(optid);
        Page<ViewWorkDiary> result = workDiaryService.queryViewByPage(model, start, limit);
        responseUtil.writeJson(response, result);
    }

    public void queryDetail() {
        Page<ViewWorkDiaryDetail> result = null;
        if (null == model.getUserId() || null == model.getWorkTime()) {
        } else {
            result = workDiaryService.queryDetailViewByPage(model, start, limit);
        }
        responseUtil.writeJson(response, result);
    }

    public String execute() throws JsonProcessingException {
        List<DataDictionary> dataDictionaries = dataDictionaryService.queryByParentCode("002");
        request.setAttribute("dataDictionaries", objectMapper.writeValueAsString(dataDictionaries));
        request.setAttribute("optid", objectMapper.writeValueAsString(optid));

        ViewWorkOrder order = new ViewWorkOrder();
        order.setAcceptStatus((byte) 1);
        order.setConfirmStatus((byte) 0);
        order.setAcceptUserId(optid);
        List<ViewWorkOrder> workOrders = workOrderService.queryByList(order);
        request.setAttribute("workOrders", objectMapper.writeValueAsString(workOrders));

        return SUCCESS;
    }
}
