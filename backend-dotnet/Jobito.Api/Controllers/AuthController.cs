using Jobito.Api.Data;
using Jobito.Api.Models;
using Jobito.Api.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Google.Apis.Auth;

namespace Jobito.Api.Controllers;

[ApiController]
[Route("api/auth")]
public class AuthController(AppDbContext db, JwtTokenService jwt) : ControllerBase
{
    [HttpPost("login")]
    public async Task<IActionResult> Login([FromBody] LoginRequest request)
    {
        var email = request.Email.Trim().ToLowerInvariant();
        var password = request.Password.Trim();
        if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
        {
            return BadRequest(new { message = "Email and password are required" });
        }

        var user = await db.Users.FirstOrDefaultAsync(
            x => x.Email.ToLower() == email && x.Password == password);

        if (user is null)
        {
            return Unauthorized(new { message = "Invalid credentials" });
        }

        var token = jwt.CreateToken(user);
        return Ok(new
        {
            token,
            user = new
            {
                id = user.Id,
                role = user.Role,
                name = user.Name,
                email = user.Email
            }
        });
    }

    [HttpPost("google")]
    public async Task<IActionResult> GoogleLogin([FromBody] GoogleLoginRequest request)
    {
        try
        {
            var payload = await GoogleJsonWebSignature.ValidateAsync(request.IdToken);
            var email = payload.Email.ToLowerInvariant();
            
            var user = await db.Users.FirstOrDefaultAsync(x => x.Email == email);
            if (user == null)
            {
                user = new AppUser
                {
                    Email = email,
                    Name = payload.Name,
                    GoogleId = payload.Subject,
                    PhotoUrl = payload.Picture,
                    Role = "user" // Default role
                };
                db.Users.Add(user);
            }
            else
            {
                // Sync data
                user.GoogleId = payload.Subject;
                user.PhotoUrl = payload.Picture;
                if (string.IsNullOrWhiteSpace(user.Name)) user.Name = payload.Name;
            }

            await db.SaveChangesAsync();

            var token = jwt.CreateToken(user);
            return Ok(new
            {
                token,
                user = new
                {
                    id = user.Id,
                    role = user.Role,
                    name = user.Name,
                    email = user.Email,
                    photoUrl = user.PhotoUrl
                }
            });
        }
        catch (Exception ex)
        {
            return BadRequest(new { message = "Invalid Google token", details = ex.Message });
        }
    }

    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] RegisterRequest request)
    {
        var email = request.Email.Trim().ToLowerInvariant();
        var password = request.Password.Trim();
        var name = request.Name.Trim();
        var role = request.Role.Trim().ToLowerInvariant();

        if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password) || string.IsNullOrWhiteSpace(name))
        {
            return BadRequest(new { message = "Email, password, and name are required" });
        }

        if (password.Length < 8)
        {
            return BadRequest(new { message = "Password must be at least 8 characters" });
        }

        if (role != "user" && role != "company" && role != "tradesman")
        {
            return BadRequest(new { message = "Role must be 'user', 'company', or 'tradesman'" });
        }

        var existingUser = await db.Users.FirstOrDefaultAsync(x => x.Email.ToLower() == email);
        if (existingUser != null)
        {
            return BadRequest(new { message = "Email already exists" });
        }

        var user = new AppUser
        {
            Email = email,
            Password = password,
            Name = name,
            Role = role
        };

        db.Users.Add(user);
        await db.SaveChangesAsync();

        var token = jwt.CreateToken(user);
        return Ok(new
        {
            token,
            user = new
            {
                id = user.Id,
                role = user.Role,
                name = user.Name,
                email = user.Email
            }
        });
    }
}

public class GoogleLoginRequest
{
    public string IdToken { get; set; } = "";
}

public class LoginRequest
{
    public string Email { get; set; } = "";
    public string Password { get; set; } = "";
}

public class RegisterRequest
{
    public string Email { get; set; } = "";
    public string Password { get; set; } = "";
    public string Name { get; set; } = "";
    public string Role { get; set; } = "user";
}
