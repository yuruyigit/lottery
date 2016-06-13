<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,com.npc.lottery.periods.entity.BJSCPeriodsInfo,com.npc.lottery.common.Constant,
com.npc.lottery.member.entity.PlayType,com.npc.lottery.replenish.vo.ZhanDangVO" %>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ taglib uri="/WEB-INF/tag/oscache.tld" prefix="cache" %>
<%@ include  file="/jsp/admin/frame/topSub.jsp"%><!--加载判断用户信息，包括子帐号的信息判断  -->
<%Map<String,ZhanDangVO> map = (Map<String,ZhanDangVO>)request.getAttribute("result");%>
<%
BJSCPeriodsInfo cqp=(BJSCPeriodsInfo)request.getAttribute("RunningPeriods");
String mReplenishMent = request.getAttribute("mReplenishMent").toString();
long kjTime=1000*90;
long fpTime=0;
 if(cqp!=null)
 {
	 fpTime=Long.valueOf(request.getAttribute("StopTime").toString());
		kjTime=Long.valueOf(request.getAttribute("KjTime").toString());
 }
//  out.print(fpTime);
%>
<script type="text/javascript">
var onrefresh = false;
var timer; 

function openHelp(infoLink){
	//alert(infoLink.href);
	//需要打开的页面URL，设置为实际值
	var url = "${pageContext.request.contextPath}/images/replenishHelp.gif";
	//打开模式窗口，固定写法，不要改变
	var ret = openModalDialogReport('${pageContext.request.contextPath}/jsp/statreport/common/ModalDialogPage.jsp',url,1006,800);
	
	return false;
}

$(document).ready(function() {	
	$("#moneyOther").keyup(function(){onlyNumber(this);});
	$("#moneyOther").keydown(function(){onlyNumber(this);});
	
	//获取元素的坐标FOR 赔率设置
    var getElementOffset = function _getElementOffset($this) {
        var offset = $this.position();
        var left = offset.left - 60;
        var top = offset.top + $this.height()+7;  //把text元素本身的高度也算上
        return { left: left, top: top }
    }
	//获取元素的坐标FOR 补货
    var getElementOffsetForReplenish = function _getElementOffset($this) {
        var offset = $this.position();
        var left = offset.left-20;
        var top = offset.top + $this.height()-98;  //把text元素本身的高度也算上
        return { left: left, top: top }
    }

    //设置元素的坐标
    var setElementOffset = function _setElementOffset($this, offset) {
        $this.css({ "position": "absolute", "left": offset.left, "top": offset.top });
        return $this;
    }

    function rOp(vo){
    	if($("#searchType").val()!=2){
	    	$("#moneyOther").val("");
	    	if($("#fpTime").html()=="00:01"){
				$("#rBtnSubmitOther").attr("disabled","disabled");
			}else{
				$("#rBtnSubmitOther").removeAttr("disabled");
			}
	    	if($("#kjTime").html()=="00:00"){
				onChangeSubmit();  
	    	}
	    	if ($("#searchType").val()=="1"){
	    		//alert("溫馨提示:實占下才可以進行補貨操作.");
	    	}else{
	   	        var typeCode=$(vo).prev().prev().children().children().children().children().attr("id");
	   	        var typeCodeChnName=$(vo).prev().prev().prev().children().html();
	   	        $("#playFinalTypeOther").val(typeCode);
	   	        $("#rFinalTypeOther").html(typeCodeChnName);
	   	        var odd=$(vo).prev().prev().children().children().children().children().next().children().children().html();
	   	        $("#rOddsOther").html(odd);
	   	        var max = $(vo).prev().children().children().html();
	   	        $("#maxMoneyOtherStr").html(max);
		        $("#maxMoneyOther").val(max);
		        var loseM = 1;
	   	        if($(vo).children().children().html()!=""){
	   	        	loseM = $(vo).children().children().html();
	   	        }
	   	        if(loseM >= 0) {
		     		alert("盈虧為虧時才能補貨.");
		     		return false;
		     	}
	   	        if(max=="-"){
	   	        	alert("限額小於10不能補貨.");
		     		return false;
	   	        }
		        if($("#maxMoneyOther").val()<10) {
		     		alert("限額小於10不能補貨.");
		     		return false;
		     	}
	   	     	$("#lotteryType").val("BJ");
		        $("#rPlateOther").val($("#plate").val());
		        var offset = getElementOffsetForReplenish($(vo));
			    var $div = setElementOffset($("#replenishShowOther"), offset);
			    $div.show();
		   	    $("#rOddsOther").focus();
	   	        getTypeCodeState("BJ",typeCode,"");
	    	} 
    	}
    } 
    
    $(".rOp").on("click", function () {
    	$("#moneyOther").val("");
    	<%if(isSub){
    		if(replenishment !=null){%>
    			rOp(this);
    	<%	}
    	%>
        <%}else if(Constant.OPEN.equals(mReplenishMent)){%> 
           rOp(this);
    	<%}%>
    }); 

    var options = { 
    		beforeSubmit:  validate,
    		success:       showResponseDy,	 
 	        url:'ajaxReplenishSubmit.action',
 	        type:'post',
 	        dataType:'json'	     
 	    }; 
    
    $('#replenishFormOther').submit(function() { 
    	$("#replenishFormOther").hide();
        $(this).ajaxSubmit(options); 
        return false; 
    }); 
    
});

//处理行变色,因为行是根据三种情况而变色的，所以这里处理鼠标经过时要保存原始的CLASS
function changeColorToYL($this,className){
     oldClass=className;
     $this.className="yl";
     $this.children.className="yl";
}
function changeColorToOld($this){
     $this.className=oldClass;
}

</script>
 
 <s:form action="replenishSet.action" id="rForm" namespace="replenish" method="post">
  <input type="hidden" name="subType" id="subType" value="<s:property value="#request.subType"/>"/>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <!--控制表格头部开始-->
  <tr>
    <td height="30" background="${pageContext.request.contextPath}/images/admin/tab_05.gif">
	  <div id="Tab_top">
	    <table id="Tab_top_right" border="0" cellpadding="0" cellspacing="0">
  <tr>
  <td align="left">
      <select name="searchType" onchange="onChangeSubmit()" id="searchType">
        <option value = "1" <s:if test="searchType==1">selected</s:if>>虛注</option>
        <option value = "0" <s:if test="searchType==0">selected</s:if>>實占</option>
        <s:if test="#request.openReport==0"><option value = "2" <s:if test="searchType==2">selected</s:if>>公司占</option></s:if>
      </select>
      <select id="plate" name="plate" style="display:none">
        <option value ="A" <s:if test='plate=="A"'> selected</s:if>>A盘</option>
      </select></td>
    <td width="80" align="right" >
       <input id="refreshBtn" type="button" value="更新" onclick="onChangeSubmit()" style="display:none;"/>
       <span id="refreshTime">更新：<span style="margin-right:2px;" id="clTime">0秒</span></span>
       <span id="onrefresh" style="display:none;" class="blue">載入中...</span>
    </td>
    <td>
      <select name="searchTime" id="searchTime" onchange="changeTime()">
	        <option value ="NO" <s:if test="#request.refleshTime==NO"> selected</s:if>>-NO-</option>
	        <option value ="5" <s:if test="#request.refleshTime==5"> selected</s:if>>5秒</option>
	        <option value ="10" <s:if test="#request.refleshTime==10"> selected</s:if>>10秒</option>
	        <option value ="15" <s:if test="#request.refleshTime==15"> selected</s:if>>15秒</option>
	        <option value ="20" <s:if test="#request.refleshTime==20"> selected</s:if>>20秒</option>
	        <option value ="25" <s:if test="#request.refleshTime==25"> selected</s:if>>25秒</option>
	        <option value ="30" <s:if test="#request.refleshTime==30"> selected</s:if>>30秒</option>
	        <option value ="40" <s:if test="#request.refleshTime==40"> selected</s:if>>40秒</option>
	        <option value ="50" <s:if test="#request.refleshTime==50"> selected</s:if>>50秒</option>
	        <option value ="60" <s:if test="#request.refleshTime==60"> selected</s:if>>60秒</option>
	        <option value ="90" <s:if test="#request.refleshTime==90"> selected</s:if>>90秒</option>
	      </select></td>
	<td width="16" align="right"><img src="${pageContext.request.contextPath}/images/admin/tab_07.gif" width="16" height="30" /></td>
	  </tr>
	    </table>
		<table id="Tab_top_left" border="0" cellspacing="0" cellpadding="0">
                 <tr>
				    <td width="12" height="30"><img src="${pageContext.request.contextPath}/images/admin/tab_03.gif" width="12" height="30" /></td>
				    <td width="16" align="left"><img src="${pageContext.request.contextPath}/images/admin/tb.gif" width="16" height="16" /></td>
                    <td style="padding:0 6px;"><strong class="green"><s:property value="#request.periodsNum"/>期</strong></td>
                    <td style="padding:0 6px;"><strong class="blue">冠、亞軍 組合</strong></td>
                    <td style="padding:0 6px;">
                        <strong style="font-color:#344B50" id="fpTitle">距離封盤：</strong>
                        <strong class="red" id="kjTitle" style="display:none">距離開獎：</strong>
				        <strong><span style="font-color:#344B50" id="fpTime">00:01</span></strong>
				        <strong><span class="red" id="kjTime" style="display:none">00:01</span></strong>
                    </td>
                    <td style="padding:0 6px;"><strong class="red">今天输赢：<span id="todaywin" class="red"></span></strong></td>
                  </tr>
                </table>
		<table id="Tab_top_center" border="0" cellspacing="0" cellpadding="0" style="width:366px;margin:0 auto;">		
  <tr>
     <td ><strong class="orange"><s:property value="#request.lastLotteryPeriods.PeriondsNum" escape="false"/></strong><strong>期赛果</strong></td>
     <td ><s:property value="#request.lastLotteryPeriods.BallNum" escape="false"/></td>
  </tr>
  </table>
	  </div>
	</td>
  </tr>
<!--控制表格头部结束-->

<!--控制中间内容开始-->
  <tr>
    <td><table width="100%" border="0" cellspacing="0" cellpadding="0" id="oddTable">
      <tr>
        <td width="8" background="${pageContext.request.contextPath}/images/admin/tab_12.gif">&nbsp;</td>
        <td align="center">
		<!-- 表格内容开始 一行六列-->
		<table width="100%" border="0" cellpadding="0" cellspacing="0" class="mt4">
		  <tr>
		    <td valign="top" align="left"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="king">
        <colgroup>
        <col width="10%" />
        <col width="34%" />
        <col width="28%" />
        <col width="28%" />
        </colgroup>
        <tr>
          <th>號</th>
          <th>賠率</th>
          <th>注额</th>
          <th>亏盈</th>
        </tr>
		<tr class="sub_th"><td colspan="4">冠、亚军和 指定</td></tr>
        <!-- 内容 -->
        <s:iterator value="#request.groupMap">
            <jsp:include page="/jsp/replenish/bjMiddle.jsp" />
        </s:iterator>     
      </table></td>
			<td valign="top" align="left"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="king">
        <colgroup>
        <col width="10%" />
        <col width="34%" />
        <col width="28%" />
        <col width="28%" />
        </colgroup>
        <tr>
          <th>项</th>
          <th>賠率</th>
          <th>注额</th>
          <th>亏盈</th>
        </tr>
		<tr class="sub_th"><td colspan="4">冠、亚军和 两面</td></tr>
        <!-- 内容 -->
        <s:iterator value="#request.doubleMap">
            <jsp:include page="/jsp/replenish/bjMiddle.jsp" />
        </s:iterator>  
      </table>
	  <div style="margin-top:104px;margin-left:10px;text-align:left;">
	    <p class="mt15">總投注额： <strong class="green"><s:property value="#request.ballPetTotal_group" escape="false"/></strong></p>
		<p class="mt15">最高亏損： <strong class="red"><s:property value="#request.topLose" escape="false"/></strong></p>
		<p class="mt15">最高盈利： <strong class="green"><s:property value="#request.topWin" escape="false"/></strong></p>
	  </div></td>
			<td valign="top" align="left"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="king">
              <colgroup>
              <col width="10%" />
              <col width="34%" />
              <col width="28%" />
              <col width="28%" />
              </colgroup>
              <tr>
                <th>號</th>
                <th>賠率</th>
                <th>注额</th>
                <th>亏盈</th>
              </tr>
			  <tr class="sub_th"><td colspan="4">冠军</td>
			  </tr>
              <!-- 内容 -->
		        <s:iterator value="#request.firstMap">
		            <jsp:include page="/jsp/replenish/bjMiddle.jsp" />
		        </s:iterator>  
            </table>
			<div style="text-align:center;">總额：<strong class="green"><s:property value="#request.ballPetTotal_1" escape="false"/></strong></div>
			</td>
			<td valign="top" align="left"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="king">
              <colgroup>
              <col width="10%" />
              <col width="34%" />
              <col width="28%" />
              <col width="28%" />
              </colgroup>
              <tr>
                <th>號</th>
                <th>賠率</th>
                <th>注额</th>
                <th>亏盈</th>
              </tr>
			  <tr class="sub_th">
			    <td colspan="4">亚军</td>
			  </tr>
              <!-- 内容 -->
		        <s:iterator value="#request.secondMap">
		            <jsp:include page="/jsp/replenish/bjMiddle.jsp" />
		        </s:iterator>  
            </table>
			<div style="text-align:center;">總额：<strong class="green"><s:property value="#request.ballPetTotal_2" escape="false"/></strong></div>
	        </td>
			<td width="160" valign="top" align="left"><!-- 右边统计开始--><jsp:include page="/jsp/replenish/bjscRightBar.jsp" /></td>
		  </tr>
		</table>
        <!-- 表格内容结束 一行六列-->
		</td>
        <td width="8" background="${pageContext.request.contextPath}/images/admin/tab_15.gif">&nbsp;</td>
      </tr>
    </table></td>
  </tr>
<!--控制中间内容结束-->

<!--控制底部操作按钮开始-->
  <tr>
    <td height="35" background="${pageContext.request.contextPath}/images/admin/tab_19.gif"><table width="100%" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="12" height="35"><img src="${pageContext.request.contextPath}/images/admin/tab_18.gif" width="12" height="35" /></td>
        <td align="center"><span >平均虧損：</span><input id="avLose" name="avLose" value="<s:property value="#request.avLose"/>" size="16" maxlength="16" class="b_g"/>
	  <input name="computeBtn" type="button" class="ml10 zs btn2" value="計算補貨" onclick="return onChangeSubmit()"/>
	  <input name="helpBtn" type="button" class="ml10 blue_btn btn2" value="補貨說明" onclick="return openHelp(this)"/></td>
	   <td width="16"><img src="${pageContext.request.contextPath}/images/admin/tab_20.gif" width="16" height="35" /></td>
      </tr>
    </table></td>
  </tr>
<!--控制底部操作按钮结束-->
</table>
</s:form>
<script type="text/javascript">
var fpDate = <%=fpTime%>;
var kjDate =<%=kjTime%>; 
var clDate=1000*90;
var queryUrl = context+'/replenish/ajaxGetTodayWin.do';
var obj = $.ajax({
	url : queryUrl,
	async : true,
	dataType : "json",
	type : "POST",
	success : function(json) {
		$("#todaywin").html(json);
	}
});
</script>
<script language="javascript" src="${pageContext.request.contextPath}/js/replenishFooter.js"></script>
