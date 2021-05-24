using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using DotNetApp.Models;
using Microsoft.Extensions.Hosting;

namespace DotNetApp.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IHostApplicationLifetime _applicationLifetime;

        public HomeController(ILogger<HomeController> logger, IHostApplicationLifetime applicationLifetime)
        {
            _logger = logger;
            _applicationLifetime = applicationLifetime;
        }

        public IActionResult Index()
        {
            var now = DateTime.UtcNow;
            _logger.LogInformation(now.ToString());
        
            var podName = Environment.GetEnvironmentVariable("POD_NAME");
            var podIp = Environment.GetEnvironmentVariable("POD_IP");

            return View(new MyModel { Date = now, PodName = podName, PodIp = podIp });
        }

        public IActionResult Stop()
        {
            _applicationLifetime.StopApplication();

            var now = DateTime.UtcNow;
            _logger.LogInformation("Stopping at " + now.ToString());

            var podName = Environment.GetEnvironmentVariable("POD_NAME");
            var podIp = Environment.GetEnvironmentVariable("POD_IP");

            return View(new MyModel { Date = now, PodName = podName, PodIp = podIp });
        }
    }
}
