//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated from a template.
//
//     Manual changes to this file may cause unexpected behavior in your application.
//     Manual changes to this file will be overwritten if the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace AjaxMvcApplication.Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class book
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public Nullable<int> Pages { get; set; }
        public Nullable<int> YearPress { get; set; }
        public string Themes { get; set; }
        public string Author { get; set; }
        public string Press { get; set; }
        public string Comment { get; set; }
        public Nullable<int> Quantity { get; set; }
    }
}
