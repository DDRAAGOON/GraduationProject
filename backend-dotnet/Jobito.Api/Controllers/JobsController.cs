using System.Security.Claims;
using Jobito.Api.Data;
using Jobito.Api.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace Jobito.Api.Controllers;

[ApiController]
[Route("api/jobs")]
[Authorize]
public class JobsController(AppDbContext db) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var items = await db.Jobs
            .OrderByDescending(x => x.CreatedAt)
            .Select(x => new
            {
                id = x.Id,
                title = x.Title,
                companyId = x.CompanyId.ToString(),
                companyName = x.CompanyName,
                location = x.Location,
                salaryRange = x.SalaryRange,
                type = x.Type,
                description = x.Description,
                responsibilities = x.ResponsibilitiesCsv.Split('|', StringSplitOptions.RemoveEmptyEntries),
                qualifications = x.QualificationsCsv.Split('|', StringSplitOptions.RemoveEmptyEntries),
                niceToHaves = x.NiceToHavesCsv.Split('|', StringSplitOptions.RemoveEmptyEntries),
                benefits = x.BenefitsCsv.Split('|', StringSplitOptions.RemoveEmptyEntries),
                category = x.Category,
                tags = x.TagsCsv.Split(',', StringSplitOptions.RemoveEmptyEntries),
                createdAt = x.CreatedAt,
                requiredCount = x.RequiredCount,
                acceptedCount = x.AcceptedCount
            })
            .ToListAsync();
        return Ok(items);
    }

    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateJobRequest request)
    {
        if (!User.IsInRole("company"))
        {
            return Forbid();
        }

        if (string.IsNullOrWhiteSpace(request.Title) || string.IsNullOrWhiteSpace(request.CompanyName))
        {
            return BadRequest(new { message = "title and companyName are required" });
        }

        var companyIdClaim = User.FindFirstValue("sub") ?? "0";

        var entity = new JobPost
        {
            Id = $"job_{DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()}",
            Title = request.Title,
            CompanyId = int.TryParse(companyIdClaim, out var idVal) ? idVal : 0,
            CompanyName = request.CompanyName,
            Location = request.Location ?? "Remote",
            SalaryRange = request.SalaryRange ?? "Negotiable",
            Type = request.Type ?? "Full-time",
            Description = request.Description ?? "",
            ResponsibilitiesCsv = request.Responsibilities is { Length: > 0 } ? string.Join("|", request.Responsibilities) : "",
            QualificationsCsv = request.Qualifications is { Length: > 0 } ? string.Join("|", request.Qualifications) : "",
            NiceToHavesCsv = request.NiceToHaves is { Length: > 0 } ? string.Join("|", request.NiceToHaves) : "",
            BenefitsCsv = request.Benefits is { Length: > 0 } ? string.Join("|", request.Benefits) : "",
            Category = request.Category ?? "General",
            TagsCsv = request.Tags is { Length: > 0 } ? string.Join(",", request.Tags) : "",
            CreatedAt = DateTime.UtcNow,
            RequiredCount = request.RequiredCount ?? 1
        };

        db.Jobs.Add(entity);
        db.Notifications.Add(new AppNotification
        {
            Id = $"noti_{DateTimeOffset.UtcNow.ToUnixTimeMilliseconds()}",
            Type = "job_published",
            Text = $"{entity.CompanyName} posted a new role: {entity.Title}",
            CreatedAt = DateTime.UtcNow
        });
        await db.SaveChangesAsync();

        return StatusCode(201, new
        {
            id = entity.Id,
            title = entity.Title,
            companyId = entity.CompanyId.ToString(),
            companyName = entity.CompanyName,
            location = entity.Location,
            salaryRange = entity.SalaryRange,
            type = entity.Type,
            description = entity.Description,
            responsibilities = entity.ResponsibilitiesCsv.Split('|', StringSplitOptions.RemoveEmptyEntries),
            qualifications = entity.QualificationsCsv.Split('|', StringSplitOptions.RemoveEmptyEntries),
            niceToHaves = entity.NiceToHavesCsv.Split('|', StringSplitOptions.RemoveEmptyEntries),
            benefits = entity.BenefitsCsv.Split('|', StringSplitOptions.RemoveEmptyEntries),
            category = entity.Category,
            tags = entity.TagsCsv.Split(',', StringSplitOptions.RemoveEmptyEntries),
            createdAt = entity.CreatedAt,
            requiredCount = entity.RequiredCount,
            acceptedCount = entity.AcceptedCount
        });
    }
}

public class CreateJobRequest
{
    public string? Title { get; set; }
    public string? CompanyName { get; set; }
    public string? Location { get; set; }
    public string? SalaryRange { get; set; }
    public string? Type { get; set; }
    public string? Description { get; set; }
    public string[]? Responsibilities { get; set; }
    public string[]? Qualifications { get; set; }
    public string[]? NiceToHaves { get; set; }
    public string[]? Benefits { get; set; }
    public string? Category { get; set; }
    public string[]? Tags { get; set; }
    public int? RequiredCount { get; set; }
}
