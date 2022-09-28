using Microsoft.AspNetCore.Mvc;
using Newtonsoft.Json;
using System.Text;
using System.Text.Json;

namespace SimpleApi.Controllers;

[ApiController]
[Route("[controller]")]
public class ConnectController : ControllerBase
{
    private readonly ILogger<ConnectController> _logger;

    public ConnectController(ILogger<ConnectController> logger)
    {
        _logger = logger;
    }

    [HttpPost]
    public void Post([FromBody]JsonDocument jsonDocument)
    {
        using (var stream = new MemoryStream())
        {
            Utf8JsonWriter writer = new Utf8JsonWriter(stream, new JsonWriterOptions { Indented = true });
            jsonDocument.WriteTo(writer);
            writer.Flush();
            string json = Encoding.UTF8.GetString(stream.ToArray());
            _logger.Log(LogLevel.Information, json);
        }
    }
}
