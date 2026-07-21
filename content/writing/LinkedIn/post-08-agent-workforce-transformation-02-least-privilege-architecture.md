# Post 08 - Least privilege is architecture, not a checkbox

## Hook
The cheapest breach to prevent is the one you architect out, not audit out.

## Body
Most organizations treat least privilege as a security review step.

It should be a design constraint.

In agent systems, privilege creep happens fast:
- One agent needs read access → gets contributor
- One workflow needs occasional write → gets owner
- One integration needs "just in case" access → gets global admin

Six months later, every agent has more permissions than most humans.

The fix is not tighter audits. The fix is **least-privilege by default in the architecture**.

What that looks like:
1. Scope identity at creation (not escalation)
2. Grant access per capability, not per agent
3. Build zero-trust pathways (not firewall exceptions)
4. Rotate credentials automatically (not quarterly reviews)

I have seen this firsthand at Microsoft customers: the teams that design privilege into the platform sleep better than the teams that retrofit it during compliance reviews.

## TL;DR
Least privilege for agents is not an audit checklist—it is an architecture constraint that must be designed in from day one.

## CTA
What is harder in your environment: **getting least privilege approved** or **keeping it enforced over time**?

## Hashtags
#ZeroTrust #AIGovernance #PlatformEngineering #EnterpriseAI #SecurityByDesign #AgentWorkforce

## Sources
- [Least privilege for AI agents: Identity, access, and tool binding](https://www.microsoft.com/en-us/security/blog/2026/07/16/least-privilege-for-ai-agents-identity-access-and-tool-binding/)
- [New tools and guidance: Announcing Zero Trust for AI](https://www.microsoft.com/en-us/security/blog/2026/03/19/new-tools-and-guidance-announcing-zero-trust-for-ai/)
- [Govern AI agent identities and access the same way you govern your employees](https://techcommunity.microsoft.com/blog/microsoft-entra-blog/govern-ai-agent-identities-and-access-the-same-way-you-govern-your-employees/4529302)
