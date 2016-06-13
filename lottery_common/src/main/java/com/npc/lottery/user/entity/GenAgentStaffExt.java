package com.npc.lottery.user.entity;

import java.io.Serializable;
import java.util.Set;

import com.npc.lottery.sysmge.entity.ManagerStaff;
import com.npc.lottery.util.Tools;

public class GenAgentStaffExt extends ManagerStaff implements Serializable,Comparable<ManagerStaff>{

 /**
     * 
     */
    private static final long serialVersionUID = -2030078895573238136L;

// primary key
    private java.lang.Long managerStaffID;          //总代理用户基础信息表所对应的记录ID，对应管理用户基础表（TB_FRAME_MANAGER_STAFF）的ID

    // fields                                        //
    private java.lang.Integer parentStaff;           //上级用户
    private java.lang.String replenishment;          //走飞，即补货。取值含义如下：0 — 允许走飞；1 — 禁止走飞
    private java.lang.Integer genAgentRate;       //总代理占成
    private java.lang.Integer shareholderRate;    //股东占成
    private java.lang.Integer totalCreditLine;       //总信用额
    private java.lang.Integer availableCreditLine;   //可用信用额度
    private StockholderStaffExt stockholderStaffExt; //多个总代理对应一个股东
    private Set<AgentStaffExt> agentStaffExtsSet; //多个代理对应一个总代理
    private Set<MemberStaffExt> memberStaffExtSet;      //多个会员对应一个总代理
    private Set<SubAccountInfo> subAccountInfoSet;// 多个子帳號对应一个總代理
    private String pureAccounted="0";//0 — 纯占；1 — 非纯占
    private Long branchStaff;            //分公司用户
    private Long chiefStaff;             //总监用户
    private java.lang.String rateRestrict; // 是否限制下線占成 0 不限制 1 限制
    private java.lang.Integer belowRateLimit; // 下線占成上限設置值
    
    
    public java.lang.String getRateRestrict() {
		return rateRestrict;
	}

	public void setRateRestrict(java.lang.String rateRestrict) {
		this.rateRestrict = rateRestrict;
	}

	public java.lang.Integer getBelowRateLimit() {
		return belowRateLimit;
	}

	public void setBelowRateLimit(java.lang.Integer belowRateLimit) {
		this.belowRateLimit = belowRateLimit;
	}
    
    
    public Long getBranchStaff() {
        return branchStaff;
    }
    public void setBranchStaff(Long branchStaff) {
        this.branchStaff = branchStaff;
    }
    public Long getChiefStaff() {
        return chiefStaff;
    }
    public void setChiefStaff(Long chiefStaff) {
        this.chiefStaff = chiefStaff;
    }
    public String getPureAccounted() {
        return pureAccounted;
    }
    public void setPureAccounted(String pureAccounted) {
        this.pureAccounted = pureAccounted;
    }
    public Set<SubAccountInfo> getSubAccountInfoSet() {
        return subAccountInfoSet;
    }
    public void setSubAccountInfoSet(Set<SubAccountInfo> subAccountInfoSet) {
        this.subAccountInfoSet = subAccountInfoSet;
    }
    public Set<MemberStaffExt> getMemberStaffExtSet() {
        return memberStaffExtSet;
    }
    public void setMemberStaffExtSet(Set<MemberStaffExt> memberStaffExtSet) {
        this.memberStaffExtSet = memberStaffExtSet;
    }
    public Set<AgentStaffExt> getAgentStaffExtsSet() {
        return agentStaffExtsSet;
    }
    public void setAgentStaffExtsSet(Set<AgentStaffExt> agentStaffExtsSet) {
        this.agentStaffExtsSet = agentStaffExtsSet;
    }
    public StockholderStaffExt getStockholderStaffExt() {
        return stockholderStaffExt;
    }
    public void setStockholderStaffExt(StockholderStaffExt stockholderStaffExt) {
        this.stockholderStaffExt = stockholderStaffExt;
    }
    
    
    public java.lang.Long getManagerStaffID() {
        return managerStaffID;
    }
    public void setManagerStaffID(java.lang.Long managerStaffID) {
        this.managerStaffID = managerStaffID;
    }
    public java.lang.Integer getParentStaff() {
        return parentStaff;
    }
    public void setParentStaff(java.lang.Integer parentStaff) {
        this.parentStaff = parentStaff;
    }
    public java.lang.String getReplenishment() {
        return replenishment;
    }
    public void setReplenishment(java.lang.String replenishment) {
        this.replenishment = replenishment;
    }
    
    public java.lang.Integer getGenAgentRate() {
        return genAgentRate;
    }
    public void setGenAgentRate(java.lang.Integer genAgentRate) {
        this.genAgentRate = genAgentRate;
    }
    public java.lang.Integer getShareholderRate() {
        return shareholderRate;
    }
    public void setShareholderRate(java.lang.Integer shareholderRate) {
        this.shareholderRate = shareholderRate;
    }
    public java.lang.Integer getTotalCreditLine() {
        return totalCreditLine;
    }
    public void setTotalCreditLine(java.lang.Integer totalCreditLine) {
        this.totalCreditLine = totalCreditLine;
    }
    public java.lang.Integer getAvailableCreditLine() {
        return availableCreditLine;
    }
    public void setAvailableCreditLine(java.lang.Integer availableCreditLine) {
        this.availableCreditLine = availableCreditLine;
    }
    
    @Override
    public int compareTo(ManagerStaff managerStaff) {
//        if(managerStaff.getCreateDate().before(this.getCreateDate()))
//            return -1;
//       else if (managerStaff.getCreateDate().after(this.getCreateDate()))
//       return 1;
//       else return 0;
    	return this.getAccount().compareTo(managerStaff.getAccount());
    }
    public String getEncodeId() {
		if(managerStaffID!=null)
			return Tools.encodeWithKey(managerStaffID+"");
			else 
				return null;
	}
}
