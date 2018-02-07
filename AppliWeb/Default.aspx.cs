using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using System.Collections.Generic;

public partial class _Default : System.Web.UI.Page
{
   protected void Page_Load(object sender, EventArgs e)
   {
      Trace.Write("message de trace");
      if (Session["maSession"] == null)
      {
         Session["maSession"] = new MaSession();
      }
      MaSession maSession=(MaSession)Session["maSession"];
      maSession.incrementer();
      
      LabelServeur.Text = "Vous êtes sur le serveur: "+Server.MachineName;
      LabelRefresh.Text = "Nombre de Refresh(s): " + maSession.compteur + "  qui " +
         ((maSession.isCompteurPrime()) ? "EST" : "n'est PAS") + " premier";

      LabelNBtrouvés.Text = ""+maSession.premiersTrouvés.Count;
      String s = "";
      int nb = 0;
      foreach(int p in maSession.premiersTrouvés)
      {
         nb++;
         s += p;
         if (nb<maSession.premiersTrouvés.Count) s += ", ";
      }
      LabelListePrermiers.Text = s;

         
   }
}
