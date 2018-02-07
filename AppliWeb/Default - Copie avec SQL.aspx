<%@ Page Language="C#" AutoEventWireup="true"  CodeFile="Default.aspx.cs" Inherits="_Default"  %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Test</title>
</head>
<body >
    <form id="form1" runat="server">
    <div>
    
        <asp:Label ID="LabelServeur" runat="server" Font-Size="X-Large">Serveur</asp:Label>
    
    </div>
    <br/>
    
        <asp:Label ID="LabelRefresh" runat="server" Font-Size="X-Large">Refreshs</asp:Label>
    
    
    
    <p />
    Nombres Premiers trouvés:
    <asp:Label ID="LabelNBtrouvés" runat="server"></asp:Label>
    <br />
    <asp:Label ID="LabelListePrermiers" runat="server"></asp:Label>

	<asp:SqlDataSource
        id="SqlDataSource1"
        runat="server"
        DataSourceMode="DataReader"
        ConnectionString="<%$ ConnectionStrings:DefaultConnection%>"
		ProviderName="<%$ ConnectionStrings:DefaultConnection.ProviderName %>"
        SelectCommand="select top(1) data from azure order by creation desc">
     </asp:SqlDataSource>
	
	<div style="font-size:xx-large; text-align:center">
	  Donnée SQL: 
	 <asp:GridView Font-Size="XX-Large" HorizontalAlign="Center"
		
		ShowHeader="False"
        id="GridView1"
        runat="server"
        DataSourceID="SqlDataSource1">
		
		
     </asp:GridView>

    </div>
    </form>
    
</body>
</html>

