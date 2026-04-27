var builder = WebApplication.CreateBuilder(args);

// --- 1. REGISTER SERVICES (Dependency Injection) ---

// Add support for MVC (Controllers and Views)
builder.Services.AddControllersWithViews();

// Register HttpClient so we can make API calls to Open Library
// This is what allows your HomeController to receive an IHttpClientFactory
builder.Services.AddHttpClient();

var app = builder.Build();

// --- 2. CONFIGURE MIDDLEWARE (The Request Pipeline) ---

// Handle errors gracefully in production
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

// Redirect HTTP to HTTPS
app.UseHttpsRedirection();

// Allow the app to serve CSS, JS, and images from the wwwroot folder
app.UseStaticFiles();

app.UseRouting();

// Authorization (needed even if you aren't using it yet for basic MVC)
app.UseAuthorization();

// Define the default route: Home Controller -> Index Action
app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();