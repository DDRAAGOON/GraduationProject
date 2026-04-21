const store = {
  users: [
    { id: "u_1", email: "user@jobito.com", password: "12345678", role: "user", name: "Ahmed User" },
    { id: "c_1", email: "company@jobito.com", password: "12345678", role: "company", name: "Jobito Labs" }
  ],
  jobs: [
    {
      id: "job_1",
      title: "Flutter Mobile Developer",
      companyId: "c_1",
      companyName: "Jobito Labs",
      location: "Cairo, Egypt",
      salaryRange: "20k - 30k EGP",
      type: "Full-time",
      tags: ["Flutter", "Dart", "REST"],
      createdAt: new Date().toISOString()
    }
  ],
  applications: [
    {
      id: "app_1",
      userId: "u_1",
      userName: "Ahmed User",
      jobId: "job_1",
      status: "In Review",
      updatedAt: new Date().toISOString()
    }
  ],
  messages: [
    {
      id: "msg_1",
      fromCompany: true,
      text: "Thanks for applying. We will review your profile today.",
      createdAt: new Date().toISOString()
    }
  ],
  notifications: []
};

module.exports = { store };
