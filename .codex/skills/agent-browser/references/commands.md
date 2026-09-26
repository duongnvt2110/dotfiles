# Agent Browser Command Reference

## Install

```bash
npm install -g agent-browser
agent-browser install
```

## Core workflow

```bash
agent-browser open <url>
agent-browser snapshot -i --json
agent-browser click @e2
agent-browser fill @e3 "value"
agent-browser get text @e1
agent-browser screenshot page.png
agent-browser close
```

## Sessions and CDP

Use `--session <name>` for isolated persistent sessions. Use `--cdp <port>` only when the user intentionally exposes a browser debugging endpoint. Do not assume a Chrome profile path; inspect the current machine or ask when required.

## Useful commands

- Navigation: `open`, `back`, `forward`, `reload`
- Interaction: `click`, `fill`, `type`, `press`, `hover`, `select`, `check`, `upload`
- Inspection: `snapshot`, `get text`, `get html`, `get value`, `get attr`, `get title`, `get url`, `get count`, `get box`
- State: `is visible`, `is enabled`, `is checked`
- Waiting: `wait <selector>`, `wait --text`, `wait --url`, `wait --load networkidle`
- Browser control: `scroll`, `scrollintoview`, `eval`, `cookies`, `storage local`, `tab new`, `frame`, `dialog`

Prefer snapshot refs (`@eN`) from the current page state. Re-snapshot after navigation or major DOM changes before reusing refs.
