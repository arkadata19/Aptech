﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;

namespace myapp
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            // Web API routes
            //new
            /*
            config.MapHttpAttributeRoutes();
            config.Routes.MapHttpRoute(
                 name: "ActionApi",
                 routeTemplate: "api/{controller}/{action}/{id}",
                 //api//values/list
                 defaults: new { id = RouteParameter.Optional }
            );
            */
            //old
            
            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
                //api/values
            );
            

        }
    }
}
