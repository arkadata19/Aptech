﻿using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(WAD_NguyenVanA.Startup))]
namespace WAD_NguyenVanA
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
