﻿using System.Web.Mvc;

namespace SignalRMvc.Controllers
{
    public class HomeController : Controller
    {
        public ActionResult Index()
        {
            return View();
        }
    }
}