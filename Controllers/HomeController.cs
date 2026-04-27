using Microsoft.AspNetCore.Mvc;
using System.Text.Json;

public class HomeController : Controller
{
    private readonly IHttpClientFactory _httpClientFactory;

    public HomeController(IHttpClientFactory httpClientFactory)
    {
        _httpClientFactory = httpClientFactory;
    }

    public async Task<IActionResult> Index(string book_query)
    {
        var model = new OpenLibraryResponse();
        ViewBag.SearchTerm = book_query;

        if (!string.IsNullOrEmpty(book_query))
        {
            var client = _httpClientFactory.CreateClient();
            var url = $"https://openlibrary.org/search.json?title={Uri.EscapeDataString(book_query)}&limit=8";

            try 
            {
                var response = await client.GetAsync(url);
                if (response.IsSuccessStatusCode)
                {
                    var json = await response.Content.ReadAsStringAsync();
                    model = JsonSerializer.Deserialize<OpenLibraryResponse>(json, 
                        new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
                }
            }
            catch { ViewBag.ErrorMessage = "We couldn't reach Open Library right now."; }
        }

        return View(model);
    }
}