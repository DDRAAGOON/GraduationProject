namespace Jobito.Api.Models;

public class AppUser
{
    public int Id { get; set; }
    public string Email { get; set; } = "";
    public string Password { get; set; } = "";
    public string Role { get; set; } = "user";
    public string Name { get; set; } = "";
    public string? GoogleId { get; set; }
    public string? PhotoUrl { get; set; }
}
