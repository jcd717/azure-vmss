using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

using System.Collections.Generic;


/// <summary>
/// Description résumée de MaSession
/// </summary>
/// 


[Serializable]
public class MaSession 
{
   public MaSession()
   {
      //
      // TODO : ajoutez ici la logique du constructeur
      //
      
   }

   //public MaSession(int n)
   //{
   //   compteur = n;
   //}

   public int compteur
   {
      get { return _compteur; }
      //set { _compteur = value; }
            
   }

   public void incrementer()
   {
      _compteur++;
   }

   private int _compteur=0;

   //private FourreTout _ft = new FourreTout();

   //public FourreTout fourreTout
   //{
   //   get
   //   {
   //      return _ft;
   //   }
   //}

   private LinkedList<int> _premiersTrouvés=new LinkedList<int>();
   public LinkedList<int> premiersTrouvés
   {
      get { return _premiersTrouvés; }
   }

   public bool isCompteurPrime()
   {
      if (_compteur < 2) return false;
      int limite = (int)Math.Sqrt(_compteur);
      foreach(int p in _premiersTrouvés)
      {
         if(p>limite) break;
         if(_compteur%p ==0) return false;
      }
      _premiersTrouvés.AddLast(_compteur);
      return true;
   }

}
