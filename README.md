# bufmanager.nvim

Add a buffer listing and cleaning manager, with fuzzy find function.

## Installation

### lazy.nvim

```lua
{
    "gw31415/bufmanager.nvim",
    dependencies = {
        "gw31415/fzyselect.vim",
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "fzyselect",
                callback = function()
                    vim.keymap.set("n", "i", "<Plug>(fzyselect-fzy)", { buffer = true })
                    vim.keymap.set("n", "<cr>", "<Plug>(fzyselect-retu)", { buffer = true })
                    vim.keymap.set("n", "<esc>", "<cmd>clo<cr>", { buffer = true })
                end,
            })
        end
    },
    event = "BufAdd",
    config = function()
        vim.keymap.set("n", "gb", function()
            vim.api.nvim_create_autocmd("BufEnter", {
                once = true,
                callback = function()
                    vim.keymap.set({"n", "x"}, "d", "<Plug>(bufmanager-bdelete)", { buffer = true })
                    vim.keymap.set("n", "dd", "<Plug>(bufmanager-bdelete)_", { buffer = true })
                end,
            })
            vim.fn["bufmanager#open"]()
        end)
    end,
}
```

### dein.vim

```toml
[[plugins]]
repo = "gw31415/fzyselect.nvim"
lua_source = '''
vim.api.nvim_create_autocmd("FileType", {
    pattern = "fzyselect",
    callback = function()
        vim.keymap.set("n", "i", "<Plug>(fzyselect-fzy)", { buffer = true })
        vim.keymap.set("n", "<cr>", "<Plug>(fzyselect-retu)", { buffer = true })
        vim.keymap.set("n", "<esc>", "<cmd>clo<cr>", { buffer = true })
    end,
})
'''
[[plugins]]
repo = "gw31415/bufmanager.nvim"
depends = "fzyselect.vim"
on_event = "BufAdd"
lua_source = '''
vim.keymap.set("n", "gb", function()
	vim.api.nvim_create_autocmd("BufEnter", {
		once = true,
		callback = function()
			vim.keymap.set({ "n", "x" }, "d", "<Plug>(bufmanager-bdelete)", { buffer = true })
			vim.keymap.set("n", "dd", "<Plug>(bufmanager-bdelete)_", { buffer = true })
		end,
	})
	vim.fn["bufmanager#open"]()
end)
'''
```

## Usage

- `bufmanager#open` will display a list of buffers other than the one you are
  currently in.
  - They are listed in order of most recently BufEnter.

- Please read the README of
  [fzyselect.vim](https://github.com/gw31415/fzyselect.vim) about fuzzy search.

- `<Plug>(bufmanager-bdelete)` is an operator. It can delete buffers using
  visual mode range selection, motion, or textobj
