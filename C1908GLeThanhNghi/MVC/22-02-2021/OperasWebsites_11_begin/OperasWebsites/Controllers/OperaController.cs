﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;
using OperasWebsites.Models;
using System.Web.UI;

namespace OperasWebSite.Controllers
{
    public class OperaController : Controller
    {
        private OperasDB contextDB = new OperasDB();

        //
        // GET: /Opera/
        [OutputCache(Duration = 600, Location = OutputCacheLocation.Server, VaryByParam = "none")]
        public ActionResult Index()
        {
            return View("Index", contextDB.Operas.ToList());
        }

        public ActionResult Details(int id)
        {
            Opera opera = contextDB.Operas.Find(id);
            if (opera != null)
            {
                return View("Details", opera);
            }
            else
            {
                return HttpNotFound();
            }
        }

        public ActionResult DetailsByTitle(string title)
        {
            Opera opera = (Opera)(from o in contextDB.Operas where o.Title == title select o).FirstOrDefault();

            if (opera == null)
            {
                return HttpNotFound();
            }
            return View("Details", opera);

        }
        [Authorize]
        public ActionResult Create()
        {
            Opera newOpera = new Opera();
            return View("Create", newOpera);
        }

        [HttpPost]
        [Authorize]
        public ActionResult Create(Opera newOpera)
        {
            if (ModelState.IsValid)
            {
                contextDB.Operas.Add(newOpera);
                contextDB.SaveChanges();
                return RedirectToAction("Index");
            }
            else
            {
                return View("Create", newOpera);
            }
        }
    }
}
