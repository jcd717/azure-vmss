using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

/// <summary>
/// Description résumée de FourreTout
/// </summary>
/// 


[Serializable]
public class FourreTout
{
	public FourreTout()
	{
		//
		// TODO : ajoutez ici la logique du constructeur
		//
      _random = (new Random()).Next(Int32.MaxValue);
	}

   public int random
   {
      get
      {
         return _random;
      }
      
   }

   private int _random;

   public string auteur
   {
      get
      {
         return "Bruno Dubois";
      }
   }

   public void next()
   {
      _random = (new Random()).Next(Int32.MaxValue);
   }

  

}
