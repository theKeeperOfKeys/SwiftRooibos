# Rooibos TeaUI

Rooibos TeaUI, is a terminal UI (TUI) package for Swift, inspired by Go’s [Bubble Tea](https://github.com/charmbracelet/bubbletea), with a some object-oriented design for my sanity.

> ☕️ Like its namesake tea, Rooibos is lightweight, smooth, and plain.

---

## About

Rooibos aims to be an actually OK TUI for swift. It provides fairly low-level control of the terminal's output, just like BubbleTea. I built it for a personal project and for fun — so expect rough edges and some AI-generated code.

---

## Status

⚠️ **Experimental & Incomplete**

- Very early stage: APIs may change.
- Event handling (e.g. keypresses, notifications) is probably poorly done and/or inefficient.
- Documentation is minimal at the moment.
- Contains some AI generated code. (scandalous)
- Not maintained. (But not abandoned either)

---

## Platforms

- macOS 15 or later
- Swift Package Manager

---

## Installation

Using **Swift Package Manager**:

1. Add Rooibos to your `Package.swift` dependencies:
   ```swift
   .package(url: "https://github.com/theKeeperOfKeys/SwiftRooibos.git", branch: "main")
   ...
   .product(name: "Rooibos", package: "swiftrooibos")
   ```
2. Import the package in your code
   ```swift
   import Rooibos
   ```

---

## Usage

Usage examples will be added once the library matures and the API stabilizes. For now, explore the Sources/Example/ folder or read the source code. 

---

## Contributing

Want to help improve Rooibos?

- Refactor or optimize event handling
- Add proper documentation
- Replace AI-generated code (PLEASE 😭)
- Propose new features or patterns
