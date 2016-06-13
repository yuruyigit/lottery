package com.npc.lottery.statreport.logic.interf;

import java.util.ArrayList;

import com.npc.lottery.common.ConditionData;
import com.npc.lottery.statreport.entity.GdklsfHis;

/**
 * 投注历史（广东快乐十分）业务逻辑处理类接口
 * 
 */
public interface IGdklsfHisLogic {
    
    /**
     * 根据查询条件查询对应广东快乐十分历史信息
     * 
     * @param conditionStr
     * @return
     */
    public ArrayList<GdklsfHis> findGdklsfHis(String conditionStr);

    /**
     * 查询满足指定查询条件的数据记录
     * 
     * @param conditionData
     *            查询条件信息
     * @param pageCurrentNo 第一页为 1
     *            需要查询的页码
     * @param pageSize
     *            页面大小
     * @return  GdklsfHis 类型的 ArrayList
     */
    public ArrayList<GdklsfHis> findGdklsfHisList(ConditionData conditionData,
            int pageCurrentNo, int pageSize);
    
    /**
     * 根据注单号查询对应的数据记录
     * 
     * @param orderNo
     * @return
     */
    public ArrayList<GdklsfHis> findGdklsfHisListByOrderNo(String orderNo);

    /**
     * 根据投注会员查询投注明细
     * 
     * @param bettingUserID     投注会员ID
     * @return
     */
    public ArrayList<GdklsfHis> findGdklsfHisByBettingUserID(Long bettingUserID);

    /**
     * 统计满足指定查询条件的记录数目

     * 
     * @param conditionData
     *            查询条件信息     
     * @return
     */
    public long findAmountGdklsfHisList(ConditionData conditionData);

    /**
     * 根据ID查询数据
     * 
     * @return
     */
    public GdklsfHis findGdklsfHisByID(long ID);

    /**
     * 保存信息
     * 
     * @param entity    待保存的信息
     * @return  此信息记录所对应的ID，Long类型
     */
    public Long saveGdklsfHis(GdklsfHis entity);

    /**
     * 更新信息
     * 
     * @param entity 待更新的信息
     */
    public void update(GdklsfHis entity);

    /**
     * 删除信息
     * 
     * @param entity
     */
    public void delete(GdklsfHis entity);

    public void updateGdklsfHis(String orderNum);

    public void deleteGdklsHis(String orderNum);
}
