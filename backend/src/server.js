const express = require("express");
const cors = require("cors");
const morgan = require("morgan");
const jwt = require("jsonwebtoken");
require("dotenv").config();

const { store } = require("./data/store");

const app = express();
app.use(cors());
app.use(morgan("dev"));
app.use(express.json());

const PORT = Number(process.env.PORT || 4000);
const JWT_SECRET = process.env.JWT_SECRET || "jobito-secret";

function authRequired(req, res, next) {
  const authHeader = req.headers.authorization || "";
  const token = authHeader.startsWith("Bearer ") ? authHeader.slice(7) : "";
  if (!token) {
    return res.status(401).json({ message: "Unauthorized" });
  }
  try {
    req.user = jwt.verify(token, JWT_SECRET);
    return next();
  } catch (_) {
    return res.status(401).json({ message: "Invalid token" });
  }
}

app.get("/health", (_, res) => {
  res.json({ ok: true, service: "jobito-backend" });
});

app.post("/api/auth/login", (req, res) => {
  const { email, password } = req.body;
  const user = store.users.find((item) => item.email === email && item.password === password);
  if (!user) {
    return res.status(401).json({ message: "Invalid credentials" });
  }
  const token = jwt.sign({ sub: user.id, role: user.role, name: user.name }, JWT_SECRET, {
    expiresIn: "7d"
  });
  return res.json({
    token,
    user: { id: user.id, role: user.role, name: user.name, email: user.email }
  });
});

app.get("/api/jobs", authRequired, (_, res) => {
  res.json(store.jobs);
});

app.post("/api/jobs", authRequired, (req, res) => {
  const payload = req.body;
  if (!payload.title || !payload.companyName) {
    return res.status(400).json({ message: "title and companyName are required" });
  }
  const created = {
    id: `job_${Date.now()}`,
    title: payload.title,
    companyId: req.user.sub,
    companyName: payload.companyName,
    location: payload.location || "Remote",
    salaryRange: payload.salaryRange || "Negotiable",
    type: payload.type || "Full-time",
    tags: Array.isArray(payload.tags) ? payload.tags : [],
    createdAt: new Date().toISOString()
  };
  store.jobs.unshift(created);
  store.notifications.unshift({
    id: `noti_${Date.now()}`,
    type: "job_published",
    text: `${created.companyName} posted a new role: ${created.title}`,
    createdAt: new Date().toISOString()
  });
  return res.status(201).json(created);
});

app.get("/api/applications", authRequired, (_, res) => {
  res.json(store.applications);
});

app.post("/api/applications", authRequired, (req, res) => {
  const { jobId, userName } = req.body;
  const job = store.jobs.find((item) => item.id === jobId);
  if (!job) {
    return res.status(404).json({ message: "Job not found" });
  }
  const created = {
    id: `app_${Date.now()}`,
    userId: req.user.sub,
    userName: userName || req.user.name,
    jobId,
    status: "Applied",
    updatedAt: new Date().toISOString()
  };
  store.applications.unshift(created);
  store.notifications.unshift({
    id: `noti_${Date.now()}`,
    type: "application_created",
    text: `${created.userName} applied for ${job.title}`,
    createdAt: new Date().toISOString()
  });
  return res.status(201).json(created);
});

app.patch("/api/applications/:id/status", authRequired, (req, res) => {
  const appId = req.params.id;
  const { status } = req.body;
  const index = store.applications.findIndex((item) => item.id === appId);
  if (index < 0) {
    return res.status(404).json({ message: "Application not found" });
  }
  store.applications[index].status = status || "In Review";
  store.applications[index].updatedAt = new Date().toISOString();
  const job = store.jobs.find((item) => item.id === store.applications[index].jobId);
  store.messages.unshift({
    id: `msg_${Date.now()}`,
    fromCompany: true,
    text: `Application for ${job ? job.title : "this role"} moved to ${store.applications[index].status}.`,
    createdAt: new Date().toISOString()
  });
  store.notifications.unshift({
    id: `noti_${Date.now()}`,
    type: "application_status_changed",
    text: `Application moved to ${store.applications[index].status}`,
    createdAt: new Date().toISOString()
  });
  return res.json(store.applications[index]);
});

app.get("/api/messages", authRequired, (_, res) => {
  res.json(store.messages);
});

app.post("/api/messages", authRequired, (req, res) => {
  const created = {
    id: `msg_${Date.now()}`,
    fromCompany: req.user.role === "company",
    text: req.body.text || "",
    createdAt: new Date().toISOString()
  };
  store.messages.unshift(created);
  return res.status(201).json(created);
});

app.get("/api/notifications", authRequired, (_, res) => {
  res.json(store.notifications);
});

app.listen(PORT, () => {
  console.log(`Jobito backend listening on ${PORT}`);
});
