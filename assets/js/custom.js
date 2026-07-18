document.addEventListener("DOMContentLoaded", () => {
  const links = Array.from(document.querySelectorAll("#socialMenu a.social-link"));
  const aiLink = links.find((link) => (link.textContent || "").trim().toLowerCase().includes("ai"));
  if (aiLink) {
    aiLink.setAttribute("target", "_blank");
    aiLink.setAttribute("rel", "noopener noreferrer");
    aiLink.setAttribute("title", "Ask AI about me");
    aiLink.setAttribute("aria-label", "Ask AI about me");
  }
});
