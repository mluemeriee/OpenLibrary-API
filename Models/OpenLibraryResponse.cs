public class OpenLibraryResponse
{
    public int NumFound { get; set; }
    public List<BookDoc> Docs { get; set; } = new();
}

public class BookDoc
{
    public string Title { get; set; } = "Untitled";
    public List<string>? Author_Name { get; set; }
    public int? First_Publish_Year { get; set; }
    public List<string>? Subject { get; set; }
    public int Edition_Count { get; set; }
}