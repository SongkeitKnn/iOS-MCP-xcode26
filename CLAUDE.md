# CLAUDE.md

Guidance for Claude Code when working in this repository.

## Skill references (read before starting)

Before beginning any task, read the relevant skill guides under `skill/`:

- **[skill/jira.md](skill/jira.md)** — How to fetch tickets, extract requirements, update status, and comment via the Jira MCP server.
- **[skill/figma.md](skill/figma.md)** — How to pull design specs, download images/icons, set up asset catalogs, and run visual comparisons via the Figma MCP server.
- **[skill/github.md](skill/github.md)** — Branching strategy, commit conventions, PR creation with `gh` CLI, and safety rules.

## Project

iOS SwiftUI app (`iOS-MCP-xcode26`) — Xcode 26 project using `PBXFileSystemSynchronizedRootGroup`, so any file added under `iOS-MCP-xcode26/` is auto-included in the target. Designs live in Figma and are pulled via the Figma MCP server.

Tickets are tracked in Jira; pull them with the Jira MCP server (`mcp__jira__jira_get`) when given a ticket key (e.g. `SCRUM-XX`).

## Design-to-code workflow (required)

When implementing a screen from a Figma design referenced by a ticket:

1. **Pull specs via MCP, never hand-copy values.**
   - `mcp__figma__get_figma_data` for layout, typography, colors, spacing, radii, effects.
   - `mcp__figma__download_figma_images` for image fills and SVG icons.
   - Wire SVG icons as `.imageset` with `preserves-vector-representation: true` and `template-rendering-intent: "template"` so `foregroundStyle` can tint them.

2. **Capture a reference screenshot of the Figma frame.**
   - Export the target frame as PNG at 2x via `mcp__figma__download_figma_images` (pass the frame's nodeId, name it `<screen>_figma.png`, save under `design-refs/`).

3. **Build and run on a Simulator, then capture the rendered screen.**
   - Build: `xcodebuild -project iOS-MCP-xcode26.xcodeproj -scheme iOS-MCP-xcode26 -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath build_output build`
   - Boot/install/launch: `xcrun simctl boot "iPhone 17 Pro"` → `xcrun simctl install booted <app>` → `xcrun simctl launch booted <bundle-id>`
   - Screenshot: `xcrun simctl io booted screenshot design-refs/<screen>_impl.png`

4. **Compare Figma reference vs. simulator screenshot — implementation must match ≥ 80%.**
   - Use the `Read` tool on both PNGs to visually inspect them side by side.
   - Walk through each element: position, size, color, typography weight/size, corner radius, stroke, shadow, gradient stops, spacing between elements, alignment.
   - Score the match honestly. If < 80%, iterate on the SwiftUI code (re-pull Figma specs if values disagree) and re-screenshot until ≥ 80%.
   - Record the final score and any intentional deviations in the PR/task summary.

5. **Do not claim a UI task done without the screenshot comparison.** Type-checks and a green build verify code correctness, not visual fidelity.

## Conventions

- Figma is the source of truth for visual specs — padding, font sizes, colors, radii, shadows. Do not hardcode values that diverge from the Figma.
- Use SF Pro (system font) when a Figma typeface is not bundled; preserve the size/weight from Figma.
- Keep design assets under `iOS-MCP-xcode26/Assets.xcassets/`. Save Figma reference screenshots under `design-refs/` (gitignored if not needed in the repo).
- The Xcode target syncs the `iOS-MCP-xcode26/` folder automatically — no `project.pbxproj` edits needed when adding Swift files.

## Useful commands

```bash
# Build for simulator
xcodebuild -project iOS-MCP-xcode26.xcodeproj -scheme iOS-MCP-xcode26 \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build

# Boot + install + launch
xcrun simctl boot "iPhone 17 Pro"
xcrun simctl install booted <path-to-.app>
xcrun simctl launch booted <bundle-id>

# Screenshot the booted sim
xcrun simctl io booted screenshot design-refs/<screen>_impl.png
```
