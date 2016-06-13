<!--
	角色授权：选择功能
-->

<%@ page contentType="text/html; charset=UTF-8" language="java"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%@ page import="
	com.npc.lottery.util.Tool,
	java.util.ArrayList,
	com.npc.lottery.sysmge.entity.Function 
"%>  
 
<html>  
<head>
<title>选择功能信息</title>
  
<%
    String contextPath = request.getContextPath(); 
    
%>

<link href="<%=contextPath%>/css/style.css" rel="stylesheet" type="text/css">
<script language="javascript" src="<%=contextPath%>/js/public.js"></script>
<script language="JavaScript" src="<%=contextPath%>/js/treeView02.js"></script>

<script>
	/*function test(){
		var selectFunc = document.all.selectFunc;
		
		for(var i = 0 ; i < selectFunc.length; i ++){
			if(selectFunc[i].checked){
				alert(selectFunc[i].value);
			}
		}
	}	*/
</script>

</head>

<body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

<form action="selectFuncForm">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
	<td  valign="top" class="td-content">
      
	<!-- 超过页面高度出现滚动条 -->
	<div class='outer' style="MARGIN: 0px; WIDTH: 100%; HEIGHT: 100%; overflow:auto;">
	<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="1" bgcolor="#C3C3C3">
	<tr valign="top">
	<td bgcolor="#FFFFFF" class="in6" >
	
	<script language="JavaScript">
	
  		var tree = new MzTreeView("tree");
  		tree.icons["depJigou"] = "dep2.gif";
  		tree.icons["depBumen"] = "depJigou.gif";
  		tree.setIconPath("<%=contextPath%>/images/tree/");//可用相对路径
  		tree.nodes['999999999_999999999'] = 'text:999999';
 
	 <%  
		long selectId = 1;
		ArrayList list=(ArrayList)(request.getAttribute("resultList"));
		
		//构造树，注意需要有个根节点（所谓根节点指的是其父节点部分的ID为 0		
		Function entity = null;
		
        //记录被选中的节点（禁用的节点不记录）
        ArrayList<Long> selectIDList = new ArrayList<Long>();
		
		for (int i = 0; i < list.size(); i++){
		    entity = (Function)list.get(i);
			
			StringBuffer str = new StringBuffer("");
			
			str.append("tree.nodes['");
			str.append(entity.getParentTreeID());//构造nodes标志的父节点部分
			str.append("_");
			str.append(entity.getID());//构造nodes标志的自身节点部分
			str.append("']").append( " = 'text:");
			str.append(entity.getFuncName()+";");//树上显示的名稱
			//str.append("icon:");
			//str.append("depJigou");//图片
			//str.append(";");
			
			//复选框
			if(entity.isLeaf()){
	  			str.append("ctrl:true;");//是否增加复选框
	  			str.append("ctrlType:checkbox;");
	  			str.append("ctrlName:selectFunc;");//复选框名稱
	  			str.append("ctrlValue:" + entity.getID() +";");//复选框的值
	  			if(entity.isAuthoriz()){
	  				str.append("ctrlChecked:true;");//是否选中
	  				//记录选中的节点
                    selectIDList.add(entity.getID());
	  			}else{
	  			  str.append("ctrlChecked:false;");//是否选中
	  			}
	  			str.append("ctrlDisabled:false;");//是否可编辑
	  			str.append("ctrlClick:false;");
			}
			//str.append("url:");
			//str.append("viewDetail.action?ID=" + entity.getID());//点击节点后对应的 URL
			str.append("\'");
			
			out.println(str.toString());	
		  };        
	  %>  
		tree.setURL("#");
		tree.setTarget("viewDetail");
		
<%
		//展开选中数据的节点
		for(int i = 0; i < selectIDList.size(); i ++){
			out.println("tree.focus(\"" + selectIDList.get(i) +"\");");
		}
%>
		
		tree.focus(<%=selectId%>);
		document.write(tree.toString());    
	</script> 
	
	</td>
	</tr>
	</table>
	</div>

    </td>
  	</tr>
</table>
</form>

</body>
</html>