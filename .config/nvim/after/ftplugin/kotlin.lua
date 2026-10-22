-- Kotlin's official style uses four spaces, including Gradle Kotlin scripts.
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.bo.expandtab = true
vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. " | setlocal tabstop< softtabstop< shiftwidth< expandtab<"
