<%--
  Created by IntelliJ IDEA.
  User: yang
  Date: 13-5-6
  Time: 下午4:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="jquery-easyui/1.3.3/themes/default/easyui.css">
    <link rel="stylesheet" type="text/css" href="jquery-easyui/1.3.3/themes/icon.css">
    <script type="text/javascript" src="jquery-easyui/1.3.3/jquery.min.js"></script>
    <script type="text/javascript" src="jquery-easyui/1.3.3/jquery.easyui.min.js"></script>
    <script type="text/javascript" src="jquery-easyui/1.3.3/easyui-lang-zh_CN.js"></script>
    <script type="text/javascript">
        $.extend($.fn.window.defaults, {
            collapsible:false,
            minimizable:false,
            maximizable:false,
            resizable:false,
            modal:true
        });
        $.extend($.fn.datagrid.defaults,{
            striped:true,
            rownumbers:true
        });
        function getRids(res,p){
            p=p||'rid';
            var ids=[];
            for(var i=0;i<res.length;i++){
                ids.push(res[i][p]);
            }
            return ids.join(',');
        }
        $(function(){
            //查询
            $('#btn-query').click(function(){
                var ccode=$('#q_ccode').val();
                $('#grid').datagrid('load',{
                   ccode:ccode
                });
            });

            //添加
            $('#btn-add').bind('click', function(){
                $('#add_ff').form('reset');
                $('#add_win').window('open');
            });

            $('#btn_add_win_cancel').click(function(){
                $('#add_win').window('close');
            });
            $('#btn_add_win_ok').click(function(){
                $('#add_ff').submit();
            });

            $('#add_ff').form({
                success:function(data){
                    $('#add_win').window('close');
                    $('#grid').datagrid('reload');
                }
            });

            //修改
            $('#btn-modify').bind('click', function(){
                var res=$('#grid').datagrid('getSelections');
                if(res.length==1){
                    $('#modify_ff').form('load',res[0]);
                    $('#modify_win').window('open');
                }else{
                    $.messager.alert('系统提示','请选中一条!');
                }
            });

            $('#btn_modify_win_cancel').click(function(){
                $('#modify_win').window('close');
            });
            $('#btn_modify_win_ok').click(function(){
                $('#modify_ff').submit();
            });
            $('#modify_ff').form({
                success:function(data){
                    $('#modify_win').window('close');
                    $('#grid').datagrid('reload');
                }
            });

            //删除
            $('#btn-delete').click(function(){
                var res=$('#grid').datagrid('getSelections');
                if(res.length>0){
                    var rids=getRids(res);
                    $.getJSON('baseinfo!delete.do',{rids:rids},function(){
                        $.messager.alert('系统提示','删除成功','',function(){
                            $('#grid').datagrid('reload');
                        });
                    });
                }else{
                    $.messager.alert('系统提示','请选中一些记录!');
                }
            });
        });
    </script>
</head>
<body class="easyui-layout">
<div data-options="region:'center'" style="padding:5px;background:#eee;">
    <table class="easyui-datagrid" id="grid"
           data-options="
           fit:true,url:'baseinfo!query.do',
           fitColumns:true,
           pagination:true,
           toolbar:'#tb',
           title:'数据字典管理'">
        <thead>
        <tr>
            <th data-options="field:'ck',checkbox:true"></th>
            <th data-options="field:'ccode',width:100">Code</th>
            <th data-options="field:'cname',width:100">Name</th>
        </tr>
        </thead>
    </table>
    <div id="tb">
        <%--查询--%>
        <div>
            编号:<input id="q_ccode" type="text"/>
            <a class="easyui-linkbutton" id="btn-query" iconCls="icon-search" plain="true"></a>
        </div>
        <%--操作--%>
        <div>
            <a class="easyui-linkbutton" id="btn-add"  plain="true">添加</a>
            <a class="easyui-linkbutton" id="btn-modify"  plain="true">修改</a>
            <a class="easyui-linkbutton" id="btn-delete" plain="true">删除</a>
        </div>
    </div>
</div>
<div id="add_win" class="easyui-window" data-options="closed:true" title="添加" style="padding:5px;">
    <form id="add_ff" action="baseinfo!add.do" method="post">
        <table>
            <tr>
                <td>编号:</td>
                <td><input name="ccode" class="easyui-validatebox" type="text" required="true"/></td>
            </tr>
            <tr>
                <td>名称:</td>
                <td><input name="cname" class="easyui-validatebox" type="text" required="true"/></td>
            </tr>
        </table>
        <div data-options="border:false" style="text-align:right;">
            <a class="easyui-linkbutton" id="btn_add_win_ok" data-options="iconCls:'icon-ok'" href="javascript:void(0)">确定</a>
            <a class="easyui-linkbutton" id="btn_add_win_cancel" data-options="iconCls:'icon-cancel'" href="javascript:void(0)">取消</a>
        </div>
    </form>
</div>
<div id="modify_win" class="easyui-window" data-options="closed:true" title="添加" style="padding:5px;">
    <form id="modify_ff" action="baseinfo!modify.do" method="post">
        <table>
            <input type="hidden" name="rid"/>
            <tr>
                <td>编号:</td>
                <td><input name="ccode" class="easyui-validatebox" type="text" required="true"/></td>
            </tr>
            <tr>
                <td>名称:</td>
                <td><input name="cname" class="easyui-validatebox" type="text" required="true"/></td>
            </tr>
        </table>
        <div data-options="border:false" style="text-align:right;">
            <a class="easyui-linkbutton" id="btn_modify_win_ok" data-options="iconCls:'icon-ok'" href="javascript:void(0)">确定</a>
            <a class="easyui-linkbutton" id="btn_modify_win_cancel" data-options="iconCls:'icon-cancel'" href="javascript:void(0)">取消</a>
        </div>
    </form>
</div>
</body>
</html>