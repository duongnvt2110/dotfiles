# Figma Detail Output Format

## 1) Component Spec Block (per component)
Use this structure for each major component/frame:

Component: <Name> (<Node ID>)
- Size: <W>x<H>
- Layout: <auto-layout direction, alignment, gap, padding>
- Background: <color/gradient/image>
- Border: <width/style/color/radius>
- Shadow: <x/y/blur/spread/color>
- Typography:
  - Font: <family>
  - Size: <px>
  - Weight: <number>
  - Line-height: <px or ratio>
  - Letter-spacing: <px>
  - Color: <hex>
- Children:
  - <Child name>: <role + key properties>
  - ...

## 2) Layer Table Summary
Use a compact table per node:

| Layer | Type | Size | Key styles |
| --- | --- | --- | --- |
| <name> | <type> | <w>x<h> | <fill/border/typography> |

## 3) Summary + Reuse Notes
- Overall layout summary (grid/columns/stack)
- Reuse opportunities (components that can map to existing system)
- Any design constraints or anomalies

## 4) Asset List
List exported assets with file paths:
- <asset name> -> <path>

## Output Rules
- Prefer exact values from Figma.
- If a value is missing/ambiguous, mark as "unknown" and cite the node/layer.
- Keep consistent naming for recurring elements across nodes.
