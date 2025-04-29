vim.diagnostic.config({
  signs = false,
})

vim.filetype.add({
  extension = {
    postcss = "css",
  },
})

local original_text_document_definition = vim.lsp.handlers['textDocument/definition']
local function test_definition(err, result, ...)
  if result and #result > 1 then
    local seen = {}
    local unique_results = {}

    for _, res in ipairs(result) do
      local uri = res.targetUri
      if not seen[uri] then
        table.insert(unique_results, res)
        seen[uri] = true
      end
    end
    return original_text_document_definition(err, unique_results, ...)
  end
  return original_text_document_definition(err, result, ...)
end

vim.lsp.handlers["textDocument/definition"] = test_definition
