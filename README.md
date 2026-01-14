# goto.nvim

See A Path. Open A Path.
---

## ✨ Features

- Just opens a path under your cursor. Either as a buffer or whatever :Ex is bound to
---

## 📦 Requirements

- Neovim 0.9+

---

## 🔧 Installation (Lazy.nvim)

### From GitHub

```lua

return {
    "wfletch/goto.nvim",
    lazy = true,
    keys = {
        {
            "gf",
            function()
                require("goto").open_path_under_cursor()
            end,
            desc = "Open path under cursor",
        },
    },
}
